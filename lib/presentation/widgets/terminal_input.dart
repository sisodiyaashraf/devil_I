import 'package:flutter/material.dart';
import '../../core/theme.dart';

class TerminalInput extends StatefulWidget {
  final int corruptionLevel;
  final ValueChanged<String> onSubmit;
  final String? activePromptKey;

  const TerminalInput({
    super.key,
    required this.corruptionLevel,
    required this.onSubmit,
    this.activePromptKey,
  });

  @override
  State<TerminalInput> createState() => _TerminalInputState();
}

class _TerminalInputState extends State<TerminalInput>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  late AnimationController _focusCtrl;
  late Animation<double> _focusAnim;

  @override
  void initState() {
    super.initState();
    _focusCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _focusAnim = CurvedAnimation(parent: _focusCtrl, curve: Curves.easeOut);
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
    if (_focusNode.hasFocus) {
      _focusCtrl.forward();
    } else {
      _focusCtrl.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _focusCtrl.dispose();
    super.dispose();
  }

  void _handleSubmitted() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSubmit(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCorrupt = widget.corruptionLevel >= 60;
    final isMed = widget.corruptionLevel >= 30;
    final accentColor = isCorrupt
        ? AppColors.corruptRed
        : isMed
            ? AppColors.warningAmber
            : AppColors.terminalGreen;

    final placeholder = widget.activePromptKey != null
        ? 'REPLY TO ECHO [${widget.activePromptKey?.toUpperCase()}]...'
        : 'ENTER COMMAND / RESPONSE...';

    return AnimatedBuilder(
      animation: _focusAnim,
      builder: (_, child) {
        final glow = _isFocused ? neonGlow(accentColor, blur: 12) : [];
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.92),
            border: Border.all(
              color: accentColor.withValues(
                  alpha: 0.35 + 0.55 * _focusAnim.value),
              width: 1.0 + 0.5 * _focusAnim.value,
            ),
            borderRadius: BorderRadius.circular(3.0),
            boxShadow: List<BoxShadow>.from(glow),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
          child: child,
        );
      },
      child: Row(
        children: [
          // Prompt prefix with neon glow
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: _isFocused ? accentColor : accentColor.withValues(alpha: 0.5),
              shadows: _isFocused ? neonGlow(accentColor, blur: 6) : null,
            ),
            child: const Text('> '),
          ),
          Expanded(
            child: TextField(
              key: const ValueKey('terminal_input_field'),
              controller: _controller,
              focusNode: _focusNode,
              onSubmitted: (_) => _handleSubmitted(),
              textInputAction: TextInputAction.send,
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 13.0,
                color: accentColor,
                shadows: _isFocused ? neonGlow(accentColor, blur: 4) : null,
              ),
              cursorColor: accentColor,
              cursorWidth: 8.0,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11.0,
                  color: accentColor.withValues(alpha: 0.3),
                  letterSpacing: 0.5,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ),
          // Send button
          _SendButton(
            accentColor: accentColor,
            onPressed: _handleSubmitted,
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatefulWidget {
  final Color accentColor;
  final VoidCallback onPressed;

  const _SendButton({required this.accentColor, required this.onPressed});

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        padding: const EdgeInsets.all(6.0),
        decoration: BoxDecoration(
          color: _pressed
              ? widget.accentColor.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Icon(
          Icons.send_rounded,
          size: 16.0,
          color: widget.accentColor.withValues(alpha: _pressed ? 1.0 : 0.7),
          shadows: _pressed ? neonGlow(widget.accentColor, blur: 8) : null,
        ),
      ),
    );
  }
}
