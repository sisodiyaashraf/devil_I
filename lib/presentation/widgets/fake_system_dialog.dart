import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/theme.dart';

class FakeSystemDialog extends StatefulWidget {
  final VoidCallback onDismiss;

  const FakeSystemDialog({
    super.key,
    required this.onDismiss,
  });

  @override
  State<FakeSystemDialog> createState() => _FakeSystemDialogState();
}

class _FakeSystemDialogState extends State<FakeSystemDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  // Glitch flicker on title
  bool _flickerTitle = false;
  Timer? _flickerTimer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..forward();

    _scaleAnim = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    // Periodic title flicker
    _flickerTimer = Timer.periodic(const Duration(milliseconds: 1800), (_) {
      if (!mounted) return;
      setState(() => _flickerTitle = true);
      Future.delayed(const Duration(milliseconds: 80), () {
        if (mounted) setState(() => _flickerTitle = false);
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _flickerTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: Container(
          color: Colors.black.withValues(alpha: 0.72),
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: ScaleTransition(
              scale: _scaleAnim,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 310.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    border: Border.all(
                      color: AppColors.corruptRed.withValues(alpha: 0.55),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(3.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.corruptRed.withValues(alpha: 0.2),
                        blurRadius: 24.0,
                        spreadRadius: 2.0,
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.6),
                        blurRadius: 40.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Title bar ───────────────────────────────────
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: AppColors.corruptRed.withValues(alpha: 0.12),
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.corruptRed.withValues(alpha: 0.3),
                              width: 1.0,
                            ),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(3.0),
                            topRight: Radius.circular(3.0),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline_rounded,
                              size: 14.0,
                              color: AppColors.corruptRed
                                  .withValues(alpha: _flickerTitle ? 0.3 : 0.9),
                            ),
                            const SizedBox(width: 8.0),
                            AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 60),
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                                color: _flickerTitle
                                    ? AppColors.corruptRed.withValues(alpha: 0.2)
                                    : Colors.white,
                                shadows: neonGlow(AppColors.corruptRed, blur: 4),
                              ),
                              child: const Text('System Error'),
                            ),
                          ],
                        ),
                      ),

                      // ── Body ────────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 16.0, 14.0, 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ECHO has stopped responding.',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 13.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 6.0),
                            Text(
                              'Process integrity compromised. Would you like to\nclose this application?',
                              style: TextStyle(
                                fontFamily: 'monospace',
                                fontSize: 11.5,
                                color: Colors.white.withValues(alpha: 0.55),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ── Divider ─────────────────────────────────────
                      Container(
                        height: 1.0,
                        color: AppColors.staticGray.withValues(alpha: 0.25),
                        margin: const EdgeInsets.symmetric(horizontal: 14.0),
                      ),

                      // ── Buttons ─────────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14.0, 10.0, 14.0, 14.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _DialogButton(
                              label: 'WAIT',
                              color: AppColors.mutedText,
                              filled: false,
                              onTap: widget.onDismiss,
                            ),
                            const SizedBox(width: 8.0),
                            _DialogButton(
                              label: 'CLOSE',
                              color: AppColors.corruptRed,
                              filled: true,
                              onTap: widget.onDismiss,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DialogButton extends StatefulWidget {
  final String label;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.color,
    required this.filled,
    required this.onTap,
  });

  @override
  State<_DialogButton> createState() => _DialogButtonState();
}

class _DialogButtonState extends State<_DialogButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 7.0),
        decoration: BoxDecoration(
          color: widget.filled
              ? widget.color.withValues(alpha: _pressed ? 0.4 : 0.2)
              : Colors.transparent,
          border: Border.all(
            color: widget.color.withValues(alpha: _pressed ? 1.0 : 0.5),
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Text(
          widget.label,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11.0,
            fontWeight: FontWeight.bold,
            color: widget.color.withValues(alpha: _pressed ? 1.0 : 0.8),
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
