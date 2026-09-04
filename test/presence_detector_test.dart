import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/sensor_utils.dart';
import 'package:whispers/data/repositories/save_repository.dart';
import 'package:whispers/domain/entities/ai_line.dart';
import 'package:whispers/domain/entities/presence_signal.dart';
import 'package:whispers/domain/usecases/presence_detector.dart';
import 'package:whispers/presentation/providers/corruption_engine.dart';
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

  group('CorruptionEngine tests', () {
    test('nextCorruptionLevel calculates gain and clamps max', () {
      expect(CorruptionEngine.nextCorruptionLevel(0, PresenceSignal.activelyTouching), 1);
      expect(CorruptionEngine.nextCorruptionLevel(0, PresenceSignal.tilted), 3);
      expect(CorruptionEngine.nextCorruptionLevel(0, PresenceSignal.pickedUp), 5);
      expect(CorruptionEngine.nextCorruptionLevel(0, PresenceSignal.idle), 4);
      expect(CorruptionEngine.nextCorruptionLevel(99, PresenceSignal.pickedUp), 100);
    });

    test('pickLine respects signal and corruption threshold', () {
      const lines = [
        AiLine(text: 'Low ambient', triggeredBy: null, minCorruption: 0),
        AiLine(text: 'High tilt', triggeredBy: PresenceSignal.tilted, minCorruption: 50),
      ];

      final lineLow = CorruptionEngine.pickLine(lines, PresenceSignal.tilted, 10);
      expect(lineLow?.text, 'Low ambient');

      final lineHigh = CorruptionEngine.pickLine(lines, PresenceSignal.tilted, 60);
      expect(lineHigh, isNotNull);
    });
  });

  group('EchoProvider & PresenceDetector end-to-end tests', () {
    test('Signals drive corruption escalation and dialogue selection', () async {
      final sensorController = StreamController<AccelerometerEvent>();
      final detector = PresenceDetector(sensorStream: sensorController.stream);
      final repository = SaveRepository();
      final provider = EchoProvider(
        presenceDetector: detector,
        saveRepository: repository,
      );

      await provider.startSession();
      final initialCorruption = provider.corruptionLevel;

      provider.registerTouch();
      await Future.delayed(Duration.zero);

      expect(provider.currentSignal, PresenceSignal.activelyTouching);
      expect(provider.corruptionLevel, greaterThan(initialCorruption));

      await provider.endSession();
      await sensorController.close();
    });
  });
}
