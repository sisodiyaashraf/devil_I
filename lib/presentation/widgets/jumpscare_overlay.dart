import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/services/haptics_service.dart';

class JumpscareOverlay extends StatefulWidget {
  final Widget child;
  final bool trigger;
  final HapticsService? hapticsService;
  final VoidCallback? onFinished;

  const JumpscareOverlay({
    super.key,
    required this.child,
    this.trigger = false,
    this.hapticsService,
    this.onFinished,
  });

  @override
  State<JumpscareOverlay> createState() => _JumpscareOverlayState();
}

class _JumpscareOverlayState extends State<JumpscareOverlay>
    with SingleTickerProviderStateMixin {
  bool _active = false;
  late AnimationController _animController;
  Timer? _vibrateTimer;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    if (widget.trigger) {
      _triggerJumpscare();
    }
  }

  @override
  void didUpdateWidget(JumpscareOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.trigger && !oldWidget.trigger) {
      _triggerJumpscare();
    }
  }

  @override
  void dispose() {
    _vibrateTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  void _triggerJumpscare() {
    if (_active) return;
    setState(() => _active = true);
    _animController.forward(from: 0.0);

    // Haptics series
    widget.hapticsService?.heavyJolt(enabled: true);
    _vibrateTimer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
      if (!mounted || !_active) {
        timer.cancel();
        return;
      }
      widget.hapticsService?.heavyJolt(enabled: true);
    });

    Timer(const Duration(milliseconds: 1400), () {
      _vibrateTimer?.cancel();
      if (mounted) {
        setState(() => _active = false);
        widget.onFinished?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_active)
          AnimatedBuilder(
            animation: _animController,
            builder: (context, _) {
              final progress = _animController.value;
              final shakeX = (math.Random().nextDouble() - 0.5) * 40 * (1 - progress);
              final shakeY = (math.Random().nextDouble() - 0.5) * 40 * (1 - progress);
              final flashRed = math.Random().nextBool();

              return Transform.translate(
                offset: Offset(shakeX, shakeY),
                child: Container(
                  color: flashRed
                      ? Colors.red.shade900.withValues(alpha: 0.95)
                      : Colors.black.withValues(alpha: 0.98),
                  child: Stack(
                    children: [
                      Center(
                        child: CustomPaint(
                          size: const Size(360, 360),
                          painter: CyberEntityPainter(progress: progress),
                        ),
                      ),
                      Positioned(
                        bottom: 60,
                        left: 20,
                        right: 20,
                        child: Text(
                          'DEVIL_I BREACH // NEURAL CORRUPTION',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            letterSpacing: 4,
                            shadows: [
                              Shadow(blurRadius: 10, color: Colors.red),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class CyberEntityPainter extends CustomPainter {
  final double progress;

  CyberEntityPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rand = math.Random();

    // Terrifying Glowing Optics
    final eyePaint = Paint()
      : color = Colors.redAccent
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    canvas.drawCircle(Offset(center.dx - 50, center.dy - 30), 28, eyePaint);
    canvas.drawCircle(Offset(center.dx + 50, center.dy - 30), 28, eyePaint);

    final innerEye = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(center.dx - 50, center.dy - 30), 10, innerEye);
    canvas.drawCircle(Offset(center.dx + 50, center.dy - 30), 10, innerEye);

    // Serrated Mechanical Jaw & Teeth
    final jawPaint = Paint()
      ..color = Colors.red.shade700
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(center.dx - 90, center.dy + 40);

    for (int i = 0; i <= 10; i++) {
      final x = center.dx - 90 + (i * 18);
      final y = center.dy + 40 + (i % 2 == 0 ? 35 : 0) + (rand.nextDouble() * 10);
      path.lineTo(x, y);
    }
    path.lineTo(center.dx + 90, center.dy + 40);
    canvas.drawPath(path, jawPaint);

    // Glitch Scanlines & Glitch Lines
    final glitchPaint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.6)
      ..strokeWidth = 2;

    for (int i = 0; i < 15; i++) {
      final y = rand.nextDouble() * size.height;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y + (rand.nextDouble() - 0.5) * 20),
        glitchPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CyberEntityPainter oldDelegate) => true;
}
