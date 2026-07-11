import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// RELATIVE IMPORTS
import '../../../providers/devil_provider.dart';
import 'glass_card.dart'; // Your unified V2 Glass engine

class ReckoningOverlay extends StatelessWidget {
  const ReckoningOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevilProvider>();

    // Safety check: Only show if the user hasn't acknowledged the daily audit
    if (provider.hasFacedReckoning) return const SizedBox.shrink();

    final report = provider.lastReckoningReport;
    final int purity = report['purity'] ?? 0;

    // THEMATIC ACCENT: Gold for the pure, Crimson for the fallen
    final Color accent = purity == 100 ? Colors.amberAccent : Colors.redAccent;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // 1. THE VOID BLUR (Deep background isolation)
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.85)),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: GlassCard(
                accentColor: accent,
                opacity: 0.12,
                blur: 30,
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // HEADER: THE SYSTEM CALL
                    Text(
                      "THE RECKONING",
                      style: GoogleFonts.cinzel(
                        color: accent.withOpacity(0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 2. THE PURITY ORB (Central Metric)
                    _buildPurityOrb(purity, accent),

                    const SizedBox(height: 40),

                    // 3. THE AUDIT LOG (Detailed Stats)
                    _buildAuditDetail(
                      "CYCLE COMPLETION",
                      "SUCCESS",
                      Colors.white38,
                    ),
                    _buildAuditDetail(
                      "UNFULFILLED VOWS",
                      "${report['sins_added'] ?? 0}",
                      purity == 100 ? Colors.white70 : Colors.redAccent,
                    ),
                    _buildAuditDetail(
                      "SOUL STANDING",
                      purity == 100 ? "STABLE" : "CORRUPTING",
                      accent,
                    ),

                    const SizedBox(height: 40),

                    // 4. THE DEVIL'S TAUNT
                    Text(
                      purity == 100
                          ? "“THE LIGHT FAVORS THE DISCIPLINED.”"
                          : "“EVERY BROKEN VOW IS A DEBT PAID IN BLOOD.”",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceMono(
                        color: Colors.white24,
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // 5. THE ACKNOWLEDGMENT (Ritual Button)
                    _buildAcknowledgeButton(provider, accent),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPurityOrb(int percentage, Color color) {
    return Column(
      children: [
        Text(
          "$percentage%",
          style: GoogleFonts.spaceMono(
            color: Colors.white,
            fontSize: 64,
            fontWeight: FontWeight.w900,
            shadows: [Shadow(color: color.withOpacity(0.8), blurRadius: 40)],
          ),
        ),
        Text(
          "PURITY LEVEL",
          style: GoogleFonts.cinzel(
            color: color,
            fontSize: 10,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildAuditDetail(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(
              color: Colors.white10,
              fontSize: 9,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              color: valueColor,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcknowledgeButton(DevilProvider provider, Color accent) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: accent.withOpacity(0.4), width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: accent.withOpacity(0.02),
        ),
        onPressed: () {
          HapticFeedback.mediumImpact();
          provider.acknowledgeReckoning();
        },
        child: Text(
          "I ACCEPT MY FATE",
          style: GoogleFonts.cinzel(
            color: accent,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
