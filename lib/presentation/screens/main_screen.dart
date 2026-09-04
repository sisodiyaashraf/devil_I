import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../providers/echo_provider.dart';
import '../widgets/glitch_overlay.dart';
import '../widgets/mute_toggle_button.dart';
import '../widgets/sanity_meter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _cursorVisible = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) setState(() => _cursorVisible = !_cursorVisible);
    });
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final echo = context.watch<EchoProvider>();
    final line = echo.currentLine;
    final corruption = echo.corruptionLevel;
    final signal = echo.lastSignalForGlitch;
    final isHighCorruption = corruption >= 60;
    final textColor = isHighCorruption ? AppColors.corruptRed : AppColors.terminalGreen;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        context.read<EchoProvider>().registerTouch();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: GlitchOverlay(
          corruptionLevel: corruption,
          signal: signal,
          hapticsService: echo.hapticsService,
          child: SafeArea(
            child: Stack(
              children: [
                Positioned(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SYSTEM CORRUPTION: $corruption%',
                            style: TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 12.0,
                              color: textColor.withValues(alpha: 0.8),
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          MuteToggleButton(audioService: echo.audioService),
                        ],
                      ),
                      const SizedBox(height: 6.0),
                      SanityMeter(corruptionLevel: corruption),
                    ],
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: line != null
                          ? Text(
                              line.text,
                              key: ValueKey<String>(line.text),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 18.0,
                                height: 1.5,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          : Text(
                              _cursorVisible ? '_' : ' ',
                              key: ValueKey<bool>(_cursorVisible),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 32.0,
                                color: textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
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
