import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// RELATIVE IMPORTS
import '../../../data/models/habit.dart';
import '../../providers/devil_provider.dart';
import '../../providers/focus_provider.dart';
import '../home/widgets/eye_widget.dart';
import '../home/widgets/glass_card.dart';
import 'widgets/ritual_result_card.dart';
import 'widgets/timer_display.dart';
import '../../widgets/ambient_particles.dart';

class FocusScreen extends StatefulWidget {
  final Habit? habit;
  const FocusScreen({super.key, this.habit});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _pulseController;

  bool _isHolding = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Initializing the Focus Ritual
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.habit != null) {
        context.read<FocusProvider>().startFocus(
          widget.habit!,
          context.read<DevilProvider>(),
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focusProvider = context.watch<FocusProvider>();
    final devilProvider = context.watch<DevilProvider>();

    final progress = focusProvider.progress;
    final isFinished = focusProvider.isFinished;
    final isRunning = focusProvider.isRunning;
    final realm = devilProvider.currentRealm;

    // CHROMATIC DRIFT: Color intensifies and shifts based on the current soul realm
    Color baseAccent = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.cyanAccent);
    Color dynamicAccent = Color.lerp(
      baseAccent.withOpacity(0.3),
      baseAccent,
      progress,
    )!;

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Ambient drift particles matching the active realm
            AmbientParticles(realm: realm, color: baseAccent),

            if (isRunning) ...[
              // 1. THE PERIPHERAL VOID
              _buildPeripheralVoid(progress),

              // 2. THE GEOMETRIC ORBIT (Animated Shards)
              _buildAnimatedOrbit(progress, dynamicAccent),

              // 3. THE VIGILANT EYE & TIMER
              _buildEyeCore(progress, dynamicAccent),

              // 4. THE INTERFACE (Only active during the countdown)
              SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildModernHeader(dynamicAccent, progress, focusProvider),
                    _buildModernFooter(dynamicAccent, focusProvider, progress),
                  ],
                ),
              ),
            ] else if (isFinished) ...[
              // 5. THE RESULT OVERLAY (Triggered by FocusProvider.isFinished)
              _buildSuccessOverlay(focusProvider),
            ] else ...[
              // THE CHAMBER OF WILLS: Idle list when no timer is active
              _buildChamberOfWills(context, devilProvider, focusProvider, baseAccent),
            ],
          ],
        ),
      ),
    );
  }

  // --- UI BUILDING BLOCKS ---

  Widget _buildPeripheralVoid(double progress) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            radius: 1.5,
            center: Alignment.center,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.9 * (1 - progress)),
              Colors.black,
            ],
            stops: const [0.3, 0.7, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedOrbit(double progress, Color accent) {
    return AnimatedBuilder(
      animation: _rotationController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationController.value * 2 * math.pi,
          child: CustomPaint(
            size: const Size(360, 360),
            painter: OrbitPainter(progress: progress, color: accent),
          ),
        );
      },
    );
  }

  Widget _buildEyeCore(double progress, Color accent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DevilEye(),
        const SizedBox(height: 20),
        Text(
          progress >= 1.0 ? "RITUAL SEALED" : "TRANSCENDING",
          style: GoogleFonts.cinzel(
            color: accent.withOpacity(0.8),
            letterSpacing: 12,
            fontSize: 10,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        TimerDisplay(
          pulseController: _pulseController,
          glowColor: accent,
        ),
      ],
    );
  }

  Widget _buildModernHeader(Color accent, double progress, FocusProvider focus) {
    final habit = focus.activeHabit;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
      child: GlassCard(
        accentColor: accent,
        opacity: 0.06,
        blur: 12,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "INTENT: ${habit?.title.toUpperCase() ?? 'VOID'}",
              style: GoogleFonts.spaceMono(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.05),
                color: accent,
                minHeight: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernFooter(
    Color accent,
    FocusProvider focus,
    double progress,
  ) {
    final habit = focus.activeHabit;
    return Padding(
      padding: const EdgeInsets.only(bottom: 50, left: 30, right: 30),
      child: Column(
        children: [
          GlassCard(
            accentColor: Colors.white10,
            opacity: 0.02,
            blur: 8,
            padding: const EdgeInsets.all(16),
            child: Text(
              "“${habit?.punishmentThreat.toUpperCase() ?? 'THE VOID WAITS.'}”",
              textAlign: TextAlign.center,
              style: GoogleFonts.spaceMono(
                color: Colors.white38,
                fontSize: 10,
                fontStyle: FontStyle.italic,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildHoldButton(focus, accent),
        ],
      ),
    );
  }

  Widget _buildHoldButton(FocusProvider focus, Color accent) {
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() => _isHolding = true);
        HapticFeedback.mediumImpact();
      },
      onLongPressEnd: (_) => setState(() => _isHolding = false),
      onLongPress: () {
        focus.stopFocusEarly(context.read<DevilProvider>());
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 250),
        scale: _isHolding ? 0.88 : 1.0,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: CircularProgressIndicator(
                value: _isHolding ? null : 0.0,
                strokeWidth: 2,
                color: Colors.redAccent.withOpacity(0.5),
              ),
            ),
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
                border: Border.all(
                  color: _isHolding ? Colors.redAccent : Colors.white10,
                  width: 1.5,
                ),
              ),
              child: Icon(
                _isHolding ? Icons.warning_amber_rounded : Icons.close_rounded,
                color: _isHolding ? Colors.redAccent : Colors.white24,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessOverlay(FocusProvider focus) {
    final habit = focus.activeHabit;
    return Positioned.fill(
      child: RitualResultCard(
        habitTitle: habit?.title ?? "THE VOW",
        soulShift: 12,
        onDismiss: () {
          focus.dismissResult();
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  Widget _buildChamberOfWills(
      BuildContext context,
      DevilProvider devil,
      FocusProvider focus,
      Color accent) {
    final uncompleted = devil.habits.where((h) => !h.isCompletedToday).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "RITUAL CHAMBER",
              style: GoogleFonts.cinzel(
                color: accent,
                fontSize: 26,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                shadows: [
                  Shadow(color: accent.withOpacity(0.4), blurRadius: 10)
                ],
              ),
            ),
            Text(
              "COMMENCE A SEALED VOW",
              style: GoogleFonts.spaceMono(
                color: Colors.white30,
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: uncompleted.isEmpty
                  ? _buildEmptyChamber(accent)
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: uncompleted.length,
                      itemBuilder: (context, index) {
                        final habit = uncompleted[index];
                        return _buildWillCard(
                            context, habit, devil, focus, accent);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWillCard(
      BuildContext context,
      dynamic habit,
      DevilProvider devil,
      FocusProvider focus,
      Color accent) {
    final minutes = habit.targetDurationSeconds ~/ 60;
    final displayAccent = habit.isBloodOath ? Colors.redAccent : accent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        accentColor: displayAccent,
        opacity: 0.08,
        blur: 16,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            HapticFeedback.heavyImpact();
            focus.startFocus(habit, devil);
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: displayAccent.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    habit.isBloodOath ? Icons.water_drop : Icons.hourglass_empty,
                    color: displayAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        habit.title.toUpperCase(),
                        style: GoogleFonts.cinzel(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "DURATION: $minutes MIN | THREAT: ${habit.punishmentThreat}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.spaceMono(
                          color: Colors.white30,
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: displayAccent.withOpacity(0.3),
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyChamber(Color accent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.all_inclusive, color: accent.withOpacity(0.1), size: 80),
          const SizedBox(height: 20),
          Text(
            "ALL PACTS COMPLETED TODAY.\nTHE VOID RESTS.",
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              color: accent.withOpacity(0.4),
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}


// --- RITUAL GEOMETRY PAINTER ---
class OrbitPainter extends CustomPainter {
  final double progress;
  final Color color;
  OrbitPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color.withOpacity(0.2 + (progress * 0.7))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.2;

    for (int i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      // Contraction: The seal physically tightens as the task nears completion
      final currentRadius = radius * (1.1 - (progress * 0.15));
      final x = center.dx + currentRadius * math.cos(angle);
      final y = center.dy + currentRadius * math.sin(angle);

      canvas.drawCircle(Offset(x, y), 1.2, paint..style = PaintingStyle.fill);

      final sweepAngle = (progress * (math.pi / 4)) + 0.1;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: currentRadius),
        angle,
        sweepAngle,
        false,
        paint..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  bool shouldRepaint(OrbitPainter oldDelegate) => true;
}
