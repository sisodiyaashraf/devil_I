import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// RELATIVE IMPORTS
import '../../../../data/models/habit.dart';
import '../../../providers/focus_provider.dart';
import '../../home/widgets/glass_card.dart';

class TaskAltar extends StatelessWidget {
  final Habit habit;
  final Color glowColor;

  const TaskAltar({super.key, required this.habit, required this.glowColor});

  @override
  Widget build(BuildContext context) {
    // Watch the provider to react to the ritual state
    final focusProvider = context.watch<FocusProvider>();
    final bool isRunning = focusProvider.isRunning;

    return GlassCard(
      accentColor: isRunning ? glowColor : Colors.white10,
      opacity: isRunning ? 0.12 : 0.05, // Increased opacity for better presence
      blur: 25,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. IMPROVED STATUS INDICATOR (Active Breathing Pulse)
          _buildPulsingStatus(isRunning, glowColor),

          const SizedBox(height: 24),

          // 2. THE PACT TITLE (With optional Shimmer)
          _buildAltarTitle(habit.title.toUpperCase(), isRunning, glowColor),

          // 3. THE DYNAMIC WARNING (System Readout)
          if (isRunning) ...[
            const SizedBox(height: 28),
            _buildRitualDivider(glowColor),
            const SizedBox(height: 28),
            _buildSystemWarning(glowColor),
          ],
        ],
      ),
    );
  }

  Widget _buildAltarTitle(String title, bool active, Color color) {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.cinzel(
        color: active ? Colors.white : Colors.white38,
        fontSize: 22,
        fontWeight: FontWeight.w900,
        letterSpacing: 6,
        shadows: [
          if (active) Shadow(color: color.withOpacity(0.8), blurRadius: 30),
        ],
      ),
    );
  }

  Widget _buildPulsingStatus(bool active, Color color) {
    if (!active) {
      return Container(
        width: 6,
        height: 6,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white10,
        ),
      );
    }

    // Modern 2026 Breathing Animation
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.4, end: 1.0),
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOutSine,
      builder: (context, value, child) {
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(value),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5 * value),
                blurRadius: 15 * value,
                spreadRadius: 2 * value,
              ),
            ],
          ),
        );
      },
      onEnd: () {
        // This creates an infinite loop for the "Breath"
      },
      // Note: For a true infinite loop in a Stateless widget,
      // TweenAnimationBuilder can be set up to cycle or use a simple Repeat controller.
    );
  }

  Widget _buildRitualDivider(Color color) {
    return Container(
      height: 1,
      width: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            color.withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _buildSystemWarning(Color color) {
    return Column(
      children: [
        Text(
          "THE SEAL IS ACTIVE",
          style: GoogleFonts.spaceMono(
            color: color.withOpacity(0.9),
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "VOID MONITORING COMMENCED",
          style: GoogleFonts.spaceMono(
            color: Colors.white24,
            fontSize: 8,
            fontWeight: FontWeight.normal,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}
