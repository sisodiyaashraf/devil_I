import 'package:vibration/vibration.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

class SensoryService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  // --- THE DEVIL'S RAGE (PUNISHMENT) ---

  /// Triggered on Failure. Higher intensity for Blood Oaths.
  Future<void> triggerPunishment({bool isMortal = false}) async {
    // 1. DYNAMIC HAPTIC PATTERN
    // If it's a Mortal Sin/Blood Oath, the vibration is longer and more violent.
    if (await Vibration.hasVibrator()) {
      if (isMortal) {
        // Pattern: [Wait, Vibrate, Wait, Vibrate, Wait, Heavy Vibrate]
        Vibration.vibrate(
          pattern: [0, 200, 100, 200, 100, 1000],
          intensities: [0, 128, 0, 128, 0, 255],
        );
      } else {
        Vibration.vibrate(pattern: [0, 500, 100, 500]);
      }
    }

    // 2. AUDIO FEEDBACK
    // We set the volume high for punishments to ensure the "Growl" is heard.
    await _audioPlayer.setVolume(1.0);
    await _audioPlayer.play(AssetSource('audio/growl.mp3'));

    // Standard system haptic for an "Error" feel
    HapticFeedback.vibrate();
  }

  // --- THE DEVIL'S APPROVAL (REWARD) ---

  /// Triggered on Success. Provides a sense of "Release" or "Sanctuary."
  Future<void> triggerReward() async {
    if (await Vibration.hasVibrator()) {
      // A soft, "pulsing" double-tap
      Vibration.vibrate(pattern: [0, 50, 50, 50]);
    }

    await _audioPlayer.setVolume(0.5);
    await _audioPlayer.play(AssetSource('audio/chime.mp3'));

    // Light system feedback
    HapticFeedback.lightImpact();
  }

  // --- THE RITUAL HEARTBEAT ---

  /// Used during Focus Mode to build psychological tension.
  Future<void> triggerHeartbeat({double intensity = 1.0}) async {
    if (await Vibration.hasVibrator()) {
      // Logic: As the timer nears zero, the vibration gets "sharper"
      int duration = (100 * intensity).toInt().clamp(10, 100);
      Vibration.vibrate(duration: duration);
    }
  }

  // --- SYSTEM UTILS ---

  /// Stop all "Ritual" sounds immediately (Useful when leaving the screen)
  Future<void> silenceTheVoid() async {
    await _audioPlayer.stop();
  }

  /// Dispose of the player when the app is destroyed
  void dispose() {
    _audioPlayer.dispose();
  }
}
