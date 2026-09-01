import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/core/services/haptics_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('HapticsService executes without throwing when enabled or disabled', () async {
    final haptics = HapticsService();

    await haptics.lightPulse(enabled: true);
    await haptics.lightPulse(enabled: false);

    await haptics.heavyJolt(enabled: true);
    await haptics.heavyJolt(enabled: false);

    await haptics.doubleBeat(enabled: true);
    await haptics.doubleBeat(enabled: false);
  });
}
