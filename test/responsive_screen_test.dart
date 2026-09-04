import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/main.dart';

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

  final testSizes = <String, Size>{
    'Small phone (360x640)': const Size(360, 640),
    'Standard phone (390x844)': const Size(390, 844),
    'Large phone (428x926)': const Size(428, 926),
    'Tablet portrait (768x1024)': const Size(768, 1024),
    'Tablet landscape (1024x768)': const Size(1024, 768),
  };

  for (final entry in testSizes.entries) {
    testWidgets('MainScreen renders cleanly without overflow on ${entry.key}', (WidgetTester tester) async {
      tester.view.physicalSize = entry.value;
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const EchoApp());
      await tester.pump();

      expect(find.textContaining('SYSTEM CORRUPTION'), findsOneWidget);
    });
  }
}
