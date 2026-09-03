import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FrequencyTunerWidget extends StatefulWidget {
  final VoidCallback onSuccess;
  final VoidCallback onFail;

  const FrequencyTunerWidget({
    super.key,
    required this.onSuccess,
    required this.onFail,
  });

  @override
  State<FrequencyTunerWidget> createState() => _FrequencyTunerWidgetState();
}

class _FrequencyTunerWidgetState extends State<FrequencyTunerWidget> {
  double _currentFreq = 88.0;
  final double _targetFreq = 104.6;
  double _timeLeft = 8.0;
  double _inRangeTime = 0.0;
  Timer? _timer;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!mounted || _finished) return;

      setState(() {
        _timeLeft -= 0.1;
        final diff = (_currentFreq - _targetFreq).abs();

        if (diff < 0.5) {
          _inRangeTime += 0.1;
          if (_inRangeTime >= 1.5) {
            _finished = true;
            widget.onSuccess();
          }
        } else {
          _inRangeTime = math.max(0.0, _inRangeTime - 0.05);
        }

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

  @override
  Widget build(BuildContext context) {
    final isAligned = (_currentFreq - _targetFreq).abs() < 0.5;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.92),
        border: Border.all(color: Colors.cyanAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.cyan.withValues(alpha: 0.3), blurRadius: 15),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SIGNAL TUNER // FREQUENCY',
                style: GoogleFonts.shareTechMono(
                  color: Colors.cyanAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'TIME: ${_timeLeft.toStringAsFixed(1)}s',
                style: GoogleFonts.shareTechMono(
                  color: _timeLeft < 3.0 ? Colors.redAccent : Colors.amberAccent,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'TARGET FREQUENCY: ${_targetFreq.toStringAsFixed(1)} MHz',
            style: GoogleFonts.shareTechMono(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade950,
              border: Border.all(color: isAligned ? Colors.greenAccent : Colors.redAccent),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isAligned ? Icons.graphic_eq : Icons.noise_control_off,
                  color: isAligned ? Colors.greenAccent : Colors.redAccent,
                ),
                const SizedBox(width: 10),
                Text(
                  '${_currentFreq.toStringAsFixed(1)} MHz',
                  style: GoogleFonts.shareTechMono(
                    color: isAligned ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Colors.cyanAccent,
              inactiveTrackColor: Colors.grey.shade800,
              thumbColor: isAligned ? Colors.greenAccent : Colors.cyanAccent,
              overlayColor: Colors.cyan.withValues(alpha: 0.3),
            ),
            child: Slider(
              value: _currentFreq,
              min: 88.0,
              max: 108.0,
              onChanged: (val) => setState(() => _currentFreq = val),
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (_inRangeTime / 1.5).clamp(0.0, 1.0),
            color: Colors.greenAccent,
            backgroundColor: Colors.grey.shade900,
          ),
        ],
      ),
    );
  }
}
