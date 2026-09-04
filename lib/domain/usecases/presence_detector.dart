import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../../core/constants.dart';
import '../../core/sensor_utils.dart';
import '../entities/presence_signal.dart';

class PresenceDetector {
  final StreamController<PresenceSignal> _signalController =
      StreamController<PresenceSignal>.broadcast();
  final Stream<AccelerometerEvent>? _customSensorStream;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;
  Timer? _idleCheckTimer;
  DateTime _lastTouch = DateTime.now();
  PresenceSignal _currentSignal = PresenceSignal.idle;

  PresenceDetector({Stream<AccelerometerEvent>? sensorStream})
      : _customSensorStream = sensorStream;

  Stream<PresenceSignal> get signalStream => _signalController.stream;
  PresenceSignal get currentSignal => _currentSignal;

  void start() {
    _lastTouch = DateTime.now();
    _idleCheckTimer?.cancel();
    _idleCheckTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _checkIdle(),
    );

    try {
      final stream = _customSensorStream ?? accelerometerEventStream();
      _accelSubscription = stream.listen(
        (event) => _onAccelerometerEvent(event.x, event.y, event.z),
        onError: (_) {},
      );
    } catch (_) {}
  }

  void registerTouch() {
    _lastTouch = DateTime.now();
    _emitSignal(PresenceSignal.activelyTouching);
  }

  void _onAccelerometerEvent(double x, double y, double z) {
    if (SensorUtils.isPickupMotion(x, y, z)) {
      _emitSignal(PresenceSignal.pickedUp);
    } else if (SensorUtils.isSignificantTilt(x, y, z)) {
      _emitSignal(PresenceSignal.tilted);
    }
  }

  void _checkIdle() {
    final secondsSinceTouch = DateTime.now().difference(_lastTouch).inSeconds;
    if (secondsSinceTouch >= AppConstants.idleTriggerSeconds) {
      _emitSignal(PresenceSignal.idle);
    }
  }

  void _emitSignal(PresenceSignal signal) {
    if (_signalController.isClosed) return;
    if (_currentSignal != signal) {
      _currentSignal = signal;
      _signalController.add(signal);
    }
  }

  void dispose() {
    _idleCheckTimer?.cancel();
    _accelSubscription?.cancel();
    _signalController.close();
  }
}
