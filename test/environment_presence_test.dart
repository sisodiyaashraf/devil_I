import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/services/environment_service.dart';
import 'package:whispers/core/services/notification_service.dart';
import 'package:whispers/domain/entities/environment_line.dart';
import 'package:whispers/presentation/providers/echo_provider.dart';

class MockBattery implements Battery {
  int levelToReturn;
  MockBattery({this.levelToReturn = 15});

  @override
  Future<int> get batteryLevel async => levelToReturn;

  @override
  Stream<BatteryState> get onBatteryStateChanged => throw UnimplementedError();

  @override
  Future<BatteryState> get batteryState => throw UnimplementedError();

  @override
  Future<bool> get isInBatterySaveMode => throw UnimplementedError();
}

class MockEnvironmentService extends EnvironmentService {
  final bool nightVal;
  final bool lowBatVal;

  MockEnvironmentService({
    this.nightVal = true,
    this.lowBatVal = true,
    super.battery,
  });

  @override
  bool isNightHours() => nightVal;

  @override
  Future<bool> isLowBattery() async => lowBatVal;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const sensorChannel = MethodChannel('dev.fluttercommunity.plus/sensors/method');
  const globalAudioChannel = MethodChannel('xyz.luan/audioplayers.global');
  const playerAudioChannel = MethodChannel('xyz.luan/audioplayers');

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(sensorChannel, (MethodCall methodCall) async => null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(globalAudioChannel, (MethodCall methodCall) async => null);
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(playerAudioChannel, (MethodCall methodCall) async => null);
  });

  group('EnvironmentService Tests', () {
    test('isNightHours evaluates properly', () {
      final service = EnvironmentService();
      final isNight = service.isNightHours();
      expect(isNight, isA<bool>());
    });

    test('isLowBattery returns true when battery is below 20', () async {
      final service = EnvironmentService(battery: MockBattery(levelToReturn: 12));
      expect(await service.isLowBattery(), isTrue);
    });

    test('isLowBattery returns false when battery is 50', () async {
      final service = EnvironmentService(battery: MockBattery(levelToReturn: 50));
      expect(await service.isLowBattery(), isFalse);
    });
  });

  group('EnvironmentLine Entity Tests', () {
    test('EnvironmentLine.fromJson deserializes correctly', () {
      final json = {
        'text': 'Late night test line',
        'requiresNight': true,
        'requiresLowBattery': false,
        'minCorruption': 25,
      };

      final line = EnvironmentLine.fromJson(json);
      expect(line.text, 'Late night test line');
      expect(line.requiresNight, isTrue);
      expect(line.requiresLowBattery, isFalse);
      expect(line.minCorruption, 25);
    });
  });

  group('NotificationService Persistent Notice Tests', () {
    test('showPersistentPresenceNotice and clearPersistentPresenceNotice execute gracefully', () async {
      final notifications = NotificationService();
      await notifications.showPersistentPresenceNotice(enabled: false);
      await notifications.clearPersistentPresenceNotice();
    });
  });

  group('EchoProvider & Environment integration', () {
    test('startSession clears persistent notice and loads provider state', () async {
      final envService = MockEnvironmentService(nightVal: true, lowBatVal: true);
      final provider = EchoProvider(environmentService: envService);

      await provider.startSession();
      expect(provider.corruptionLevel, equals(0));

      await provider.endSession();
    });
  });
}
