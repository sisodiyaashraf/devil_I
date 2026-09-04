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

  testWidgets('App renders EchoApp MainScreen with corruption meter', (WidgetTester tester) async {
    await tester.pumpWidget(const EchoApp());
    await tester.pump();

    expect(find.textContaining('SYSTEM CORRUPTION'), findsOneWidget);
  });
}
