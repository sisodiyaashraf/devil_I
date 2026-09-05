import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class CorruptedText extends StatefulWidget {
  final String text;
  final int corruptionLevel;
  final TextStyle? style;
  final TextAlign? textAlign;

  const CorruptedText({
    super.key,
    required this.text,
    required this.corruptionLevel,
    this.style,
    this.textAlign,
  });

  @override
  State<CorruptedText> createState() => _CorruptedTextState();
}

class _CorruptedTextState extends State<CorruptedText> {
  static const List<String> _glitchChars = [
    '░', '▒', '▓', '█', '§', 'µ', 'Ø', '▲', '?', '#', '&', r'$', 'X'
  ];

  late String _displayedText;
  Timer? _glitchTimer;
  Timer? _revertTimer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _displayedText = widget.text;
    _updateGlitchTimer();
  }

  @override
  void didUpdateWidget(CorruptedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text ||
        oldWidget.corruptionLevel != widget.corruptionLevel) {
      _displayedText = widget.text;
      _updateGlitchTimer();
    }
  }

  void _updateGlitchTimer() {
    _glitchTimer?.cancel();
    _revertTimer?.cancel();

    if (widget.corruptionLevel < 40 || widget.text.isEmpty) {
      setState(() => _displayedText = widget.text);
      return;
    }

    final intervalMs = widget.corruptionLevel >= 70 ? 180 : 350;
    _glitchTimer = Timer.periodic(Duration(milliseconds: intervalMs), (_) {
      _triggerFlicker();
    });
  }

  void _triggerFlicker() {
    if (!mounted || widget.corruptionLevel < 40 || widget.text.isEmpty) return;

    final chars = widget.text.split('');
    final nonSpaceIndices = <int>[];
    for (var i = 0; i < chars.length; i++) {
      if (chars[i].trim().isNotEmpty) {
        nonSpaceIndices.add(i);
      }
    }

    if (nonSpaceIndices.isEmpty) return;

    final countToCorrupt = widget.corruptionLevel >= 70
        ? min(3, max(1, (nonSpaceIndices.length * 0.15).round()))
        : 1;

    nonSpaceIndices.shuffle(_random);
    final targetIndices = nonSpaceIndices.take(countToCorrupt).toSet();

    final glitched = List<String>.from(chars);
    for (final idx in targetIndices) {
      glitched[idx] = _glitchChars[_random.nextInt(_glitchChars.length)];
    }

    setState(() {
      _displayedText = glitched.join('');
    });

    _revertTimer?.cancel();
    _revertTimer = Timer(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _displayedText = widget.text;
        });
      }
    });
  }

  @override
  void dispose() {
    _glitchTimer?.cancel();
    _revertTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      child: Text(
        _displayedText,
        key: ValueKey<String>(widget.text),
        textAlign: widget.textAlign,
        style: widget.style,
      ),
    );
  }
}
