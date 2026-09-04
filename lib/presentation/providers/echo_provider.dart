import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../core/constants.dart';
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

  PresenceSignal _currentSignal = PresenceSignal.idle;
  int _corruptionLevel = 0;
  final bool _isMuted = false;
  List<AiLine> _allLines = [];
  AiLine? _currentLine;

  StreamSubscription<PresenceSignal>? _signalSubscription;
  Timer? _corruptionTimer;

  EchoProvider({
    PresenceDetector? presenceDetector,
    SaveRepository? saveRepository,
    DialogueRepository? dialogueRepository,
  })  : _presenceDetector = presenceDetector ?? PresenceDetector(),
        _saveRepository = saveRepository ?? SaveRepository(),
        _dialogueRepository = dialogueRepository ?? DialogueRepository();

  PresenceSignal get currentSignal => _currentSignal;
  int get corruptionLevel => _corruptionLevel;
  bool get isMuted => _isMuted;
  AiLine? get currentLine => _currentLine;
  PresenceDetector get presenceDetector => _presenceDetector;

  Future<void> startSession() async {
    _corruptionLevel = await _saveRepository.loadLastSessionCorruption();
    _allLines = await _dialogueRepository.loadLines();
    notifyListeners();

    _presenceDetector.start();
    _signalSubscription?.cancel();
    _signalSubscription = _presenceDetector.signalStream.listen(_onSignalReceived);

    _corruptionTimer?.cancel();
    _corruptionTimer = Timer.periodic(
      const Duration(seconds: AppConstants.corruptionTickIntervalSeconds),
      (_) => _onCorruptionTick(),
    );
  }

  void _onSignalReceived(PresenceSignal signal) {
    _currentSignal = signal;
    _corruptionLevel = CorruptionEngine.nextCorruptionLevel(_corruptionLevel, signal);
    final newLine = CorruptionEngine.pickLine(_allLines, signal, _corruptionLevel);
    if (newLine != null) {
      _currentLine = newLine;
    }
    notifyListeners();
  }

  void _onCorruptionTick() {
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
      notifyListeners();
    }
  }

  void registerTouch() {
    _presenceDetector.registerTouch();
  }

  Future<void> endSession() async {
    _corruptionTimer?.cancel();
    await _signalSubscription?.cancel();
    _presenceDetector.dispose();
    await _saveRepository.saveSessionCorruption(_corruptionLevel);
  }

  @override
  void dispose() {
    _corruptionTimer?.cancel();
    _signalSubscription?.cancel();
    _presenceDetector.dispose();
    super.dispose();
  }
}
