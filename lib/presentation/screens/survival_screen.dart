import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/biometric_hud.dart';
import '../widgets/jumpscare_overlay.dart';
import '../widgets/qte/camera_surveillance_widget.dart';
import '../widgets/qte/frequency_tuner_widget.dart';
import '../widgets/qte/pulse_control_widget.dart';
import '../widgets/qte/terminal_override_widget.dart';

class SurvivalScreen extends StatefulWidget {
  const SurvivalScreen({super.key});

  @override
  State<SurvivalScreen> createState() => _SurvivalScreenState();
}

class _SurvivalScreenState extends State<SurvivalScreen> {
  int _score = 0;
  int _wave = 1;
  int _corruption = 1;
  String _currentQte = 'pulse_hold';
  bool _triggerJumpscare = false;
  bool _gameOver = false;

  final List<String> _qtePool = [
    'pulse_hold',
    'frequency_tuner',
    'code_override',
    'camera_check',
  ];

  void _nextWave() {
    setState(() {
      _score += 250 * _wave;
      _wave++;
      _corruption = math.min(10, _corruption + 1);
      final nextIdx = math.Random().nextInt(_qtePool.length);
      _currentQte = _qtePool[nextIdx];
    });
  }

  void _onFail() {
    setState(() {
      _triggerJumpscare = true;
      _gameOver = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: JumpscareOverlay(
        trigger: _triggerJumpscare,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios, color: Colors.redAccent),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'SURVIVE THE BREACH // WAVE $_wave',
                      style: GoogleFonts.shareTechMono(
                        color: Colors.redAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'SCORE: $_score',
                      style: GoogleFonts.shareTechMono(
                        color: Colors.amberAccent,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                BiometricHud(
                  corruptionLevel: _corruption,
                  threatLevel: _wave > 5 ? 'ANOMALY' : 'CRITICAL',
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: _gameOver
                          ? _buildGameOverView()
                          : _buildActiveQteWidget(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveQteWidget() {
    switch (_currentQte) {
      case 'frequency_tuner':
        return FrequencyTunerWidget(
          key: ValueKey('freq_wave_$_wave'),
          onSuccess: _nextWave,
          onFail: _onFail,
        );
      case 'code_override':
        return TerminalOverrideWidget(
          key: ValueKey('code_wave_$_wave'),
          onSuccess: _nextWave,
          onFail: _onFail,
        );
      case 'camera_check':
        return CameraSurveillanceWidget(
          key: ValueKey('cam_wave_$_wave'),
          onSuccess: _nextWave,
          onFail: _onFail,
        );
      case 'pulse_hold':
      default:
        return PulseControlWidget(
          key: ValueKey('pulse_wave_$_wave'),
          onSuccess: _nextWave,
          onFail: _onFail,
        );
    }
  }

  Widget _buildGameOverView() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0202).withValues(alpha: 0.9),

        border: Border.all(color: Colors.redAccent, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'CONTAINMENT BREACHED',
            style: GoogleFonts.shareTechMono(
              color: Colors.redAccent,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'YOU SURVIVED $_wave WAVES OF DEVIL_I ATTACKS',
            style: GoogleFonts.shareTechMono(color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(
            'TOTAL SCORE: $_score',
            style: GoogleFonts.shareTechMono(
              color: Colors.amberAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            onPressed: () {
              setState(() {
                _score = 0;
                _wave = 1;
                _corruption = 1;
                _currentQte = 'pulse_hold';
                _triggerJumpscare = false;
                _gameOver = false;
              });
            },
            child: Text(
              'RESTART SIMULATION',
              style: GoogleFonts.shareTechMono(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
