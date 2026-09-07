import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whispers/core/services/voice_service.dart';
import 'package:whispers/presentation/providers/echo_provider.dart';
import 'package:whispers/presentation/screens/corruption_report_screen.dart';
import 'package:whispers/presentation/screens/scan_intro_screen.dart';

class MockVoiceService extends VoiceService {
  bool speakCalled = false;
  String? lastSpokenText;
  bool stopCalled = false;

  @override
  Future<void> init() async {}

  @override
  Future<void> speak(String text, {bool enabled = true}) async {
    if (enabled) {
      speakCalled = true;
      lastSpokenText = text;
    }
  }

  @override
  Future<void> stop() async {
    stopCalled = true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('VoiceService Tests', () {
    test('VoiceService init and speak complete gracefully when silent/disabled', () async {
      final voice = VoiceService();
      await voice.init();
      await voice.speak('Hello world', enabled: false);
      await voice.stop();
    });

    test('MockVoiceService respects enabled flag when muted', () async {
      final mockVoice = MockVoiceService();
      await mockVoice.speak('Test line', enabled: false);
      expect(mockVoice.speakCalled, isFalse);

      await mockVoice.speak('Test line', enabled: true);
      expect(mockVoice.speakCalled, isTrue);
      expect(mockVoice.lastSpokenText, 'Test line');
    });
  });

  group('ScanIntroScreen Tests', () {
    testWidgets('ScanIntroScreen renders typewriter logs and tap to skip works', (WidgetTester tester) async {
      final provider = EchoProvider(voiceService: MockVoiceService());

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: const MaterialApp(
            home: ScanIntroScreen(),
          ),
        ),
      );

      expect(find.text('SYSTEM DIAGNOSTIC'), findsOneWidget);
      expect(find.text('[TAP TO SKIP]'), findsOneWidget);

      await tester.tap(find.byType(ScanIntroScreen));
      await tester.pumpAndSettle();

      expect(find.byType(ScanIntroScreen), findsNothing);
    });
  });

  group('CorruptionReportScreen Tests', () {
    testWidgets('CorruptionReportScreen displays diagnostic details and buttons', (WidgetTester tester) async {
      final provider = EchoProvider(voiceService: MockVoiceService());

      await tester.pumpWidget(
        ChangeNotifierProvider.value(
          value: provider,
          child: const MaterialApp(
            home: CorruptionReportScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('ECHO // CORRUPTION DIAGNOSTIC'), findsOneWidget);
      expect(find.text('[CLOSE]'), findsOneWidget);
      expect(find.text('[SHARE REPORT]'), findsOneWidget);
    });
  });
}
