import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SanityMeter extends StatefulWidget {
  final int corruptionLevel;

  const SanityMeter({
    super.key,
    required this.corruptionLevel,
  });

  @override
  State<SanityMeter> createState() => _SanityMeterState();
}

class _SanityMeterState extends State<SanityMeter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _pulseAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    if (widget.corruptionLevel >= 75) {
      _pulseCtrl.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(SanityMeter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.corruptionLevel >= 75 && !_pulseCtrl.isAnimating) {
      _pulseCtrl.repeat(reverse: true);
    } else if (widget.corruptionLevel < 75 && _pulseCtrl.isAnimating) {
      _pulseCtrl.stop();
      _pulseCtrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedCorruption = widget.corruptionLevel.clamp(0, 100);
    final sanityRatio = (100 - clampedCorruption) / 100.0;

    // Color: green → amber → red
    final Color color;
    if (clampedCorruption < 40) {
      color = Color.lerp(
            AppColors.terminalGreen,
            AppColors.warningAmber,
            clampedCorruption / 40.0,
          ) ??
          AppColors.terminalGreen;
    } else {
      color = Color.lerp(
            AppColors.warningAmber,
            AppColors.corruptRed,
            (clampedCorruption - 40) / 60.0,
          ) ??
          AppColors.corruptRed;
    }

    return AnimatedBuilder(
      animation: _pulseAnim,
      builder: (_, __) {
        final glowOpacity = _pulseAnim.value;
        return Container(
          width: double.infinity,
          height: 5.0,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(1.0),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              final activeWidth = totalWidth * sanityRatio;

              if (clampedCorruption == 0 || activeWidth <= 0) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: activeWidth,
                    height: 5.0,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(1.0),
                      boxShadow: neonGlow(color, blur: 6),
                    ),
                  ),
                );
              }

              final random = math.Random(clampedCorruption);
              final numSegments =
                  (1 + (clampedCorruption / 10)).floor().clamp(1, 10);
              final List<Widget> segments = [];

              final totalGaps = numSegments - 1;
              double gapSum = 0;
              final gapWidths = <double>[];
              for (int i = 0; i < totalGaps; i++) {
                final gap = 1.5 + random.nextDouble() * 3.5;
                gapWidths.add(gap);
                gapSum += gap;
              }

              final remainingLineSpan = math.max(0.0, activeWidth - gapSum);
              final weights =
                  List.generate(numSegments, (_) => 0.5 + random.nextDouble());
              final weightSum = weights.reduce((a, b) => a + b);

              for (int i = 0; i < numSegments; i++) {
                final segmentWidth = (weights[i] / weightSum) * remainingLineSpan;
                if (segmentWidth > 0) {
                  segments.add(
                    Container(
                      width: segmentWidth,
                      height: 5.0,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: glowOpacity),
                        borderRadius: BorderRadius.circular(1.0),
                        boxShadow: neonGlow(
                          color,
                          blur: clampedCorruption >= 75 ? 10 : 4,
                        ),
                      ),
                    ),
                  );
                }
                if (i < totalGaps) {
                  segments.add(SizedBox(width: gapWidths[i]));
                }
              }

              return Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: activeWidth,
                  child: ClipRect(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: segments,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
