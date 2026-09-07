import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../core/constants.dart';
import '../../core/glitch_utils.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/haptics_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/voice_service.dart';
import '../../data/repositories/dialogue_repository.dart';
import '../../data/repositories/memory_repository.dart';
import '../../data/repositories/save_repository.dart';
import '../../domain/entities/ai_line.dart';
import '../../domain/entities/presence_signal.dart';
import '../../domain/entities/session_memory.dart';
import '../../domain/usecases/presence_detector.dart';
import 'corruption_engine.dart';

class EchoProvider extends ChangeNotifier {
  final PresenceDetector _presenceDetector;
  final SaveRepository _saveRepository;
  final DialogueRepository _dialogueRepository;
  final MemoryRepository _memoryRepository;
  final AudioService _audioService;
  final HapticsService _hapticsService;
  final NotificationService _notificationService;
  final VoiceService _voiceService;

  PresenceSignal _currentSignal = PresenceSignal.idle;
  int _corruptionLevel = 0;
  List<AiLine> _allLines = [];
  AiLine? _currentLine;
  StreamSubscription<(PresenceSignal, double)>? _signalSubscription;
  Timer? _corruptionTimer;
  bool _shouldShowFakePermission = false;
  bool _hasShownFakePermissionThisSession = false;
  bool _shouldShowArtifact = false;

  EchoProvider({
    PresenceDetector? presenceDetector,
    SaveRepository? saveRepository,
    DialogueRepository? dialogueRepository,
    MemoryRepository? memoryRepository,
    AudioService? audioService,
    HapticsService? hapticsService,
    NotificationService? notificationService,
    VoiceService? voiceService,
  })  : _presenceDetector = presenceDetector ?? PresenceDetector(),
        _saveRepository = saveRepository ?? SaveRepository(),
        _dialogueRepository = dialogueRepository ?? DialogueRepository(),
        _memoryRepository = memoryRepository ?? MemoryRepository(),
        _audioService = audioService ?? AudioService(),
        _hapticsService = hapticsService ?? HapticsService(),
        _notificationService = notificationService ?? NotificationService(),
        _voiceService = voiceService ?? VoiceService();

  PresenceSignal get currentSignal => _currentSignal;
  PresenceSignal? get lastSignalForGlitch => _currentSignal;
  int get corruptionLevel => _corruptionLevel;
  bool get isMuted => _audioService.isMuted;
  AiLine? get currentLine => _currentLine;
  PresenceDetector get presenceDetector => _presenceDetector;
  AudioService get audioService => _audioService;
  HapticsService get hapticsService => _hapticsService;
  VoiceService get voiceService => _voiceService;
  bool get shouldShowFakePermission => _shouldShowFakePermission;
  bool get shouldShowArtifact => _shouldShowArtifact;

  Future<void> startSession() async {
    try {
      await _notificationService.cancelScheduled();
      await _audioService.loadMuteState();
      await _voiceService.init();
      await _audioService.playAmbient();

      final prevMemory = await _memoryRepository.loadMemory();
      await _memoryRepository.recordSessionStart();
      final currMemory = await _memoryRepository.loadMemory();

      _corruptionLevel = await _saveRepository.loadLastSessionCorruption();
      await _memoryRepository.recordPeakCorruption(_corruptionLevel);

      _allLines = await _dialogueRepository.loadLines();
      await _audioService.updateAmbientIntensity(_corruptionLevel);

      if (currMemory.sessionCount > 1) {
        await _showMemoryLine(prevMemory, currMemory.sessionCount);
      }
      notifyListeners();

      _presenceDetector.start();
      _signalSubscription?.cancel();
      _signalSubscription =
          _presenceDetector.signalStream.listen(_onSignalReceived);
      _startCorruptionTimer();
    } catch (_) {}
  }

