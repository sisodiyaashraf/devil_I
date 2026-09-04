import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/repositories/save_repository.dart';
import '../../domain/entities/presence_signal.dart';
import '../../domain/usecases/presence_detector.dart';

class EchoProvider extends ChangeNotifier {
  final PresenceDetector _presenceDetector;
  final SaveRepository _saveRepository;

  PresenceSignal _currentSignal = PresenceSignal.idle;
  int _corruptionLevel = 0;
  bool _isMuted = false;
  StreamSubscription<PresenceSignal>? _signalSubscription;

  EchoProvider({
    PresenceDetector? presenceDetector,
    SaveRepository? saveRepository,
  })  : _presenceDetector = presenceDetector ?? PresenceDetector(),
        _saveRepository = saveRepository ?? SaveRepository();

  PresenceSignal get currentSignal => _currentSignal;
  int get corruptionLevel => _corruptionLevel;
  bool get isMuted => _isMuted;
  PresenceDetector get presenceDetector => _presenceDetector;

  Future<void> startSession() async {
    _corruptionLevel = await _saveRepository.loadLastSessionCorruption();
    notifyListeners();

    _presenceDetector.start();
    _signalSubscription?.cancel();
    _signalSubscription = _presenceDetector.signalStream.listen((signal) {
      _currentSignal = signal;
      notifyListeners();
    });
  }

  void registerTouch() {
    _presenceDetector.registerTouch();
  }

  Future<void> endSession() async {
    await _signalSubscription?.cancel();
    _presenceDetector.dispose();
    await _saveRepository.saveSessionCorruption(_corruptionLevel);
  }

  @override
  void dispose() {
    _signalSubscription?.cancel();
    _presenceDetector.dispose();
    super.dispose();
  }
}
