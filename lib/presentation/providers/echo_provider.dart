import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/haptics_service.dart';
import '../../data/repositories/dialogue_repository.dart';
import '../../data/repositories/save_repository.dart';
import '../../domain/entities/ai_line.dart';
import '../../domain/entities/presence_signal.dart';
import '../../domain/usecases/presence_detector.dart';
import 'corruption_engine.dart';

class EchoProvider extends ChangeNotifier {
  final PresenceDetector _presenceDetector;
  final SaveRepository _saveRepository;
  final DialogueRepository _dialogueRepository;
  final AudioService _audioService;
  final HapticsService _hapticsService;

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
    AudioService? audioService,
    HapticsService? hapticsService,
  })  : _presenceDetector = presenceDetector ?? PresenceDetector(),
        _saveRepository = saveRepository ?? SaveRepository(),
        _dialogueRepository = dialogueRepository ?? DialogueRepository(),
        _audioService = audioService ?? AudioService(),
        _hapticsService = hapticsService ?? HapticsService();

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
      await _audioService.loadMuteState();
      await _audioService.playAmbient();
      _corruptionLevel = await _saveRepository.loadLastSessionCorruption();
      _allLines = await _dialogueRepository.loadLines();
      await _audioService.updateAmbientIntensity(_corruptionLevel);
      notifyListeners();

      _presenceDetector.start();
      _signalSubscription?.cancel();
      _signalSubscription =
          _presenceDetector.signalStream.listen(_onSignalReceived);

      _startCorruptionTimer();
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
      _corruptionLevel =
          CorruptionEngine.nextCorruptionLevel(_corruptionLevel, signal);
      final newLine =
          CorruptionEngine.pickLine(_allLines, signal, _corruptionLevel);
      if (newLine != null) {
        _currentLine = newLine;
      }

      _triggerAudioAndHaptics(signal);
      _audioService.updateAmbientIntensity(_corruptionLevel);
      notifyListeners();
    } catch (_) {}
  }

  void _triggerAudioAndHaptics(PresenceSignal signal) {
    final hapticsEnabled = !_audioService.isMuted;
    switch (signal) {
      case PresenceSignal.pickedUp:
        _audioService.playSting('systemBeep');
        _hapticsService.heavyJolt(enabled: hapticsEnabled);
        break;
      case PresenceSignal.tilted:
        _audioService.playSting('static');
        _hapticsService.lightPulse(enabled: hapticsEnabled);
        break;
      case PresenceSignal.activelyTouching:
        _hapticsService.lightPulse(enabled: hapticsEnabled);
        break;
      case PresenceSignal.idle:
        _audioService.playSting('lowHum');
        break;
    }
  }

  void _onCorruptionTick() {
    try {
      if (_currentSignal == PresenceSignal.idle) {
        _corruptionLevel = CorruptionEngine.nextCorruptionLevel(
          _corruptionLevel,
          PresenceSignal.idle,
        );
        final newLine = CorruptionEngine.pickLine(
          _allLines,
          PresenceSignal.idle,
          _corruptionLevel,
        );
        if (newLine != null) {
          _currentLine = newLine;
        }
        _audioService.updateAmbientIntensity(_corruptionLevel);
        notifyListeners();
      }
    } catch (_) {}
  }

  void registerTouch() {
    _presenceDetector.registerTouch();
  }

  Future<void> endSession() async {
    try {
      _corruptionTimer?.cancel();
      await _signalSubscription?.cancel();
      _presenceDetector.dispose();
      await _saveRepository.saveSessionCorruption(_corruptionLevel);
      await _audioService.stopAmbient();
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
