import 'dart:math' as math;
import 'package:flutter/material.dart';

class Particle {
  double x;
  double y;
  double size;
  double speed;
  double opacity;
  double angle;
  double sinOffset;
  double sinSpeed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.angle,
    required this.sinOffset,
    required this.sinSpeed,
  });
}

class AmbientParticles extends StatefulWidget {
  final String realm;
  final Color color;

  const AmbientParticles({
    super.key,
    required this.realm,
    required this.color,
  });

  @override
  State<AmbientParticles> createState() => _AmbientParticlesState();
}

class _AmbientParticlesState extends State<AmbientParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final math.Random _random = math.Random();
  static const int _maxParticles = 40;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    _initParticles();
  }

  @override
  void didUpdateWidget(covariant AmbientParticles oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.realm != widget.realm) {
      _initParticles();
    }
  }

  void _initParticles() {
    _particles.clear();
    for (int i = 0; i < _maxParticles; i++) {
      _particles.add(_generateParticle(isInitial: true));
    }
  }

  Particle _generateParticle({bool isInitial = false}) {
    return Particle(
      x: _random.nextDouble(),
      y: isInitial ? _random.nextDouble() : (widget.realm == 'HELL' ? 1.05 : -0.05),
      size: 1.5 + _random.nextDouble() * 3.5,
      speed: 0.005 + _random.nextDouble() * 0.012,
      opacity: 0.1 + _random.nextDouble() * 0.5,
      angle: _random.nextDouble() * 2 * math.pi,
      sinOffset: _random.nextDouble() * 100,
      sinSpeed: 0.02 + _random.nextDouble() * 0.05,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateParticles() {
    for (int i = 0; i < _particles.length; i++) {
      final p = _particles[i];
      p.sinOffset += p.sinSpeed;

      if (widget.realm == 'HELL') {
        // Drifting UPWARD
        p.y -= p.speed;
        p.x += math.sin(p.sinOffset) * 0.002;
        if (p.y < -0.05) {
          _particles[i] = _generateParticle();
        }
      } else if (widget.realm == 'HEAVEN') {
        // Drifting DOWNWARD
        p.y += p.speed;
        p.x += math.sin(p.sinOffset) * 0.002;
        if (p.y > 1.05) {
          _particles[i] = _generateParticle();
        }
      } else {
        // VOID: Ambient floating/horizontal drift
        p.y -= p.speed * 0.3;
        p.x += math.sin(p.sinOffset) * 0.003;
        if (p.y < -0.05 || p.x < -0.05 || p.x > 1.05) {
          _particles[i] = _generateParticle(isInitial: false);
          // Set random start for void
          _particles[i].x = _random.nextDouble();
          _particles[i].y = 1.05;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _updateParticles();
        return CustomPaint(
          painter: _ParticlePainter(
            particles: _particles,
            realm: widget.realm,
            color: widget.color,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final String realm;
  final Color color;

  _ParticlePainter({
    required this.particles,
    required this.realm,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = color.withOpacity(p.opacity)
        ..style = PaintingStyle.fill;

      final offset = Offset(p.x * size.width, p.y * size.height);

      if (realm == 'HELL') {
        // Glowy embers
        paint.color = Color.lerp(Colors.redAccent, Colors.orangeAccent, p.opacity)!
            .withOpacity(p.opacity);
        canvas.drawCircle(offset, p.size, paint);
      } else if (realm == 'HEAVEN') {
        // Shimmering stardust (diamonds/circles)
        paint.color = Color.lerp(Colors.amberAccent, Colors.white, p.opacity)!
            .withOpacity(p.opacity);
        canvas.drawCircle(offset, p.size, paint);
      } else {
        // Soft mist motes
        paint.color = Color.lerp(color, Colors.white24, p.opacity)!
            .withOpacity(p.opacity * 0.5);
        canvas.drawCircle(offset, p.size * 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
