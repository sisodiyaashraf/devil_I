import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/sensor_utils.dart';
import 'package:whispers/data/repositories/save_repository.dart';
import 'package:whispers/domain/entities/presence_signal.dart';
import 'package:whispers/domain/usecases/presence_detector.dart';
import 'package:whispers/presentation/providers/echo_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sensorChannel = MethodChannel('dev.fluttercommunity.plus/sensors/method');

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sensorChannel, (MethodCall methodCall) async {
      return null;
    });
  });

  group('SensorUtils tests', () {
    test('isSignificantTilt detects strong acceleration deviation', () {
      expect(SensorUtils.isSignificantTilt(0.0, 0.0, 9.81), isFalse);
      expect(SensorUtils.isSignificantTilt(4.0, 0.0, 9.81), isTrue);
      expect(SensorUtils.isSignificantTilt(0.0, 0.0, 15.0), isTrue);
    });

    test('isPickupMotion detects pickup movement pattern', () {
      expect(SensorUtils.isPickupMotion(0.0, 0.0, 9.81), isFalse);
      expect(SensorUtils.isPickupMotion(2.5, 2.5, 12.0), isTrue);
    });
  });

  group('PresenceDetector & EchoProvider tests', () {
    test('registerTouch updates PresenceDetector signal', () async {
      final sensorController = StreamController<AccelerometerEvent>();
      final detector = PresenceDetector(sensorStream: sensorController.stream);
      detector.start();

      expect(detector.currentSignal, PresenceSignal.idle);

      detector.registerTouch();
      expect(detector.currentSignal, PresenceSignal.activelyTouching);

      sensorController.add(AccelerometerEvent(3.0, 3.0, 12.0, DateTime.now()));
      await Future.delayed(Duration.zero);

      expect(detector.currentSignal, PresenceSignal.pickedUp);

      detector.dispose();
      await sensorController.close();
    });

    test('EchoProvider receives signals from PresenceDetector end-to-end', () async {
      final sensorController = StreamController<AccelerometerEvent>();
      final detector = PresenceDetector(sensorStream: sensorController.stream);
      final repository = SaveRepository();
      final provider = EchoProvider(
        presenceDetector: detector,
        saveRepository: repository,
      );

      int notifyCount = 0;
      provider.addListener(() => notifyCount++);

      await provider.startSession();
      expect(provider.currentSignal, PresenceSignal.idle);

      provider.registerTouch();
      await Future.delayed(Duration.zero);

      expect(provider.currentSignal, PresenceSignal.activelyTouching);
      expect(notifyCount, greaterThan(0));

      await provider.endSession();
      await sensorController.close();
    });
  });
}