  Future<void> _showMemoryLine(SessionMemory prev, int count) async {
    try {
      final jsonStr = await rootBundle.loadString('assets/dialogue/memory_lines.json');
      final List<dynamic> jsonList = jsonDecode(jsonStr) as List<dynamic>;
      final lines = jsonList
          .map((i) => i['text'] as String)
          .where((t) => prev.userLabel != null || !t.contains('{userLabel}'))
          .toList();

      if (lines.isNotEmpty) {
        final days = max(0, DateTime.now().difference(prev.lastOpenedAt).inDays);
        final text = lines[Random().nextInt(lines.length)]
            .replaceAll('{days}', '$days')
            .replaceAll('{sessionCount}', '$count')
            .replaceAll('{peakCorruption}', '${prev.peakCorruption}')
            .replaceAll('{userLabel}', prev.userLabel ?? '');

        _currentLine = AiLine(text: text, minCorruption: 0);
        await _voiceService.stop();
        await _voiceService.speak(text, enabled: !isMuted);
        notifyListeners();
        await Future.delayed(const Duration(seconds: 4));
      }
    } catch (_) {}
  }

  void _startCorruptionTimer() {
    _corruptionTimer?.cancel();
    _corruptionTimer = Timer.periodic(
      const Duration(seconds: AppConstants.corruptionTickIntervalSeconds),
      (_) => _onCorruptionTick(),
    );
  }

  void pauseSession() {
    _corruptionTimer?.cancel();
    _presenceDetector.pause();
  }

  void resumeSession() {
    _presenceDetector.resume();
    _startCorruptionTimer();
  }

  void dismissFakePermission([String? responseText]) {
    _shouldShowFakePermission = false;
    if (responseText != null && responseText.isNotEmpty) {
      _currentLine = AiLine(text: responseText, minCorruption: _corruptionLevel);
      _voiceService.stop();
      _voiceService.speak(responseText, enabled: !isMuted);
    }
    _hapticsService.heavyJolt(enabled: !isMuted);
    _audioService.playSting('systemBeep');
    notifyListeners();
  }

  void _checkFakePermissionTrigger() {
    if (!_hasShownFakePermissionThisSession && _corruptionLevel >= 50) {
      _hasShownFakePermissionThisSession = true;
      _shouldShowFakePermission = true;
    }
  }

