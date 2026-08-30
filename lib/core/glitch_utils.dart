import 'dart:math';

class GlitchUtils {
  static final Random _random = Random();

  static bool shouldTrigger(int corruptionLevel) {
    final double probability = (corruptionLevel / 100.0) * 0.3;
    return _random.nextDouble() < probability;
  }

  static Duration randomFlickerDuration() {
    final int durationMs = 80 + _random.nextInt(161);
    return Duration(milliseconds: durationMs);
  }
}
