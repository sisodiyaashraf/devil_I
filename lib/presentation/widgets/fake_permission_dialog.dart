import 'package:flutter/material.dart';

class FakePermissionDialog extends StatelessWidget {
  final ValueChanged<String> onDismiss;

  const FakePermissionDialog({
    super.key,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.65),
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300.0),
            child: Card(
              color: const Color(0xFF1E1E22),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 16.0),
                    child: Column(
                      children: [
                        Text(
                          '"ECHO" Would Like to Access the Camera',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Required for spatial telemetry and visual sync.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'sans-serif',
                            fontSize: 13.0,
                            color: const Color(0xFFB0B0B5),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1.0, color: Color(0xFF38383D)),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => onDismiss("That wasn't really your choice."),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              foregroundColor: const Color(0xFF0A84FF),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(16.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              "Don't Allow",
                              style: TextStyle(
                                fontFamily: 'sans-serif',
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                        ),
                        const VerticalDivider(width: 1.0, color: Color(0xFF38383D)),
                        Expanded(
                          child: TextButton(
                            onPressed: () => onDismiss('I didn\'t need you to say yes.'),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              foregroundColor: const Color(0xFF0A84FF),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(16.0),
                                ),
                              ),
                            ),
                            child: const Text(
                              'Allow',
                              style: TextStyle(
                                fontFamily: 'sans-serif',
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
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
    );
  }
}
