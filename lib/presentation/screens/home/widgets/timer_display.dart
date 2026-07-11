import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// RELATIVE IMPORTS
import '../../../providers/focus_provider.dart';
import '../../../providers/devil_provider.dart';

class TimerDisplay extends StatefulWidget {
  const TimerDisplay({super.key});

  @override
  State<TimerDisplay> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<TimerDisplay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusProvider>();
    final devilProvider = context.watch<DevilProvider>();

    final isRunning = focusProvider.isRunning;
    final remaining = focusProvider.remainingSeconds;
    final total = focusProvider.activeHabit?.targetDurationSeconds ?? 1;
    final progress = remaining / total;

    final realm = devilProvider.currentRealm;
    Color glowColor = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.grey[400]!);

    // Start/Stop heartbeat
    if (isRunning && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!isRunning) {
      _pulseController.stop();
    }

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        final double pulseVal = isRunning ? _pulseAnimation.value : 0.0;

        // FEATURE 2: Glitch Logic (Final 60 seconds)
        double jitter = (isRunning && remaining < 60)
            ? (math.Random().nextDouble() * 2 - 1)
            : 0;
        Color displayColor = (isRunning && remaining < 60 && remaining % 2 == 0)
            ? Colors.redAccent
            : (isRunning ? Colors.white : Colors.grey[800]!);

        return Stack(
          alignment: Alignment.center,
          children: [
            // FEATURE 1: The Progress Abyss (Depleting ring)
            if (isRunning)
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 2,
                  color: glowColor.withOpacity(0.2 * pulseVal),
                  backgroundColor: Colors.white.withOpacity(0.02),
                ),
              ),

            // MAIN CONTAINER
            Transform.translate(
              offset: Offset(jitter, jitter), // The Glitch Jitter
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF050505).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isRunning
                        ? glowColor.withOpacity(0.3 * pulseVal)
                        : Colors.white10,
                    width: 1.5,
                  ),
                  boxShadow: isRunning
                      ? [
                          BoxShadow(
                            color: glowColor.withOpacity(0.05 * pulseVal),
                            blurRadius: 50,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // TIMER TEXT
                    Text(
                      focusProvider.formattedTime,
                      style: GoogleFonts.spaceMono(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                        color: displayColor,
                        shadows: isRunning
                            ? [
                                Shadow(
                                  color: glowColor.withOpacity(0.6 * pulseVal),
                                  blurRadius: 15,
                                ),
                              ]
                            : [],
                      ),
                    ),

                    // FEATURE 3: Soul-O-Meter
                    if (isRunning) ...[
                      const SizedBox(height: 8),
                      Text(
                        "STAKE: ${focusProvider.activeHabit?.isBloodOath == true ? 'SOUL' : 'VIRTUE'}",
                        style: GoogleFonts.cinzel(
                          color: glowColor.withOpacity(0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
