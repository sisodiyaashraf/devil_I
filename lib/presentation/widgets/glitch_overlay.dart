import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/glitch_utils.dart';
import '../../core/services/haptics_service.dart';
import '../providers/story_provider.dart';
import 'fake_system_dialog.dart';

class GlitchOverlay extends StatefulWidget {
  final Widget child;
  final int corruptionLevel;
  final bool forceTrigger;
  final HapticsService? hapticsService;

  const GlitchOverlay({
    super.key,
    required this.child,
    required this.corruptionLevel,
    required this.forceTrigger,
    this.hapticsService,
  });

  @override
  State<GlitchOverlay> createState() => _GlitchOverlayState();
}

class _GlitchOverlayState extends State<GlitchOverlay> {
  GlitchEffect? _activeEffect;
  Timer? _effectTimer;
  double _rgbOffset = 0.0;
  bool _hasTriggeredForThisNode = false;

  @override
  void initState() {
    super.initState();
    if (widget.forceTrigger) {
      _triggerGlitch();
    }
  }

  @override
  void didUpdateWidget(covariant GlitchOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.corruptionLevel != oldWidget.corruptionLevel &&
        !widget.forceTrigger &&
        !_hasTriggeredForThisNode) {
      if (GlitchUtils.shouldTrigger(widget.corruptionLevel)) {
        _triggerGlitch();
      }
    }
  }

  @override
  void dispose() {
    _effectTimer?.cancel();
    super.dispose();
  }

  void _triggerGlitch() {
    _hasTriggeredForThisNode = true;
    _effectTimer?.cancel();

    final provider = context.read<StoryProvider>();
    final haptics = widget.hapticsService ?? provider.hapticsService;
    haptics.heavyJolt(enabled: !provider.audioService.isMuted);

    final effect = GlitchUtils.pickEffect();
    setState(() {
      _activeEffect = effect;
      if (effect == GlitchEffect.rgbSplit) {
        _rgbOffset = (math.Random().nextDouble() * 16) - 8;
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
                    colorFilter: const ColorFilter.mode(
                      Color(0x7F6E1414),
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
