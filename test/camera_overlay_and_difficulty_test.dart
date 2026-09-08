import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/domain/entities/presence_signal.dart';
import 'package:whispers/domain/usecases/engagement_tracker.dart';
import 'package:whispers/presentation/providers/corruption_engine.dart';
import 'package:whispers/presentation/widgets/fake_camera_overlay.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('EngagementTracker & Dynamic Difficulty Scaling Tests', () {
    test('Low engagement returns lower scare frequency multiplier (0.7)', () {
      final tracker = EngagementTracker();
      tracker.tick(60); // 1 minute, 0 touches
      expect(tracker.scareFrequencyMultiplier, closeTo(0.7, 0.05));
    });

    test('High engagement returns higher scare frequency multiplier (up to 1.5)', () {
      final tracker = EngagementTracker();
      tracker.tick(60); // 1 minute
      for (int i = 0; i < 15; i++) {
        tracker.recordTouch();
      }
      expect(tracker.scareFrequencyMultiplier, closeTo(1.5, 0.05));
    });

    test('Average time between touches is computed correctly', () {
      final tracker = EngagementTracker();
      tracker.recordTouch();
      tracker.recordTouch();
      tracker.tick(10);
      expect(tracker.averageTimeBetweenTouches, equals(5.0));
    });

    test('CorruptionEngine applies scare frequency multiplier to gain', () {
      final baseGain = CorruptionEngine.nextCorruptionLevel(0, PresenceSignal.idle, 1.0);
      final lowGain = CorruptionEngine.nextCorruptionLevel(0, PresenceSignal.idle, 0.7);
      final highGain = CorruptionEngine.nextCorruptionLevel(0, PresenceSignal.idle, 1.5);

      expect(baseGain, equals(2));
      expect(lowGain, equals(1)); // round(2 * 0.7) = 1
      expect(highGain, equals(3)); // round(2 * 1.5) = 3
    });
  });

  group('FakeCameraOverlay Tests', () {
    testWidgets('Renders viewfinder and REC indicator without camera package', (WidgetTester tester) async {
      bool dismissed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Stack(
              children: [
                FakeCameraOverlay(
                  duration: const Duration(milliseconds: 500),
                  onDismiss: () {
                    dismissed = true;
                  },
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('REC'), findsOneWidget);
      expect(find.byType(FakeCameraOverlay), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 600));
      expect(dismissed, isTrue);
    });
  });
}
