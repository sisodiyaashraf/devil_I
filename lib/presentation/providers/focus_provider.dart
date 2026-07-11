import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// RELATIVE IMPORTS
import '../../data/models/habit.dart';
import '../../core/services/sensory_service.dart';
import 'devil_provider.dart';

class FocusProvider extends ChangeNotifier {
  final SensoryService _sensory = SensoryService();

  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalRitualSeconds = 0;
  bool _isRunning = false;
  bool _isFinished = false;

  Habit? _activeHabit;
  String _generatedArtifact = "";

  // --- GETTERS ---
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  bool get isFinished => _isFinished;
  Habit? get activeHabit => _activeHabit;
  String get generatedArtifact => _generatedArtifact;

  /// FEATURE: The Digital HUD Output (MM:SS)
  String get formattedTime {
    int minutes = _remainingSeconds ~/ 60;
    int seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// FEATURE: Drives the "Sensory Orbit" and "Soul Well" (0.0 to 1.0)
  double get progress {
    if (_totalRitualSeconds <= 0) return 0.0;
    double p = (_totalRitualSeconds - _remainingSeconds) / _totalRitualSeconds;
    return p.clamp(0.0, 1.0);
  }

  // --- RITUAL CONTROL ---

  void startFocus(Habit habit, DevilProvider devilProvider) {
    _activeHabit = habit;
    _isFinished = false;
    _remainingSeconds = habit.targetDurationSeconds;
    _totalRitualSeconds = _remainingSeconds;
    _isRunning = true;

    notifyListeners();

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;

        // FEATURE: Pulse Haptics (Escalating Heartbeat)
        _handleSensoryFeedback();

        notifyListeners();
      } else {
        _completeRitual(devilProvider);
      }
    });
  }

  void _handleSensoryFeedback() {
    // KINETIC FEEDBACK:
    // Last 10 seconds: Heavy pulse every second
    if (_remainingSeconds <= 10 && _remainingSeconds > 0) {
      HapticFeedback.heavyImpact();
    }
    // Final 15%: Medium pulse every 2 seconds
    else if (progress > 0.85 && _remainingSeconds % 2 == 0) {
      HapticFeedback.mediumImpact();
    }
    // Rhythmic Milestones: Light pulse every 10% progress
    else if ((progress * 100).toInt() % 10 == 0 && _remainingSeconds % 5 == 0) {
      HapticFeedback.lightImpact();
    }
  }

  /// THE ANTI-CHEAT: Triggered when app is resumed.
  /// In 'Devil_I', minimizing the app is an immediate failure of the pact.
  void syncRitualWithDrift(DevilProvider devilProvider) {
    if (_isRunning) {
      handleAppBackgrounded(devilProvider);
    }
  }

  /// THE TRAP: Minimizing the app breaks the seal
  void handleAppBackgrounded(DevilProvider devilProvider) {
    if (_isRunning && _activeHabit != null) {
      _cancelInternal();

      _sensory.triggerPunishment(isMortal: _activeHabit?.isBloodOath ?? false);
      devilProvider.commitSin(_activeHabit!, trigger: "VOID_INTERRUPTION");

      notifyListeners();
    }
  }

  /// SUCCESS: The timer reached zero
  void _completeRitual(DevilProvider devilProvider) {
    _timer?.cancel();
    _isRunning = false;
    _isFinished = true; // Signals FocusScreen to show Result Card

    if (_activeHabit != null) {
      _generatedArtifact = _generateArtifactName();
      _sensory.triggerReward();
      devilProvider.earnVirtue(_activeHabit!);
    }

    notifyListeners();
  }

  /// User surrenders manually via 'Hold to Break'
  void stopFocusEarly(DevilProvider devilProvider) {
    if (_activeHabit != null) {
      _sensory.triggerPunishment(isMortal: _activeHabit?.isBloodOath ?? false);
      devilProvider.commitSin(_activeHabit!, trigger: "MORTAL_SURRENDER");
    }
    _cancelInternal();
    notifyListeners();
  }

  /// Resets state after Result Card is dismissed
  void dismissResult() {
    _isFinished = false;
    _activeHabit = null;
    _generatedArtifact = "";
    _remainingSeconds = 0;
    _totalRitualSeconds = 0;
    notifyListeners();
  }

  void _cancelInternal() {
    _timer?.cancel();
    _isRunning = false;
    _isFinished = false;
    _remainingSeconds = 0;
  }

  // --- ARTIFACT GENERATOR ---

  String _generateArtifactName() {
    final List<String> prefixes = [
      "DIVINE",
      "ETERNAL",
      "SACRED",
      "UNBREAKABLE",
      "ABYSSAL",
      "CELESTIAL",
      "VOID",
    ];
    final List<String> suffixes = [
      "RESOLVE",
      "ANCHOR",
      "SYMPHONY",
      "MONUMENT",
      "SILENCE",
      "CORE",
      "PULSE",
    ];
    final random = Random();
    return "${prefixes[random.nextInt(prefixes.length)]} ${suffixes[random.nextInt(suffixes.length)]}";
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
