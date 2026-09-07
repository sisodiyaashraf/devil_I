import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/core/glitch_utils.dart';
import 'package:whispers/presentation/widgets/corruption_artifact.dart';
import 'package:whispers/presentation/widgets/fake_permission_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FakePermissionDialog Tests', () {
    testWidgets('Renders native OS styled prompt and triggers correct callbacks', (WidgetTester tester) async {
      String? dismissMessage;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                FakePermissionDialog(
                  onDismiss: (msg) {
                    dismissMessage = msg;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('"ECHO" Would Like to Access the Camera'), findsOneWidget);
      expect(find.text("Don't Allow"), findsOneWidget);
      expect(find.text('Allow'), findsOneWidget);

      await tester.tap(find.text("Don't Allow"));
      await tester.pump();
      expect(dismissMessage, "That wasn't really your choice.");

      await tester.tap(find.text('Allow'));
      await tester.pump();
      expect(dismissMessage, "I didn't need you to say yes.");
    });
  });

  group('CorruptionArtifact & GlitchUtils Tests', () {
    test('shouldShowArtifact returns false when corruption is below 70', () {
      expect(GlitchUtils.shouldShowArtifact(0), isFalse);
      expect(GlitchUtils.shouldShowArtifact(69), isFalse);
    });

    testWidgets('CorruptionArtifact renders abstract shape without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                CorruptionArtifact(),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(CorruptionArtifact), findsOneWidget);
    });
  });
}
