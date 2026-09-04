import 'dart:math';
import '../domain/entities/presence_signal.dart';

enum GlitchEffect { rgbSplit, colorInvert, fakeDialog }

class GlitchUtils {
  static final Random _random = Random();

  static bool shouldTrigger(int corruptionLevel) {
    final double probability = (corruptionLevel / 100.0) * 0.5;
    return _random.nextDouble() < probability;
  }

  static bool shouldHardTrigger(PresenceSignal? signal) {
    return signal == PresenceSignal.pickedUp;
  }

  static Duration randomFlickerDuration() {
    final int durationMs = 80 + _random.nextInt(161);
    return Duration(milliseconds: durationMs);
  }

  static GlitchEffect pickEffect({bool isHardTrigger = false}) {
    if (isHardTrigger) {
      final hardEffects = [GlitchEffect.fakeDialog, GlitchEffect.rgbSplit];
      return hardEffects[_random.nextInt(hardEffects.length)];
    }
    return GlitchEffect.values[_random.nextInt(GlitchEffect.values.length)];
  }
}
