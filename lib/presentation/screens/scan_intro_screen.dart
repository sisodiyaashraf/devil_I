import 'dart:async';
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

class _ScanIntroScreenState extends State<ScanIntroScreen> {
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

  @override
  void initState() {
    super.initState();
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
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) => const MainScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _typewriterTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final echo = context.watch<EchoProvider>();
    final isHighCorruption = echo.corruptionLevel >= 60;
    final accentColor = isHighCorruption ? AppColors.corruptRed : AppColors.terminalGreen;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _navigateToMain,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SYSTEM DIAGNOSTIC',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: accentColor.withValues(alpha: 0.7),
                        letterSpacing: 1.5,
                      ),
                    ),
                    const Text(
                      '[TAP TO SKIP]',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 11.0,
                        color: AppColors.staticGray,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Expanded(
                  child: ListView(
                    children: [
                      ..._displayedLines.map((line) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              line,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 14.0,
                                color: accentColor.withValues(alpha: 0.85),
                              ),
                            ),
                          )),
                      if (_currentLineText.isNotEmpty)
                        Text(
                          '${_currentLineText}_',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14.0,
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
