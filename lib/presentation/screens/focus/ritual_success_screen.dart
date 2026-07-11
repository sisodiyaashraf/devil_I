import 'dart:ui';
import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RitualSuccessScreen extends StatelessWidget {
  final String habitTitle;
  final String artifactName;
  final String grade;
  final int soulShift;

  const RitualSuccessScreen({
    super.key,
    required this.habitTitle,
    required this.artifactName,
    required this.grade,
    required this.soulShift,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // THE FULL SCREEN GLASS SURFACE
          Positioned.fill(
            child: GlassCard(
              accentColor: Colors.amberAccent,
              opacity: 0.2,
              blur: 40,
              borderRadius: 0,
              padding: EdgeInsets.zero,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      const Spacer(flex: 3),

                      _buildGradeBadge(grade),

                      const Spacer(flex: 1),

                      _buildArtifactReveal(artifactName),

                      const SizedBox(height: 12),

                      Text(
                        "THE PACT OF ${habitTitle.toUpperCase()}",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.spaceMono(
                          color: Colors.white38,
                          fontSize: 10,
                          letterSpacing: 4,
                        ),
                      ),

                      const Spacer(flex: 2),

                      _buildDataRow("MORAL FREQUENCY", "+$soulShift MHz"),
                      _buildDataRow("REAPING STATUS", "SUCCESSFUL"),
                      _buildDataRow("LEDGER UPDATED", "SYNCHRONIZED"),

                      const Spacer(flex: 3),

                      _buildReturnButton(context),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI HELPERS ---

  Widget _buildArtifactReveal(String name) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Colors.white, Colors.amberAccent],
      ).createShader(bounds),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: GoogleFonts.cinzel(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          letterSpacing: 8,
        ),
      ),
    );
  }

  Widget _buildGradeBadge(String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.amberAccent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.amberAccent.withOpacity(0.2)),
      ),
      child: Text(
        "RITUAL GRADE: $grade",
        style: GoogleFonts.spaceMono(
          color: Colors.amberAccent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cinzel(color: Colors.white24, fontSize: 10),
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              color: Colors.amberAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReturnButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
        child: Text(
          "RE-ENTER REALITY",
          style: GoogleFonts.cinzel(
            fontWeight: FontWeight.w900,
            letterSpacing: 4,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
