import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class SanityMeter extends StatelessWidget {
  final int corruptionLevel;

  const SanityMeter({
    super.key,
    required this.corruptionLevel,
  });

  @override
  Widget build(BuildContext context) {
    final clampedCorruption = corruptionLevel.clamp(0, 100);
    final sanityRatio = (100 - clampedCorruption) / 100.0;
    final color = Color.lerp(
          AppColors.whisperWhite.withOpacity(0.9),
          AppColors.bloodRed,
          clampedCorruption / 100.0,
        ) ??
        AppColors.whisperWhite;

    return Container(
      width: double.infinity,
      height: 3.0,
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final activeWidth = totalWidth * sanityRatio;

          if (clampedCorruption == 0 || activeWidth <= 0) {
            return Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: activeWidth,
                height: 2.0,
                color: color,
              ),
            );
          }

          final random = math.Random(clampedCorruption);
          final numSegments = (1 + (clampedCorruption / 10)).floor().clamp(1, 10);
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
          final weights = List.generate(numSegments, (_) => 0.5 + random.nextDouble());
          final weightSum = weights.reduce((a, b) => a + b);

          for (int i = 0; i < numSegments; i++) {
            final segmentWidth = (weights[i] / weightSum) * remainingLineSpan;
            if (segmentWidth > 0) {
              segments.add(
                Container(
                  width: segmentWidth,
                  height: 2.0,
                  color: color,
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
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: segments,
              ),
            ),
          );
        },
      ),
    );
  }
}
