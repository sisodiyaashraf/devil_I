import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/sensor_utils.dart';
import 'package:whispers/data/repositories/save_repository.dart';
import 'package:whispers/domain/entities/presence_signal.dart';
import 'package:whispers/domain/usecases/presence_detector.dart';
import 'package:whispers/presentation/providers/echo_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
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
      final detector = PresenceDetector();
      detector.start();

      expect(detector.currentSignal, PresenceSignal.idle);

      detector.registerTouch();
      expect(detector.currentSignal, PresenceSignal.activelyTouching);

      detector.dispose();
    });

    test('EchoProvider receives signals from PresenceDetector end-to-end', () async {
      final detector = PresenceDetector();
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
    });
  });
}
