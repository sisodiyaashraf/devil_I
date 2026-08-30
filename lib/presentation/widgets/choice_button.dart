import 'package:flutter/material.dart';

class ChoiceButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final int index;

  const ChoiceButton({
    super.key,
    required this.label,
    required this.onTap,
    required this.index,
  });

  @override
  State<ChoiceButton> createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: widget.index * 150), () {
      if (mounted) {
        setState(() => _visible = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 400),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480.0),
          width: double.infinity,
          padding: const EdgeInsets.only(top: 12.0),
          child: ElevatedButton(
            onPressed: widget.onTap,
            child: Text(widget.label),
          ),
        ),
      ),
    );
  }
}
