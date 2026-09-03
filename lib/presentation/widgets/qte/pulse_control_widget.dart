import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PulseControlWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onFail;

  const PulseControlWidget({
    super.key,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  State<PulseControlWidget> createState() => _PulseControlWidgetState();
}

class _PulseControlWidgetState extends State<PulseControlWidget> {
  bool _isHolding = false;
  double _holdTime = 0.0;
  final double _targetHoldTime = 4.0;
  double _pulseWave = 0.5;
  Timer? _timer;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!mounted || _completed) return;

      setState(() {
        _pulseWave = (math.sin(DateTime.now().millisecondsSinceEpoch / 200) + 1) / 2;


        if (_isHolding) {
          _holdTime += 0.05;
          if (_holdTime >= _targetHoldTime) {
            _completed = true;
            widget.onSuccess();
          }
        } else if (_holdTime > 0.3) {
          // Released too early!
          _completed = true;
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

  double get sin => math.sin;

  @override
  Widget build(BuildContext context) {
    final progress = (_holdTime / _targetHoldTime).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.9),
        border: Border.all(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.red.withValues(alpha: 0.3), blurRadius: 15),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 28),
              const SizedBox(width: 8),
              Text(
                'ENTITY STANDING OVERHEAD',
                style: GoogleFonts.shareTechMono(
                  color: Colors.redAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'PRESS & HOLD DAMPENER TO STABILIZE HEARTBEAT & HOLD BREATH',
            textAlign: TextAlign.center,
            style: GoogleFonts.shareTechMono(
              color: Colors.grey.shade300,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade900,
            color: progress > 0.8 ? Colors.greenAccent : Colors.redAccent,
            minHeight: 10,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTapDown: (_) => setState(() => _isHolding = true),
            onTapUp: (_) => setState(() => _isHolding = false),
            onTapCancel: () => setState(() => _isHolding = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isHolding ? Colors.redAccent.shade700 : Colors.red.shade900.withValues(alpha: 0.4),
                border: Border.all(
                  color: _isHolding ? Colors.redAccent : Colors.red.shade400,
                  width: 3 + (_pulseWave * 4),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withValues(alpha: _isHolding ? 0.8 : 0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isHolding ? Icons.fingerprint : Icons.touch_app,
                      color: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isHolding ? 'HOLDING...' : 'HOLD HERE',
                      style: GoogleFonts.shareTechMono(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
