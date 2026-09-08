import 'dart:math';
import '../../core/constants.dart';
import '../../domain/entities/ai_line.dart';
import '../../domain/entities/presence_signal.dart';

class CorruptionEngine {
  static final Random _random = Random();

  static int nextCorruptionLevel(
    int current,
    PresenceSignal signal, [
    double multiplier = 1.0,
  ]) {
    int gain;
    switch (signal) {
      case PresenceSignal.activelyTouching:
        gain = 1;
        break;
      case PresenceSignal.tilted:
        gain = 3;
        break;
      case PresenceSignal.pickedUp:
        gain = 5;
        break;
      case PresenceSignal.idle:
        gain = AppConstants.corruptionPerTick;
        break;
    }
    final adjustedGain = max(1, (gain * multiplier).round());
    return (current + adjustedGain).clamp(0, AppConstants.maxCorruptionLevel);
  }

  static AiLine? pickLine(
    List<AiLine> allLines,
    PresenceSignal signal,
    int corruptionLevel, {
    Random? random,
    double multiplier = 1.0,
  }) {
    final rng = random ?? _random;
    final validLines = allLines.where((line) {
      final matchesSignal =
          line.triggeredBy == null || line.triggeredBy == signal;
      final matchesCorruption = line.minCorruption <= corruptionLevel;
      return matchesSignal && matchesCorruption;
    }).toList();

    if (validLines.isEmpty) return null;
    if (multiplier < 1.0 && rng.nextDouble() > multiplier) {
      return null;
    }

    return validLines[rng.nextInt(validLines.length)];
  }
}

