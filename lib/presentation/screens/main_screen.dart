import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../providers/echo_provider.dart';
import '../screens/corruption_report_screen.dart';
import '../widgets/corrupted_text.dart';
import '../widgets/corruption_artifact.dart';
import '../widgets/fake_camera_overlay.dart';
import '../widgets/fake_permission_dialog.dart';
import '../widgets/glitch_overlay.dart';
import '../widgets/mute_toggle_button.dart';
import '../widgets/sanity_meter.dart';
import '../widgets/terminal_input.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  // Touch ripple
  late final AnimationController _rippleCtrl;
  late final Animation<double> _rippleAnim;
  Offset? _rippleCenter;

  // Header pulse
  late final AnimationController _headerPulseCtrl;
  late final Animation<double> _headerPulseAnim;

  // Ambient flicker for background
  late final AnimationController _bgFlickerCtrl;
  late final Animation<double> _bgFlickerAnim;

  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _cursorTimer = Timer.periodic(const Duration(milliseconds: 530), (_) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });

    // Ripple on touch
    _rippleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _rippleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleCtrl, curve: Curves.easeOut),
    );

    // Header gentle pulse
    _headerPulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);
    _headerPulseAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _headerPulseCtrl, curve: Curves.easeInOut),
    );

    // Subtle background brightness flicker
    _bgFlickerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _bgFlickerAnim = Tween<double>(begin: 0.0, end: 0.03).animate(
      CurvedAnimation(parent: _bgFlickerCtrl, curve: Curves.easeInOut),
    );

    _scheduleRandomFlicker();
  }

  void _scheduleRandomFlicker() async {
    while (mounted) {
      await Future.delayed(Duration(milliseconds: 2500 + _rng.nextInt(5000)));
      if (!mounted) break;
      await _bgFlickerCtrl.forward();
      await _bgFlickerCtrl.reverse();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cursorTimer?.cancel();
    _rippleCtrl.dispose();
    _headerPulseCtrl.dispose();
    _bgFlickerCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final echo = context.read<EchoProvider>();
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      echo.pauseSession();
      echo.endSession();
    } else if (state == AppLifecycleState.resumed) {
      echo.startSession();
    }
  }

  void _onTap(TapDownDetails details) {
    setState(() => _rippleCenter = details.localPosition);
    _rippleCtrl.forward(from: 0.0);
    context.read<EchoProvider>().registerTouch();
  }

  @override
  Widget build(BuildContext context) {
    final echo = context.watch<EchoProvider>();
    final line = echo.currentLine;
    final corruption = echo.corruptionLevel;
    final signal = echo.lastSignalForGlitch;
    debugPrint('[MainScreen] build reached. Corruption: $corruption, Line: ${line?.text}');

    final isHighCorruption = corruption >= 60;
    final isMedCorruption = corruption >= 30;
    final textColor = isHighCorruption
        ? AppColors.corruptRed
        : isMedCorruption
            ? AppColors.warningAmber
            : AppColors.terminalGreen;
    final glowColor = textColor;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTap,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.background,
        body: AnimatedBuilder(
          animation: _bgFlickerAnim,
          builder: (_, child) => ColorFiltered(
            colorFilter: ColorFilter.matrix([
              1.0 + _bgFlickerAnim.value, 0, 0, 0, 0,
              0, 1.0 + _bgFlickerAnim.value, 0, 0, 0,
              0, 0, 1.0 + _bgFlickerAnim.value, 0, 0,
              0, 0, 0, 1, 0,
            ]),
            child: child,
          ),
          child: GlitchOverlay(
            corruptionLevel: corruption,
            signal: signal,
            hapticsService: echo.hapticsService,
            child: SafeArea(
              child: Stack(
                children: [
                  // ── Touch ripple ────────────────────────────────────
                  if (_rippleCenter != null)
                    AnimatedBuilder(
                      animation: _rippleAnim,
                      builder: (_, __) => Positioned.fill(
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: _RipplePainter(
                              center: _rippleCenter!,
                              progress: _rippleAnim.value,
                              color: glowColor,
                            ),
                          ),
                        ),
                      ),
                    ),

                  // ── Header bar ─────────────────────────────────────
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _HeaderBar(
                      corruption: corruption,
                      textColor: textColor,
                      pulseAnim: _headerPulseAnim,
                      echo: echo,
                    ),
                  ),

                  // ── Central dialogue area ──────────────────────────
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 90.0, bottom: 88.0, left: 24.0, right: 24.0),
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 350),
                          switchInCurve: Curves.easeOutCubic,
                          switchOutCurve: Curves.easeIn,
                          transitionBuilder: (child, animation) {
                            final fade = CurvedAnimation(
                                parent: animation, curve: Curves.easeIn);
                            final slide = Tween<Offset>(
                              begin: const Offset(0.0, 0.06),
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                                parent: animation, curve: Curves.easeOutCubic));
                            return FadeTransition(
                              opacity: fade,
                              child: SlideTransition(
                                  position: slide, child: child),
                            );
                          },
                          child: line != null
                              ? _DialogueCard(
                                  key: ValueKey<String>(line.text),
                                  text: line.text,
                                  corruptionLevel: corruption,
                                  textColor: textColor,
                                  glowColor: glowColor,
                                )
                              : _IdleCursor(
                                  key: ValueKey<bool>(_cursorVisible),
                                  visible: _cursorVisible,
                                  color: textColor,
                                ),
                        ),
                      ),
                    ),
                  ),

                  // ── Terminal input ─────────────────────────────────
                  Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    right: 16.0,
                    child: TerminalInput(
                      corruptionLevel: corruption,
                      activePromptKey: echo.activePromptKey,
                      onSubmit: (input) {
                        context.read<EchoProvider>().submitUserInput(input);
                      },
                    ),
                  ),

                  // ── Overlay effects ────────────────────────────────
                  if (echo.shouldShowArtifact) const CorruptionArtifact(),
                  if (echo.shouldShowFakePermission)
                    FakePermissionDialog(
                      onDismiss: (responseText) {
                        echo.dismissFakePermission(responseText);
                      },
                    ),
                  if (echo.shouldShowFakeCamera)
                    FakeCameraOverlay(
                      onDismiss: () {
                        echo.dismissFakeCamera();
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Header Bar
// ──────────────────────────────────────────────────────────────────────────────
class _HeaderBar extends StatelessWidget {
  final int corruption;
  final Color textColor;
  final Animation<double> pulseAnim;
  final EchoProvider echo;

  const _HeaderBar({
    required this.corruption,
    required this.textColor,
    required this.pulseAnim,
    required this.echo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 0.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withValues(alpha: 0.0),
          ],
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRect(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Corruption label
                Expanded(
                  child: AnimatedBuilder(
                    animation: pulseAnim,
                    builder: (_, __) => Text(
                      'SYSTEM CORRUPTION: $corruption%',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11.0,
                        color: textColor.withValues(alpha: pulseAnim.value * 0.9),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        shadows: neonGlow(textColor, blur: 8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4.0),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MuteToggleButton(audioService: echo.audioService),
                    const SizedBox(width: 4.0),
                    _ExitButton(textColor: textColor),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6.0),
          SanityMeter(corruptionLevel: corruption),
        ],
      ),
    );
  }
}

class _ExitButton extends StatefulWidget {
  final Color textColor;
  const _ExitButton({required this.textColor});

  @override
  State<_ExitButton> createState() => _ExitButtonState();
}

class _ExitButtonState extends State<_ExitButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _hovered = true),
      onTapUp: (_) {
        setState(() => _hovered = false);
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, a, __) => const CorruptionReportScreen(),
            transitionsBuilder: (_, a, __, child) => FadeTransition(
              opacity: CurvedAnimation(parent: a, curve: Curves.easeIn),
              child: child,
            ),
          ),
        );
      },
      onTapCancel: () => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.textColor.withValues(alpha: _hovered ? 0.9 : 0.4),
            width: 1.0,
          ),
          color: _hovered
              ? widget.textColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Text(
          '[EXIT]',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10.0,
            color: widget.textColor.withValues(alpha: _hovered ? 1.0 : 0.65),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            shadows: _hovered ? neonGlow(widget.textColor, blur: 6) : null,
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Dialogue card — wraps CorruptedText in a subtle frosted container
// ──────────────────────────────────────────────────────────────────────────────
class _DialogueCard extends StatelessWidget {
  final String text;
  final int corruptionLevel;
  final Color textColor;
  final Color glowColor;

  const _DialogueCard({
    super.key,
    required this.text,
    required this.corruptionLevel,
    required this.textColor,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 18.0),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.6),
        border: Border(
          left: BorderSide(color: glowColor.withValues(alpha: 0.7), width: 2.0),
          bottom: BorderSide(color: glowColor.withValues(alpha: 0.15), width: 1.0),
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withValues(alpha: 0.08),
            blurRadius: 24.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: CorruptedText(
        text: text,
        corruptionLevel: corruptionLevel,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: 'monospace',
          fontSize: 17.0,
          height: 1.6,
          color: textColor,
          fontWeight: FontWeight.w500,
          shadows: neonGlow(glowColor, blur: 10),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Idle cursor block
// ──────────────────────────────────────────────────────────────────────────────
class _IdleCursor extends StatelessWidget {
  final bool visible;
  final Color color;

  const _IdleCursor({super.key, required this.visible, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          visible ? '█' : ' ',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 36.0,
            color: color,
            shadows: neonGlow(color, blur: 14),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'AWAITING INPUT...',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10.0,
            color: color.withValues(alpha: 0.4),
            letterSpacing: 3.0,
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Touch ripple painter
// ──────────────────────────────────────────────────────────────────────────────
class _RipplePainter extends CustomPainter {
  final Offset center;
  final double progress;
  final Color color;

  _RipplePainter({
    required this.center,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final maxRadius = size.longestSide * 0.5;
    final radius = maxRadius * progress;
    final opacity = (1.0 - progress) * 0.25;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, paint);

    // Inner tighter ring
    final innerRadius = maxRadius * progress * 0.4;
    final innerOpacity = (1.0 - progress) * 0.12;
    paint.color = color.withValues(alpha: innerOpacity);
    canvas.drawCircle(center, innerRadius, paint);
  }

  @override
  bool shouldRepaint(covariant _RipplePainter old) =>
      old.progress != progress || old.center != center;
}
