import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../../core/constants.dart';
import '../../core/sensor_utils.dart';
import '../entities/presence_signal.dart';

class PresenceDetector {
  final StreamController<(PresenceSignal, double)> _signalController =
      StreamController<(PresenceSignal, double)>.broadcast();
  final Stream<AccelerometerEvent>? _customSensorStream;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  Timer? _idleCheckTimer;
  DateTime _lastTouch = DateTime.now();
  DateTime? _lastMotionSignalTime;
  PresenceSignal _currentSignal = PresenceSignal.idle;
  double _lastRawX = 0.0;
  bool _isPaused = false;

  PresenceDetector({Stream<AccelerometerEvent>? sensorStream})
      : _customSensorStream = sensorStream;

  Stream<(PresenceSignal, double)> get signalStream => _signalController.stream;
  PresenceSignal get currentSignal => _currentSignal;
  double get lastRawX => _lastRawX;

  void start() {
    _isPaused = false;
    _lastTouch = DateTime.now();
    _startIdleTimer();

    try {
      final stream = _customSensorStream ?? accelerometerEventStream();
      _accelSubscription = stream.listen(
        (event) {
          if (!_isPaused) {
            _onAccelerometerEvent(event.x, event.y, event.z);
          }
        },
        onError: (_) {},
      );
    } catch (_) {}
  }

  void pause() {
    _isPaused = true;
    _idleCheckTimer?.cancel();
    _accelSubscription?.pause();
  }

  void resume() {
    _isPaused = false;
    _lastTouch = DateTime.now();
    _startIdleTimer();
    _accelSubscription?.resume();
  }

  void _startIdleTimer() {
    _idleCheckTimer?.cancel();
    _idleCheckTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _checkIdle(),
    );
  }

  void registerTouch() {
    if (_isPaused) return;
    _lastTouch = DateTime.now();
    _emitSignal(PresenceSignal.activelyTouching, _lastRawX);
  }

  void _onAccelerometerEvent(double x, double y, double z) {
    _lastRawX = x;
    final now = DateTime.now();
    if (_lastMotionSignalTime != null &&
        now.difference(_lastMotionSignalTime!) < const Duration(milliseconds: 1200)) {
      return;
    }

    if (SensorUtils.isPickupMotion(x, y, z)) {
      _lastMotionSignalTime = now;
      _emitSignal(PresenceSignal.pickedUp, x);
    } else if (SensorUtils.isSignificantTilt(x, y, z)) {
      _lastMotionSignalTime = now;
      _emitSignal(PresenceSignal.tilted, x);
    }
  }

  void _checkIdle() {
    if (_isPaused) return;
    final secondsSinceTouch = DateTime.now().difference(_lastTouch).inSeconds;
    if (secondsSinceTouch >= AppConstants.idleTriggerSeconds) {
      _emitSignal(PresenceSignal.idle, _lastRawX);
    }
  }

  void _emitSignal(PresenceSignal signal, [double? rawX]) {
    if (_signalController.isClosed || _isPaused) return;
    if (_currentSignal != signal) {
      _currentSignal = signal;
      _signalController.add((signal, rawX ?? _lastRawX));
    }
  }

  void dispose() {
    _isPaused = true;
    _idleCheckTimer?.cancel();
    _accelSubscription?.cancel();
    _signalController.close();
  }
}
