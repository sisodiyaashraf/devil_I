import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../providers/echo_provider.dart';
import 'main_screen.dart';

class ScanIntroScreen extends StatefulWidget {
  const ScanIntroScreen({super.key});

  @override
  State<ScanIntroScreen> createState() => _ScanIntroScreenState();
}

class _ScanIntroScreenState extends State<ScanIntroScreen>
    with TickerProviderStateMixin {
  final List<String> _scanLogs = [
    'INITIALIZING ECHO CORE v1.0.4...',
    'CALIBRATING BIOMETRIC SENSORS...',
    'ESTABLISHING PRESENCE LINK...',
    'SCANNING USER TELEMETRY...',
    'CONNECTION ALREADY ESTABLISHED.',
  ];

  final List<String> _displayedLines = [];
  String _currentLineText = '';
  int _currentLineIndex = 0;
  int _currentCharIndex = 0;
  Timer? _typewriterTimer;
  bool _hasNavigated = false;

  // Scan-line animation
  late final AnimationController _scanLineCtrl;
  late final Animation<double> _scanLineAnim;

  // Logo pulse animation
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  // Scanline noise controller
  final _rng = math.Random();
  Timer? _noiseTimer;
  List<_NoiseLine> _noiseLines = [];

  @override
  void initState() {
    super.initState();

    // Scan line sweeps top → bottom, loops
    _scanLineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _scanLineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanLineCtrl, curve: Curves.linear),
    );

    // Pulse
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );

    // Scanline noise flicker
    _noiseTimer = Timer.periodic(const Duration(milliseconds: 120), (_) {
      if (!mounted) return;
      setState(() {
        _noiseLines = List.generate(
          _rng.nextInt(4) + 1,
          (_) => _NoiseLine(
            y: _rng.nextDouble(),
            opacity: 0.04 + _rng.nextDouble() * 0.08,
            height: 1.0 + _rng.nextDouble() * 2.0,
          ),
        );
      });
    });

    _startNextLine();
  }

  void _startNextLine() {
    if (!mounted || _hasNavigated) return;
    if (_currentLineIndex >= _scanLogs.length) {
      _navigateToMain();
      return;
    }

    _currentCharIndex = 0;
    _currentLineText = '';
    final targetText = _scanLogs[_currentLineIndex];

    _typewriterTimer?.cancel();
    _typewriterTimer = Timer.periodic(const Duration(milliseconds: 35), (timer) {
      if (!mounted || _hasNavigated) {
        timer.cancel();
        return;
      }
      if (_currentCharIndex < targetText.length) {
        setState(() {
          _currentLineText = targetText.substring(0, _currentCharIndex + 1);
          _currentCharIndex++;
        });
      } else {
        timer.cancel();
        _displayedLines.add(targetText);
        _currentLineText = '';
        _currentLineIndex++;
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted && !_hasNavigated) _startNextLine();
        });
      }
    });
  }

  void _navigateToMain() {
    if (_hasNavigated) return;
    _hasNavigated = true;
    _typewriterTimer?.cancel();

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade = CurvedAnimation(parent: animation, curve: Curves.easeIn);
          final slide = Tween<Offset>(begin: const Offset(0.0, 0.04), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    _noiseTimer?.cancel();
    _scanLineCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final echo = context.watch<EchoProvider>();
    final isHighCorruption = echo.corruptionLevel >= 60;
    final accentColor = isHighCorruption ? AppColors.corruptRed : AppColors.terminalGreen;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _navigateToMain,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // ── Noise scanline overlay ──────────────────────────────────
            ..._noiseLines.map((n) => Positioned(
                  top: size.height * n.y,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: n.height,
                    color: accentColor.withValues(alpha: n.opacity),
                  ),
                )),

            // ── Moving scan-line ────────────────────────────────────────
            AnimatedBuilder(
              animation: _scanLineAnim,
              builder: (_, __) => Positioned(
                top: size.height * _scanLineAnim.value,
                left: 0,
                right: 0,
                child: Container(
                  height: 2.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        accentColor.withValues(alpha: 0.5),
                        accentColor.withValues(alpha: 0.9),
                        accentColor.withValues(alpha: 0.5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Main content ────────────────────────────────────────────
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Logo + label
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AnimatedBuilder(
                              animation: _pulseAnim,
                              builder: (_, __) => Text(
                                'ECHO',
                                style: TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                  color: accentColor.withValues(alpha: _pulseAnim.value),
                                  letterSpacing: 8.0,
                                  shadows: neonGlow(accentColor, blur: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            Text(
                              'SYSTEM DIAGNOSTIC',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 10.0,
                                fontWeight: FontWeight.bold,
                                color: accentColor.withValues(alpha: 0.55),
                                letterSpacing: 2.5,
                              ),
                            ),
                          ],
                        ),
                        // Skip hint
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.staticGray.withValues(alpha: 0.4),
                            ),
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: const Text(
                            'TAP TO SKIP',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.0,
                              color: AppColors.mutedText,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4.0),
                    // Accent divider
                    Container(
                      height: 1.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            accentColor.withValues(alpha: 0.8),
                            accentColor.withValues(alpha: 0.1),
                            Colors.transparent,
                          ],
                        ),
                        boxShadow: neonGlow(accentColor, blur: 8),
                      ),
                    ),

                    const SizedBox(height: 28.0),

                    // Terminal log lines
                    Expanded(
                      child: ListView(
                        children: [
                          ..._displayedLines.map((line) => Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '✓ ',
                                      style: TextStyle(
                                        fontFamily: 'monospace',
                                        fontSize: 12.0,
                                        color: accentColor.withValues(alpha: 0.6),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        line,
                                        style: TextStyle(
                                          fontFamily: 'monospace',
                                          fontSize: 13.0,
                                          color: accentColor.withValues(alpha: 0.75),
                                          height: 1.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          if (_currentLineText.isNotEmpty)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '▶ ',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12.0,
                                    color: accentColor,
                                    shadows: neonGlow(accentColor, blur: 6),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    '${_currentLineText}_',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 13.0,
                                      color: accentColor,
                                      fontWeight: FontWeight.bold,
                                      shadows: neonGlow(accentColor, blur: 8),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),

                    // Bottom progress hint
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_displayedLines.length} / ${_scanLogs.length} CHECKS',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.0,
                              color: AppColors.mutedText.withValues(alpha: 0.7),
                              letterSpacing: 1.5,
                            ),
                          ),
                          Text(
                            'v1.0.4 // SECURE CHANNEL',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 9.0,
                              color: AppColors.mutedText.withValues(alpha: 0.5),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
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

class _NoiseLine {
  final double y;
  final double opacity;
  final double height;
  _NoiseLine({required this.y, required this.opacity, required this.height});
}
