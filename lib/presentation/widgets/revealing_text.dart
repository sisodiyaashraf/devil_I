import 'package:flutter/material.dart';

class RevealingText extends StatefulWidget {
  final String text;
  final VoidCallback? onComplete;

  const RevealingText({
    super.key,
    required this.text,
    this.onComplete,
  });

  @override
  State<RevealingText> createState() => _RevealingTextState();
}

class _RevealingTextState extends State<RevealingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _charCount;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  @override
  void didUpdateWidget(covariant RevealingText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _controller.dispose();
      _initializeAnimation();
    }
  }

  void _initializeAnimation() {
    final int durationMs = (widget.text.length * 20).clamp(1500, 2500);

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    );

    _charCount = IntTween(begin: 0, end: widget.text.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _charCount,
      builder: (context, child) {
        final revealedText = widget.text.substring(0, _charCount.value);
        return Text(
          revealedText,
          style: Theme.of(context).textTheme.bodyLarge,
        );
      },
    );
  }
}
