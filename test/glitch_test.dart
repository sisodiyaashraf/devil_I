import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/presentation/widgets/glitch_overlay.dart';

void main() {
  testWidgets('GlitchOverlay triggers visual glitches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: GlitchOverlay(
            corruptionLevel: 0,
            forceTrigger: true,
            child: Text('Test Child Text'),
          ),
        ),
      ),
    );

    await tester.pump();

    final hasColorInvert = find.byType(ColorFiltered).evaluate().isNotEmpty;
    final hasFakeDialog = find.text('System Error').evaluate().isNotEmpty;

    expect(hasColorInvert || hasFakeDialog, isTrue);

    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.text('System Error'), findsNothing);
  });
}
