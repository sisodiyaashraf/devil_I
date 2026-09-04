import 'package:flutter/material.dart';
import '../../core/theme.dart';

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
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 320.0),
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'System Error',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  const Text(
                    'ECHO has stopped responding. Would you like to close it?',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 13.0,
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
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: AppColors.staticGray,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      TextButton(
                        onPressed: onDismiss,
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            color: AppColors.corruptRed,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
