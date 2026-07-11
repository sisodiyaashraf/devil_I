import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// RELATIVE IMPORTS
import '../../../../presentation/providers/devil_provider.dart';

class StatGrid extends StatelessWidget {
  const StatGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevilProvider>();
    final realm = provider.currentRealm;

    // Dynamic Accent Colors
    final Color glowColor = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.cyanAccent);

    // Aggregate Data
    int totalVirtues = provider.habits.fold(0, (sum, h) => sum + h.virtues);
    int totalSins = provider.habits.fold(0, (sum, h) => sum + h.sins);

    // Calculate Purity Percentage for a 2026 "Audit" look
    double totalActions = (totalVirtues + totalSins).toDouble();
    String purity = totalActions == 0
        ? "100%"
        : "${((totalVirtues / totalActions) * 100).toInt()}%";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER: Standardized Cinzel Spacing
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text(
            "LIFETIME TOLL",
            style: GoogleFonts.cinzel(
              color: Colors.white12,
              fontSize: 10,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // ROW 1: PRIMARY STATS
        Row(
          children: [
            _buildGlassStat(
              label: "VIRTUES",
              value: totalVirtues.toString(),
              accent: Colors.white, // Virtues are pure white light
            ),
            const SizedBox(width: 12),
            _buildGlassStat(
              label: "SINS",
              value: totalSins.toString(),
              accent: Colors.redAccent, // Sins are always blood red
            ),
          ],
        ),

        const SizedBox(height: 12),

        // ROW 2: CORE SOUL METRICS
        Row(
          children: [
            _buildGlassStat(
              label: "SOUL SCORE",
              value: provider.soulScore.toString(),
              accent: glowColor,
              flex: 3, // Emphasize the score
            ),
            const SizedBox(width: 12),
            _buildGlassStat(
              label: "PURITY",
              value: purity,
              accent: glowColor.withOpacity(0.5),
              flex: 2,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGlassStat({
    required String label,
    required String value,
    required Color accent,
    int flex = 1,
  }) {
    return Expanded(
      flex: flex,
      child: GlassCard(
        accentColor: accent,
        padding: const EdgeInsets.symmetric(vertical: 24),
        margin: EdgeInsets.zero,
        opacity: 0.08,
        blur: 20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // THE VALUE: Space Mono for technical precision
            Text(
              value,
              style: GoogleFonts.spaceMono(
                color: accent,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
                shadows: [
                  Shadow(color: accent.withOpacity(0.3), blurRadius: 15),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // THE LABEL: Cinzel for the "Ancient Ledger" feel
            Text(
              label,
              style: GoogleFonts.cinzel(
                color: Colors.white24,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
