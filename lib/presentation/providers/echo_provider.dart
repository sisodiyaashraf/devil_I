import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../core/constants.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/haptics_service.dart';
import '../../core/services/notification_service.dart';
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

  PresenceSignal _currentSignal = PresenceSignal.idle;
  int _corruptionLevel = 0;
  List<AiLine> _allLines = [];
  AiLine? _currentLine;
  StreamSubscription<PresenceSignal>? _signalSubscription;
  Timer? _corruptionTimer;

  EchoProvider({
    PresenceDetector? presenceDetector,
    SaveRepository? saveRepository,
    DialogueRepository? dialogueRepository,
    MemoryRepository? memoryRepository,
    AudioService? audioService,
    HapticsService? hapticsService,
    NotificationService? notificationService,
  })  : _presenceDetector = presenceDetector ?? PresenceDetector(),
        _saveRepository = saveRepository ?? SaveRepository(),
        _dialogueRepository = dialogueRepository ?? DialogueRepository(),
        _memoryRepository = memoryRepository ?? MemoryRepository(),
        _audioService = audioService ?? AudioService(),
        _hapticsService = hapticsService ?? HapticsService(),
        _notificationService = notificationService ?? NotificationService();

  PresenceSignal get currentSignal => _currentSignal;
  PresenceSignal? get lastSignalForGlitch => _currentSignal;
  int get corruptionLevel => _corruptionLevel;
  bool get isMuted => _audioService.isMuted;
  AiLine? get currentLine => _currentLine;
  PresenceDetector get presenceDetector => _presenceDetector;
  AudioService get audioService => _audioService;
  HapticsService get hapticsService => _hapticsService;

  Future<void> startSession() async {
    try {
      await _notificationService.cancelScheduled();
      await _audioService.loadMuteState();
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

  void _onSignalReceived(PresenceSignal signal) {
    try {
      _currentSignal = signal;
      _corruptionLevel = CorruptionEngine.nextCorruptionLevel(_corruptionLevel, signal);
      _memoryRepository.recordPeakCorruption(_corruptionLevel);
      final newLine = CorruptionEngine.pickLine(_allLines, signal, _corruptionLevel);
      if (newLine != null) _currentLine = newLine;

      _triggerAudioAndHaptics(signal);
      _audioService.updateAmbientIntensity(_corruptionLevel);
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

  void _onCorruptionTick() {
    try {
      if (_currentSignal == PresenceSignal.idle) {
        _corruptionLevel = CorruptionEngine.nextCorruptionLevel(_corruptionLevel, PresenceSignal.idle);
        _memoryRepository.recordPeakCorruption(_corruptionLevel);
        final newLine = CorruptionEngine.pickLine(_allLines, PresenceSignal.idle, _corruptionLevel);
        if (newLine != null) _currentLine = newLine;
        _audioService.updateAmbientIntensity(_corruptionLevel);
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
