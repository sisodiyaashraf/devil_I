import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TerminalOverrideWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onFail;

  const TerminalOverrideWidget({
    super.key,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  State<TerminalOverrideWidget> createState() => _TerminalOverrideWidgetState();
}

class _TerminalOverrideWidgetState extends State<TerminalOverrideWidget> {
  final List<int> _passcode = [9, 4, 1, 7];
  final List<int> _entered = [];
  double _timeLeft = 7.0;
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      if (!mounted || _finished) return;
      setState(() {
        _timeLeft -= 0.1;
        if (_timeLeft <= 0) {
          _finished = true;
          widget.onFail();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _pressDigit(int digit) {
    if (_finished || _entered.length >= 4) return;

    setState(() {
      _entered.add(digit);
      if (_entered.length == 4) {
        bool match = true;
        for (int i = 0; i < 4; i++) {
          if (_entered[i] != _passcode[i]) match = false;
        }

        _finished = true;
        if (match) {
          widget.onSuccess();
        } else {
          widget.onFail();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.95),
        border: Border.all(color: Colors.orangeAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SECURITY BYPASS KEYPAD',
                style: GoogleFonts.shareTechMono(
                  color: Colors.orangeAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_timeLeft.toStringAsFixed(1)}s',
                style: GoogleFonts.shareTechMono(
                  color: _timeLeft < 3 ? Colors.red : Colors.orangeAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'REQUIRED KEYCODE: 9 4 1 7',
            style: GoogleFonts.shareTechMono(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              border: Border.all(color: Colors.orangeAccent),
            ),
            child: Text(
              _entered.isEmpty
                  ? '_ _ _ _'
                  : _entered.map((e) => '$e').join(' '),
              style: GoogleFonts.shareTechMono(
                color: Colors.orangeAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 2.2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 9,
            itemBuilder: (ctx, idx) {
              final digit = idx + 1;
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade900,
                  foregroundColor: Colors.orangeAccent,
                  side: const BorderSide(color: Colors.orangeAccent, width: 0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                onPressed: () => _pressDigit(digit),
                child: Text(
                  '$digit',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
