import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/core/services/haptics_service.dart';
import 'package:whispers/presentation/widgets/glitch_overlay.dart';

class MockHapticsService extends HapticsService {
  @override
  Future<void> heavyJolt({bool enabled = true}) async {}
}

void main() {
  testWidgets('GlitchOverlay triggers visual glitches', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlitchOverlay(
            corruptionLevel: 0,
            forceTrigger: true,
            hapticsService: MockHapticsService(),
            child: const Text('Test Child Text'),
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
