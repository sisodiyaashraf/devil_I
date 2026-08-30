import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../core/glitch_utils.dart';

class GlitchOverlay extends StatefulWidget {
  final Widget child;
  final int corruptionLevel;
  final bool forceTrigger;

  const GlitchOverlay({
    super.key,
    required this.child,
    required this.corruptionLevel,
    required this.forceTrigger,
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
          _buildFakeSystemDialog(),
      ],
    );
  }

  Widget _buildFakeSystemDialog() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            width: 280.0,
            color: const Color(0xFF141416),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'System Error',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12.0),
                const Text(
                  'Whispers has stopped responding. Would you like to close it?',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _dismissDialog,
                      child: const Text(
                        'Wait',
                        style: TextStyle(color: Colors.white30),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: _dismissDialog,
                      child: const Text(
                        'Close',
                        style: TextStyle(color: Color(0xFF6E1414)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
