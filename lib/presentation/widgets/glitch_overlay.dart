import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/glitch_utils.dart';
import '../../core/services/haptics_service.dart';
import '../../core/theme.dart';
import '../../domain/entities/presence_signal.dart';
import 'fake_system_dialog.dart';

class GlitchOverlay extends StatefulWidget {
  final Widget child;
  final int corruptionLevel;
  final PresenceSignal? signal;
  final bool forceTrigger;
  final HapticsService? hapticsService;

  const GlitchOverlay({
    super.key,
    required this.child,
    required this.corruptionLevel,
    this.signal,
    this.forceTrigger = false,
    this.hapticsService,
  });

  @override
  State<GlitchOverlay> createState() => _GlitchOverlayState();
}

class _GlitchOverlayState extends State<GlitchOverlay> {
  GlitchEffect? _activeEffect;
  Timer? _effectTimer;
  double _rgbOffset = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.forceTrigger || GlitchUtils.shouldHardTrigger(widget.signal)) {
      _triggerGlitch(isHard: true);
    }
  }

  @override
  void didUpdateWidget(covariant GlitchOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    final signalChanged = widget.signal != oldWidget.signal;
    final corruptionChanged = widget.corruptionLevel != oldWidget.corruptionLevel;

    if (signalChanged && GlitchUtils.shouldHardTrigger(widget.signal)) {
      _triggerGlitch(isHard: true);
    } else if ((signalChanged || corruptionChanged) &&
        GlitchUtils.shouldTrigger(widget.corruptionLevel)) {
      _triggerGlitch(isHard: false);
    }
  }

  @override
  void dispose() {
    _effectTimer?.cancel();
    super.dispose();
  }

  void _triggerGlitch({bool isHard = false}) {
    _effectTimer?.cancel();
    widget.hapticsService?.heavyJolt(enabled: true);

    final effect = GlitchUtils.pickEffect(isHardTrigger: isHard);
    setState(() {
      _activeEffect = effect;
      if (effect == GlitchEffect.rgbSplit) {
        _rgbOffset = (math.Random().nextDouble() * 20) - 10;
      }
    });

    final duration = effect == GlitchEffect.fakeDialog
        ? const Duration(seconds: 2)
        : GlitchUtils.randomFlickerDuration();

    _effectTimer = Timer(duration, () {
      if (mounted) {
        setState(() {
          _activeEffect = null;
          _rgbOffset = 0.0;
        });
      }
    });
  }

  void _dismissDialog() {
    _effectTimer?.cancel();
    setState(() => _activeEffect = null);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = widget.child;

    if (_activeEffect == GlitchEffect.colorInvert) {
      content = ColorFiltered(
        colorFilter: const ColorFilter.matrix(<double>[
          -1.0,  0.0,  0.0, 0.0, 255.0,
           0.0, -1.0,  0.0, 0.0, 255.0,
           0.0,  0.0, -1.0, 0.0, 255.0,
           0.0,  0.0,  0.0, 1.0,   0.0,
        ]),
        child: widget.child,
      );
    }

    return Stack(
      children: [
        content,
        if (_activeEffect == GlitchEffect.rgbSplit)
          Positioned.fill(
            child: Stack(
              children: [
                Positioned(
                  left: _rgbOffset,
                  right: -_rgbOffset,
                  top: 0,
                  bottom: 0,
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      AppColors.corruptRed.withValues(alpha: 0.6),
                      BlendMode.srcATop,
                    ),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        if (_activeEffect == GlitchEffect.fakeDialog)
          FakeSystemDialog(onDismiss: _dismissDialog),
      ],
    );
  }
}
