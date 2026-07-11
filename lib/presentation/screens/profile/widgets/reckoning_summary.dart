import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// RELATIVE IMPORTS
import '../../../../presentation/providers/devil_provider.dart';

class ReckoningSummary extends StatelessWidget {
  const ReckoningSummary({
    super.key,
    required DevilProvider provider,
    required Color glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevilProvider>();
    final realm = provider.currentRealm;
    final habits = provider.habits;

    // Dynamic Accent
    final Color glowColor = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.cyanAccent);

    // Calculate Purity Logic
    final int total = habits.length;
    final int kept = habits.where((h) => h.isCompletedToday).length;
    final String purityPercent = total == 0
        ? "100"
        : (kept / total * 100).toInt().toString();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // SECTION HEADER
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text(
            "THE LAST RECKONING",
            style: GoogleFonts.cinzel(
              color: Colors.white10,
              fontSize: 10,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // GLASS PANEL
        GlassCard(
          accentColor: glowColor,
          opacity: 0.1,
          blur: 20,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER ROW: Title & Large Purity %
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "AUDIT REPORT",
                    style: GoogleFonts.cinzel(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                  Text(
                    "$purityPercent% PURITY",
                    style: GoogleFonts.spaceMono(
                      color: glowColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              const Divider(height: 1, color: Colors.white10),
              const SizedBox(height: 20),

              // DATA ROWS
              _buildAuditRow("PACTS SEALED", "$total", Colors.white38),
              _buildAuditRow("PACTS KEPT", "$kept", Colors.white38),
              _buildAuditRow(
                "SOUL SHIFT",
                provider.soulScore >= 0
                    ? "+${provider.soulScore}"
                    : "${provider.soulScore}",
                glowColor,
              ),

              const SizedBox(height: 24),

              // THE DEVIL'S VERDICT
              _buildVerdict(provider.soulScore, purityPercent),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuditRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cinzel(
              color: Colors.white10,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              color: valueColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerdict(int score, String purity) {
    String taunt = "“THE VOID REMAINS UNCHANGED.”";

    if (score < -5) {
      taunt = "“YOUR DECAY IS AMUSING.”";
    } else if (score > 10 && purity == "100") {
      taunt = "“FOR NOW, YOU ASCEND.”";
    } else if (score > 0) {
      taunt = "“ADEQUATE. DO NOT STUMBLE.”";
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        taunt.toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.spaceMono(
          color: Colors.white24,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
