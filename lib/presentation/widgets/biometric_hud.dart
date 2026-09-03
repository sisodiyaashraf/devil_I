import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiometricHud extends StatefulWidget {
  final int corruptionLevel;
  final String threatLevel;

  const BiometricHud({
    super.key,
    required this.corruptionLevel,
    this.threatLevel = 'ELEVATED',
  });

  @override
  State<BiometricHud> createState() => _BiometricHudState();
}

class _BiometricHudState extends State<BiometricHud> {
  Timer? _timer;
  int _bpm = 84;
  double _ecgOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (!mounted) return;
      setState(() {
        _ecgOffset += 0.15;
        // BPM increases with corruption level
        final baseBpm = 75 + (widget.corruptionLevel * 6);
        _bpm = baseBpm + (math.Random().nextInt(7) - 3);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Color get _threatColor {
    switch (widget.threatLevel.toUpperCase()) {
      case 'STABLE':
        return Colors.greenAccent;
      case 'ELEVATED':
        return Colors.amberAccent;
      case 'CRITICAL':
        return Colors.orangeAccent;
      case 'ANOMALY':
      default:
        return const Color(0xFFFF1744);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sanityPercent = math.max(0, 100 - (widget.corruptionLevel * 10));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.85),
        border: Border.all(color: _threatColor.withValues(alpha: 0.5), width: 1.2),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: _threatColor.withValues(alpha: 0.15),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.favorite, color: Colors.redAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    '$_bpm BPM',
                    style: GoogleFonts.shareTechMono(
                      color: Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _threatColor.withValues(alpha: 0.2),
                  border: Border.all(color: _threatColor, width: 0.8),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  'THREAT: ${widget.threatLevel.toUpperCase()}',
                  style: GoogleFonts.shareTechMono(
                    color: _threatColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(Icons.psychology, color: Colors.cyanAccent, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    'SANITY: $sanityPercent%',
                    style: GoogleFonts.shareTechMono(
                      color: Colors.cyanAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 20,
            width: double.infinity,
            child: CustomPaint(
              painter: EcgPainter(
                offset: _ecgOffset,
                color: widget.corruptionLevel > 5 ? Colors.redAccent : Colors.greenAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EcgPainter extends CustomPainter {
  final double offset;
  final Color color;

  EcgPainter({required this.offset, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();
    final step = 5.0;
    path.moveTo(0, size.height / 2);

    for (double x = 0; x < size.width; x += step) {
      final pos = (x / 40) + offset;
      double y = size.height / 2;
      final mod = pos % (math.pi * 2);

      if (mod > 1.0 && mod < 1.4) {
        y -= 12;
      } else if (mod >= 1.4 && mod < 1.8) {
        y += 10;
      }

      path.lineTo(x, y);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant EcgPainter oldDelegate) => true;
}
