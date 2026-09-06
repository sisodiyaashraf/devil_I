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

class _TerminalInputState extends State<TerminalInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
    final accentColor = isCorrupt ? AppColors.corruptRed : AppColors.terminalGreen;
    final placeholder = widget.activePromptKey != null
        ? 'REPLY TO ECHO [${widget.activePromptKey?.toUpperCase()}]...'
        : 'ENTER COMMAND / RESPONSE...';

    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.5),
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.15),
            blurRadius: 8.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        children: [
          Text(
            '> ',
            style: TextStyle(
              fontFamily: 'monospace',
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
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
                fontSize: 14.0,
                color: accentColor,
              ),
              cursorColor: accentColor,
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12.0,
                  color: accentColor.withValues(alpha: 0.4),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ),
          IconButton(
            key: const ValueKey('terminal_submit_button'),
            icon: Icon(
              Icons.send_rounded,
              size: 18.0,
              color: accentColor.withValues(alpha: 0.8),
            ),
            onPressed: _handleSubmitted,
            splashRadius: 20.0,
          ),
        ],
      ),
    );
  }
}