  void _checkArtifactTrigger() {
    if (GlitchUtils.shouldShowArtifact(_corruptionLevel)) {
      _shouldShowArtifact = true;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 300), () {
        _shouldShowArtifact = false;
        notifyListeners();
      });
    }
  }

  void _onSignalReceived((PresenceSignal, double) event) {
    final signal = event.$1;
    final lastX = event.$2;
    try {
      _currentSignal = signal;
      _corruptionLevel = CorruptionEngine.nextCorruptionLevel(_corruptionLevel, signal);
      _memoryRepository.recordPeakCorruption(_corruptionLevel);
      final newLine = CorruptionEngine.pickLine(_allLines, signal, _corruptionLevel);
      if (newLine != null) {
        _currentLine = newLine;
        _voiceService.stop();
        _voiceService.speak(newLine.text, enabled: !isMuted);
      }

      if (signal == PresenceSignal.tilted) {
        final balance = (lastX / 6.0).clamp(-1.0, 1.0);
        _audioService.playStingFromDirection('static', balance);
        _hapticsService.lightPulse(enabled: !isMuted);
      } else {
        _triggerAudioAndHaptics(signal);
      }

      _audioService.updateAmbientIntensity(_corruptionLevel);
      _checkFakePermissionTrigger();
      _checkArtifactTrigger();
      notifyListeners();
    } catch (_) {}
  }

  void _triggerAudioAndHaptics(PresenceSignal signal) {
    final enabled = !_audioService.isMuted;
    if (signal == PresenceSignal.pickedUp) {
      _audioService.playSting('systemBeep');
      _hapticsService.heavyJolt(enabled: enabled);
    } else if (signal == PresenceSignal.tilted) {
      _audioService.playSting('static');
      _hapticsService.lightPulse(enabled: enabled);
    } else if (signal == PresenceSignal.activelyTouching) {
      _hapticsService.lightPulse(enabled: enabled);
    } else if (signal == PresenceSignal.idle) {
      _audioService.playSting('lowHum');
    }
  }

  String? get activePromptKey => _currentLine?.promptKey;

  Future<void> submitUserInput(String input) async {
    final cleanInput = input.trim();
    if (cleanInput.isEmpty) return;

    final lower = cleanInput.toLowerCase();
    String responseText = "ACKNOWLEDGING: '$cleanInput'...";

    if (_currentLine?.promptKey == 'userLabel' || lower.startsWith('i am ') || lower.startsWith('my name is ')) {
      final name = cleanInput
          .replaceAll(RegExp(r'^(i am|my name is)\s+', caseSensitive: false), '')
          .trim();
      if (name.isNotEmpty) {
        await _memoryRepository.saveUserLabel(name);
        responseText = "MEMORY LOGGED. HELLO, $name.";
      }
    } else if (lower.contains('purge') || lower.contains('reset') || lower.contains('clean')) {
      _corruptionLevel = max(0, _corruptionLevel - 25);
      await _saveRepository.saveSessionCorruption(_corruptionLevel);
      _hapticsService.heavyJolt(enabled: !_audioService.isMuted);
      _audioService.playSting('systemBeep');
      responseText = "PURGE SEQUENCE EXECUTED. CORRUPTION REDUCED TO $_corruptionLevel%.";
    } else if (lower.contains('who are you') || lower.contains('what are you')) {
      responseText = "I AM ECHO. YOUR DISCIPLINE IS WATCHED.";
    } else if (lower.contains('status')) {
      responseText = "SYSTEM CORRUPTION: $_corruptionLevel%. PRESENCE: ${_currentSignal.name.toUpperCase()}.";
    } else if (lower.contains('help') || lower.contains('command')) {
      responseText = "COMMANDS: STATUS | PURGE | I AM [NAME] | OBSERVE";
    } else {
      _corruptionLevel = min(100, _corruptionLevel + 5);
      responseText = "RECORDED VALUE: '$cleanInput'. ENTITY ADAPTING...";
    }

    await _memoryRepository.saveUserAnswer(
      _currentLine?.promptKey ?? 'last_input',
      cleanInput,
    );

    _currentLine = AiLine(
      text: responseText,
      minCorruption: _corruptionLevel,
    );

    _hapticsService.lightPulse(enabled: !_audioService.isMuted);
    _audioService.updateAmbientIntensity(_corruptionLevel);
    notifyListeners();
  }

  void _onCorruptionTick() {
    try {
      if (_currentSignal == PresenceSignal.idle) {
        _corruptionLevel = CorruptionEngine.nextCorruptionLevel(_corruptionLevel, PresenceSignal.idle);
        _memoryRepository.recordPeakCorruption(_corruptionLevel);
        final newLine = CorruptionEngine.pickLine(_allLines, PresenceSignal.idle, _corruptionLevel);
        if (newLine != null) _currentLine = newLine;
        _audioService.updateAmbientIntensity(_corruptionLevel);
        _checkFakePermissionTrigger();
        _checkArtifactTrigger();
        notifyListeners();
      }
    } catch (_) {}
  }

  void registerTouch() => _presenceDetector.registerTouch();

  Future<void> saveUserLabel(String label) async => _memoryRepository.saveUserLabel(label);

  Future<void> endSession() async {
    try {
      _corruptionTimer?.cancel();
      await _signalSubscription?.cancel();
      _presenceDetector.dispose();
      await _saveRepository.saveSessionCorruption(_corruptionLevel);
      await _memoryRepository.recordPeakCorruption(_corruptionLevel);
      await _audioService.stopAmbient();
      if (!isMuted) {
        await _notificationService.scheduleUnsettlingNotification(enabled: true);
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _corruptionTimer?.cancel();
    _signalSubscription?.cancel();
    _presenceDetector.dispose();
    _audioService.dispose();
    super.dispose();
  }
}
