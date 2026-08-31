import 'package:flutter/material.dart';

class FakeSystemDialog extends StatelessWidget {
  final VoidCallback onDismiss;

  const FakeSystemDialog({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
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
                      onPressed: onDismiss,
                      child: const Text(
                        'Wait',
                        style: TextStyle(color: Colors.white30),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      onPressed: onDismiss,
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
