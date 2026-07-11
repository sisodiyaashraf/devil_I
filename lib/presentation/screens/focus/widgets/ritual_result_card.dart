import 'dart:ui';
import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RitualResultCard extends StatefulWidget {
  final String habitTitle;
  final int soulShift;
  final VoidCallback onDismiss;

  const RitualResultCard({
    super.key,
    required this.habitTitle,
    required this.soulShift,
    required this.onDismiss,
  });

  @override
  State<RitualResultCard> createState() => _RitualResultCardState();
}

class _RitualResultCardState extends State<RitualResultCard> {
  bool _showCloseIcon = false;
  bool _showStats = false;

  @override
  void initState() {
    super.initState();
    _triggerSuccessHaptics();
    Future.delayed(
      const Duration(milliseconds: 600),
      () => setState(() => _showStats = true),
    );
    Future.delayed(
      const Duration(seconds: 2),
      () => setState(() => _showCloseIcon = true),
    );
  }

  void _triggerSuccessHaptics() async {
    for (int i = 0; i < 3; i++) {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }

  @override
  Widget build(BuildContext context) {
    final String artifactName = _generateArtifactName(widget.soulShift);
    final String ritualGrade = _calculateGrade(widget.soulShift);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Positioned.fill(
        child: GlassCard(
          accentColor: Colors.amberAccent,
          opacity: 0.2,
          blur: 40,
          borderRadius: 0, // NO ROUNDED CORNERS
          padding: EdgeInsets.zero,
          child: Container(
            // THE CRITICAL FIX: This forces the container to be the size of the screen
            constraints: const BoxConstraints.expand(),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                child: Column(
                  // THE FIX FOR VERTICAL SPACING
                  children: [
                    const Spacer(flex: 2), // Pushes everything down from top

                    _buildGradeBadge(ritualGrade),

                    const Spacer(flex: 1),

                    _buildArtifactReveal(artifactName),

                    const SizedBox(height: 12),

                    Text(
                      "THE PACT OF ${widget.habitTitle.toUpperCase()}",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.spaceMono(
                        color: Colors.white24,
                        fontSize: 10,
                        letterSpacing: 4,
                      ),
                    ),

                    const Spacer(flex: 2),

                    if (_showStats)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildDataRow(
                            "MORAL FREQUENCY",
                            "+${widget.soulShift} MHz",
                          ),
                          _buildDataRow("REAPING STATUS", "SUCCESSFUL"),
                          _buildDataRow("LEDGER UPDATED", "SYNCHRONIZED"),
                          const SizedBox(height: 20),
                          const Divider(color: Colors.white10, height: 1),
                        ],
                      ),

                    const Spacer(flex: 3),

                    _buildReturnButton(),

                    const SizedBox(height: 20), // Bottom safe buffer
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- REFINED HELPERS ---

  Widget _buildArtifactReveal(String name) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.white, Colors.amberAccent.withOpacity(0.5)],
      ).createShader(bounds),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: GoogleFonts.cinzel(
          fontSize: 26, // Reduced slightly to guarantee fit
          fontWeight: FontWeight.w900,
          letterSpacing: 6,
        ),
      ),
    );
  }

  Widget _buildGradeBadge(String grade) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amberAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.amberAccent.withOpacity(0.2)),
      ),
      child: Text(
        "GRADE: $grade",
        style: GoogleFonts.spaceMono(
          color: Colors.amberAccent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
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

  Widget _buildReturnButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amberAccent,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: widget.onDismiss,
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

  String _generateArtifactName(int score) {
    List<String> prefixes = ["DIVINE", "ETERNAL", "SACRED", "UNBREAKABLE"];
    List<String> suffixes = ["RESOLVE", "ANCHOR", "SYMPHONY", "MONUMENT"];
    return "${prefixes[score % 4]} ${suffixes[(score ~/ 2) % 4]}";
  }

  String _calculateGrade(int score) {
    if (score >= 20) return "ASCENDANT";
    if (score >= 10) return "S+";
    return "A";
  }
}
