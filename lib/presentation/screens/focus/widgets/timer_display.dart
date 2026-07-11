import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// RELATIVE IMPORT: Ensuring consistency with your FocusProvider
import '../../../providers/focus_provider.dart';

class TimerDisplay extends StatelessWidget {
  final AnimationController pulseController;
  final Color glowColor;

  const TimerDisplay({
    super.key,
    required this.pulseController,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    // Watching the FocusProvider for real-time MM:SS formatting
    final focusProvider = context.watch<FocusProvider>();
    final isRunning = focusProvider.isRunning;
    final progress = focusProvider.progress;

    return AnimatedBuilder(
      animation: pulseController,
      builder: (context, child) {
        // FEATURE: Kinetic Tension
        // As progress increases, the timer's "vibration" and glow intensity increase
        double pulseVal = pulseController.value;
        double tensionFactor =
            1.0 + (progress * 0.5); // Glow grows as time runs out

        double dynamicBlur = isRunning
            ? (20.0 * pulseVal * tensionFactor)
            : 0.0;
        double dynamicOpacity = isRunning ? (0.3 + (0.7 * pulseVal)) : 0.2;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. THE DIGITAL HUD
            Stack(
              alignment: Alignment.center,
              children: [
                // THE GHOST LAYER (Background shadow for depth)
                if (isRunning)
                  Text(
                    focusProvider.formattedTime,
                    style: GoogleFonts.spaceMono(
                      color: glowColor.withOpacity(0.1),
                      fontSize: 82,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 10,
                    ),
                  ),

                // THE MAIN DISPLAY
                Text(
                  focusProvider.formattedTime,
                  style: GoogleFonts.spaceMono(
                    color: isRunning
                        ? Colors.white.withOpacity(dynamicOpacity)
                        : Colors.white10,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8,
                    shadows: isRunning
                        ? [
                            // PRIMARY GLOW
                            Shadow(
                              color: glowColor.withOpacity(0.8),
                              blurRadius: dynamicBlur,
                            ),
                            // ATMOSPHERIC BLEED
                            Shadow(
                              color: glowColor.withOpacity(0.4),
                              blurRadius: dynamicBlur * 2.5,
                            ),
                          ]
                        : [],
                  ),
                ),
              ],
            ),

            // 2. THE SUB-TEXT (Status Indicator)
            const SizedBox(height: 8),
            _buildStatusLabel(isRunning, progress, glowColor),
          ],
        );
      },
    );
  }

  Widget _buildStatusLabel(bool isRunning, double progress, Color accent) {
    String label = "SYSTEM IDLE";
    if (isRunning) {
      if (progress > 0.9)
        label = "FINALIZING SEAL";
      else if (progress > 0.5)
        label = "RITUAL IN PROGRESS";
      else
        label = "SYNCHRONIZING INTENT";
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(
          color: isRunning ? accent.withOpacity(0.2) : Colors.white10,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: GoogleFonts.cinzel(
          color: isRunning ? accent.withOpacity(0.6) : Colors.white10,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
        ),
      ),
    );
  }
}
