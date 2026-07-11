import 'dart:math' as math;
import 'package:flutter/material.dart';

class DigitalFingerprint extends StatelessWidget {
  final int soulScore;
  final Color glowColor;

  const DigitalFingerprint({
    super.key,
    required this.soulScore,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    // 2026 LOGIC: Sinners have a chaotic, fast rotation.
    // Saints have a slow, rhythmic pulse.
    final bool isCorrupted = soulScore < 0;
    final double speedMultiplier = isCorrupted ? 2.5 : 1.0;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 1. THE ATMOSPHERIC SHIMMER
        _buildAura(glowColor),

        // 2. THE ROTATING SCANNER RINGS
        _buildRotatingRing(
          index: 1,
          color: glowColor,
          speed: 6.0 / speedMultiplier,
        ),
        _buildRotatingRing(
          index: 2,
          color: isCorrupted ? Colors.redAccent : glowColor,
          speed: 4.0 / speedMultiplier,
        ),

        // 3. THE CORE IDENTITY
        _buildCore(isCorrupted, glowColor),
      ],
    );
  }

  Widget _buildAura(Color color) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color.withOpacity(0.15), Colors.transparent],
          stops: const [0.3, 1.0],
        ),
      ),
    );
  }

  Widget _buildCore(bool corrupted, Color color) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.95, end: 1.05),
      duration: const Duration(seconds: 3),
      curve: Curves.easeInOutSine,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: corrupted ? 1.0 : scale, // Sinners' hearts don't beat
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              border: Border.all(color: color.withOpacity(0.4), width: 1.5),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.1), blurRadius: 20),
              ],
            ),
            child: Icon(
              corrupted
                  ? Icons.fingerprint_rounded
                  : Icons.blur_circular_rounded,
              size: 40,
              color: corrupted ? Colors.redAccent.withOpacity(0.8) : color,
            ),
          ),
        );
      },
    );
  }

  Widget _buildRotatingRing({
    required int index,
    required Color color,
    required double speed,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 2 * math.pi),
      duration: Duration(seconds: speed.toInt()),
      builder: (context, angle, child) {
        return Transform.rotate(
          angle: soulScore < 0
              ? -angle
              : angle, // Reverses direction for sinners
          child: CustomPaint(
            size: Size(100.0 + (index * 15), 100.0 + (index * 15)),
            painter: FingerprintRingPainter(
              color: color,
              opacity: 0.4 - (index * 0.1),
              isCorrupted: soulScore < 0,
            ),
          ),
        );
      },
      onEnd: () {}, // Handled by continuous animation if placed in a loop
    );
  }
}

// THEMATIC CUSTOM PAINTER: Creates the "Dashed/Glitchy" Ring Effect
class FingerprintRingPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final bool isCorrupted;

  FingerprintRingPainter({
    required this.color,
    required this.opacity,
    required this.isCorrupted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(opacity)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final double radius = size.width / 2;
    final Rect rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );

    // If corrupted, rings are "broken" into more frequent, smaller dashes
    final double dashAngle = isCorrupted ? 0.2 : 0.5;
    final double gapAngle = isCorrupted ? 0.8 : 0.4;

    for (double i = 0; i < 2 * math.pi; i += dashAngle + gapAngle) {
      canvas.drawArc(rect, i, dashAngle, false, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
