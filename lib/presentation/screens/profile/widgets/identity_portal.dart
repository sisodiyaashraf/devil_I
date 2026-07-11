import 'dart:math' as math;
import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// RELATIVE IMPORTS
import '../../../../presentation/providers/devil_provider.dart';

class IdentityPortal extends StatelessWidget {
  final String userName;
  final String signedDate;
  final Color glowColor;
  final int soulScore;
  final String realm;

  const IdentityPortal({
    super.key,
    required this.userName,
    required this.signedDate,
    required this.glowColor,
    required this.soulScore,
    required this.realm,
  });

  @override
  Widget build(BuildContext context) {
    // Dynamic Title Logic (The 2026 Progressive Title Engine)
    String mortalTitle = _calculateMortalTitle(soulScore);

    // For Sinners or Neutral, we add a Glitch to the background of the glass
    final bool hasCorruption = soulScore < 10;

    return Column(
      children: [
        // THE SOUL AVATAR (Interactive Fingerprint Core)
        _buildSoulAvatar(hasCorruption),

        const SizedBox(height: 35),

        // GLASS-ENCAPSULATED RANK (V2 Engine)
        GlassCard(
          accentColor: glowColor,
          opacity: 0.12, // Stronger opacity for the Identity anchor
          blur: hasCorruption
              ? 15
              : 25, // Deep frosted for pure souls, sharp for glitch
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              // 1. NAME WITH AURA EFFECT
              Text(
                userName.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.cinzel(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 10,
                  height: 1.1,
                  shadows: [
                    Shadow(color: glowColor.withOpacity(0.8), blurRadius: 30),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              const Divider(height: 1, color: Colors.white10),

              const SizedBox(height: 16),

              // 2. DYNAMIC RANK CHIP
              _buildRankChip(mortalTitle),

              const SizedBox(height: 16),

              // 3. CONTRACT DATE (The psychological anchor)
              Text(
                "CONTRACT SEALED: $signedDate",
                style: GoogleFonts.spaceMono(
                  color: Colors.white12,
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- SUB-WIDGETS ---

  Widget _buildSoulAvatar(bool showCorruption) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // LAYER 1: The Atmospheric Aura Bleed
        _buildAuraBleed(glowColor),

        // LAYER 2: The Core Body (The "Breathing Pulse")
        _buildBreathingCore(glowColor, soulScore),

        // LAYER 3: The Glitch Rings (Corruption only)
        if (showCorruption)
          ...List.generate(3, (index) => _buildGlitchRing(index)),
      ],
    );
  }

  Widget _buildAuraBleed(Color color) {
    return Container(
      width: 170,
      height: 170,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.15), Colors.transparent],
          stops: const [0.4, 1.0],
        ),
      ),
    );
  }

  Widget _buildBreathingCore(Color color, int score) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.92, end: 1.08),
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOutSine,
      builder: (context, scale, child) {
        // Condition: Sinners have a rigid, dead heart (no pulse)
        final effectiveScale = score < 0 ? 1.0 : scale;
        return Transform.scale(
          scale: effectiveScale,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black, // Deep AMOLED Void
              border: Border.all(
                color: score < -15
                    ? Colors.redAccent.withOpacity(0.5)
                    : color.withOpacity(0.5),
                width: 2.5,
              ),
              // Sub-glow effect on the core itself
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.15), blurRadius: 20),
              ],
            ),
            child: _buildFingerprintIcon(color, realm, score),
          ),
        );
      },
    );
  }

  Widget _buildFingerprintIcon(Color color, String realm, int score) {
    IconData icon;
    if (realm == "HEAVEN") {
      icon = Icons.auto_awesome;
    } else if (realm == "HELL") {
      icon = Icons.whatshot_rounded;
    } else {
      icon = Icons.blur_circular_rounded; // The "Wanderer" void
    }

    return Icon(icon, size: 50, color: score < -15 ? Colors.redAccent : color);
  }

  Widget _buildGlitchRing(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 2 * math.pi),
      duration: Duration(seconds: 4 + (index * 2)),
      builder: (context, angle, child) {
        return Transform.rotate(
          angle: soulScore < -15 ? -angle : angle, // Corruption spins reverse
          child: CustomPaint(
            size: Size(130.0 + (index * 15), 130.0 + (index * 15)),
            painter: GlitchRingPainter(
              color: soulScore < -15 ? Colors.redAccent : glowColor,
              opacity: 0.35 - (index * 0.08),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRankChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: glowColor.withOpacity(0.01),
        border: Border.all(color: glowColor.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        title,
        style: GoogleFonts.spaceMono(
          color: glowColor,
          fontSize: 11,
          letterSpacing: 4,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // --- DYNAMIC LOGIC ---

  String _calculateMortalTitle(int score) {
    if (score >= 30) return "THE ASCENDED";
    if (score >= 15) return "THE DISCIPLE";
    if (score <= -30) return "ARCHITECT OF RUIN";
    if (score <= -15) return "THE CONDEMNED";
    return "THE WANDERER";
  }
}

// --- DASHED GLITCH RING PAINTER (The Fix) ---
class GlitchRingPainter extends CustomPainter {
  final Color color;
  final double opacity;

  GlitchRingPainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final Rect rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );

    // Dashing Logic
    const double dashAngle = 0.4; // Radians
    const double gapAngle = 0.6; // Radians

    for (double i = 0; i < 2 * math.pi; i += dashAngle + gapAngle) {
      canvas.drawArc(rect, i, dashAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
