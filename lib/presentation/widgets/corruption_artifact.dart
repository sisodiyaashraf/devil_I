import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class CorruptionArtifact extends StatelessWidget {
  const CorruptionArtifact({super.key});

  @override
  Widget build(BuildContext context) {
    final random = Random();
    final topOffset = 0.15 + random.nextDouble() * 0.55;
    final leftOffset = 0.15 + random.nextDouble() * 0.55;

    return Positioned.fill(
      child: IgnorePointer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final x = constraints.maxWidth * leftOffset;
            final y = constraints.maxHeight * topOffset;

            return CustomPaint(
              painter: _ArtifactPainter(
                position: Offset(x, y),
                seed: random.nextInt(1000),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ArtifactPainter extends CustomPainter {
  final Offset position;
  final int seed;

  _ArtifactPainter({required this.position, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(seed);
    final center = position;

    final redPaint = Paint()
      ..color = AppColors.corruptRed.withValues(alpha: 0.65)
      ..style = PaintingStyle.fill;

    final grayPaint = Paint()
      ..color = AppColors.staticGray.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    final darkPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.7)
      ..style = PaintingStyle.fill;

    final headPath = Path();
    headPath.addPolygon([
      Offset(center.dx - 8 + random.nextDouble() * 4, center.dy - 35),
      Offset(center.dx + 10 + random.nextDouble() * 4, center.dy - 32),
      Offset(center.dx + 6, center.dy - 12),
      Offset(center.dx - 10, center.dy - 15),
    ], true);
    canvas.drawPath(headPath, redPaint);

    final torsoPath = Path();
    torsoPath.addPolygon([
      Offset(center.dx - 14, center.dy - 10),
      Offset(center.dx + 16, center.dy - 12),
      Offset(center.dx + 22 + random.nextDouble() * 8, center.dy + 30),
      Offset(center.dx - 18, center.dy + 35),
    ], true);
    canvas.drawPath(torsoPath, grayPaint);

    final limbPath = Path();
    limbPath.addPolygon([
      Offset(center.dx - 18, center.dy + 35),
      Offset(center.dx - 28 - random.nextDouble() * 10, center.dy + 70),
      Offset(center.dx - 12, center.dy + 65),
      Offset(center.dx - 6, center.dy + 38),
    ], true);
    canvas.drawPath(limbPath, redPaint);

    final rightLimbPath = Path();
    rightLimbPath.addPolygon([
      Offset(center.dx + 12, center.dy + 30),
      Offset(center.dx + 26 + random.nextDouble() * 12, center.dy + 75),
      Offset(center.dx + 14, center.dy + 70),
      Offset(center.dx + 4, center.dy + 34),
    ], true);
    canvas.drawPath(rightLimbPath, darkPaint);

    for (int i = 0; i < 4; i++) {
      final rx = center.dx + (random.nextDouble() - 0.5) * 60;
      final ry = center.dy + (random.nextDouble() - 0.5) * 90;
      final rw = 4.0 + random.nextDouble() * 16;
      final rh = 2.0 + random.nextDouble() * 6;
      canvas.drawRect(
        Rect.fromLTWH(rx, ry, rw, rh),
        i % 2 == 0 ? redPaint : grayPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
