import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CameraSurveillanceWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onFail;

  const CameraSurveillanceWidget({
    super.key,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  State<CameraSurveillanceWidget> createState() =>
      _CameraSurveillanceWidgetState();
}

class _CameraSurveillanceWidgetState extends State<CameraSurveillanceWidget> {
  String _selectedCam = 'CAM-01';
  final String _threatCam = 'CAM-03';
  double _scanProgress = 0.0;
  double _timeLeft = 10.0;
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (!mounted || _finished) return;
      setState(() {
        _scanProgress += 0.1;
        _timeLeft -= 0.1;

        if (_timeLeft <= 0) {
          _finished = true;
          widget.onFail();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _isolateThreat() {
    if (_finished) return;
    _finished = true;

    if (_selectedCam == _threatCam) {
      widget.onSuccess();
    } else {
      widget.onFail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isThreatCam = _selectedCam == _threatCam;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        border: Border.all(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'THERMAL CAM MONITORS',
                style: GoogleFonts.shareTechMono(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'TIME: ${_timeLeft.toStringAsFixed(1)}s',
                style: GoogleFonts.shareTechMono(
                  color: Colors.redAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Thermal Viewport
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isThreatCam ? Colors.red.shade950 : Colors.blueGrey.shade900,
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.8)),
            ),
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    size: const Size(200, 100),
                    painter: ThermalCameraPainter(
                      isThreat: isThreatCam,
                      offset: _scanProgress,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Text(
                    '$_selectedCam // ${isThreatCam ? "ANOMALY DETECTED!" : "SIGNAL NORMAL"}',
                    style: GoogleFonts.shareTechMono(
                      color: isThreatCam ? Colors.redAccent : Colors.greenAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'REC',
                        style: GoogleFonts.shareTechMono(
                          color: Colors.redAccent,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Camera Selectors
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['CAM-01', 'CAM-02', 'CAM-03', 'CAM-04'].map((cam) {
              final active = _selectedCam == cam;
              return GestureDetector(
                onTap: () => setState(() => _selectedCam = cam),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: active ? Colors.redAccent : Colors.grey.shade900,
                    border: Border.all(color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    cam,
                    style: GoogleFonts.shareTechMono(
                      color: active ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent.shade700,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 42),
            ),
            onPressed: _isolateThreat,
            child: Text(
              'LOCK DOWN SECTOR THREAT',
              style: GoogleFonts.shareTechMono(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThermalCameraPainter extends CustomPainter {
  final bool isThreat;
  final double offset;

  ThermalCameraPainter({required this.isThreat, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random();
    final center = Offset(size.width / 2, size.height / 2);

    if (isThreat) {
      // Draw cybernetic demon thermal outline
      final paint = Paint()
        ..color = Colors.redAccent.withValues(alpha: 0.8)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

      canvas.drawCircle(center, 35, paint);

      final eyePaint = Paint()..color = Colors.yellowAccent;
      canvas.drawCircle(Offset(center.dx - 12, center.dy - 6), 6, eyePaint);
      canvas.drawCircle(Offset(center.dx + 12, center.dy - 6), 6, eyePaint);
    } else {
      // Draw quiet room contours
      final quietPaint = Paint()
        ..color = Colors.cyanAccent.withValues(alpha: 0.3)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTWH(20, 10, size.width - 40, size.height - 20), quietPaint);
    }

    // Thermal Grid & Scanline
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 1.0;

    final scanY = (offset * 20) % size.height;
    canvas.drawLine(Offset(0, scanY), Offset(size.width, scanY), linePaint);
  }

  @override
  bool shouldRepaint(covariant ThermalCameraPainter oldDelegate) => true;
}
