import 'package:flutter/services.dart';

class HapticsService {
  Future<void> lightPulse({bool enabled = true}) async {
    if (!enabled) return;
    await HapticFeedback.lightImpact();
  }

  Future<void> heavyJolt({bool enabled = true}) async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
  }

  Future<void> doubleBeat({bool enabled = true}) async {
    if (!enabled) return;
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 120));
    await HapticFeedback.heavyImpact();
  }
}
