import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FakeCameraOverlay extends StatefulWidget {
  final VoidCallback onDismiss;
  final Duration duration;

  const FakeCameraOverlay({
    super.key,
    required this.onDismiss,
    this.duration = const Duration(seconds: 4),
  });

  @override
  State<FakeCameraOverlay> createState() => _FakeCameraOverlayState();
}

class _FakeCameraOverlayState extends State<FakeCameraOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  Timer? _dismissTimer;
  Timer? _tickTimer;
  int _seconds = 0;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _seconds++);
    });

    _dismissTimer = Timer(widget.duration, () {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _dismissTimer?.cancel();
    _tickTimer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '00:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _StaticFeedPainter(seed: _pulseController.value * _random.nextDouble()),
                  );
                },
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _ViewfinderPainter(),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeTransition(
                      opacity: _pulseController,
                      child: const Row(
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 12),
                          SizedBox(width: 6),
                          Text(
                            'REC',
                            style: TextStyle(
                              color: Colors.red,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _formattedTime,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white54
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final margin = size.width * 0.12;
    final rect = Rect.fromLTRB(margin, size.height * 0.2, size.width - margin, size.height * 0.8);
    const len = 24.0;

    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(len, 0), paint);
    canvas.drawLine(rect.topLeft, rect.topLeft + const Offset(0, len), paint);

    canvas.drawLine(rect.topRight, rect.topRight + const Offset(-len, 0), paint);
    canvas.drawLine(rect.topRight, rect.topRight + const Offset(0, len), paint);

    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(len, 0), paint);
    canvas.drawLine(rect.bottomLeft, rect.bottomLeft + const Offset(0, -len), paint);

    canvas.drawLine(rect.bottomRight, rect.bottomRight + const Offset(-len, 0), paint);
    canvas.drawLine(rect.bottomRight, rect.bottomRight + const Offset(0, -len), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _StaticFeedPainter extends CustomPainter {
  final double seed;
  _StaticFeedPainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random((seed * 10000).toInt());
    final paint = Paint();
    for (int i = 0; i < 60; i++) {
      final y = rng.nextDouble() * size.height;
      final h = rng.nextDouble() * 4 + 1;
      paint.color = Colors.white.withValues(alpha: rng.nextDouble() * 0.08);
      canvas.drawRect(Rect.fromLTWH(0, y, size.width, h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StaticFeedPainter oldDelegate) => oldDelegate.seed != seed;
}
