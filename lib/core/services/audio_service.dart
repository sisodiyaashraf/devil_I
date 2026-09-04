import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class AudioService {
  final AudioPlayer _ambientPlayer = AudioPlayer();
  final AudioPlayer _stingPlayer = AudioPlayer();

  bool _isMuted = false;
  bool _isAmbientPlaying = false;
  int _currentIntensityZone = -1;

  bool get isMuted => _isMuted;

  static const Map<String, String> _cues = {
    'static': 'audio/creak.mp3',
    'lowHum': 'audio/ambient.mp3',
    'systemBeep': 'audio/heartbeat.mp3',
    'distortedVoice': 'audio/creak.mp3',
    'silence': 'audio/silence.mp3',
  };

  Future<void> loadMuteState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isMuted = prefs.getBool(AppConstants.muteKey) ?? false;
      await _applyVolume();
    } catch (_) {}
  }

  Future<void> toggleMute() async {
    try {
      _isMuted = !_isMuted;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.muteKey, _isMuted);
      await _applyVolume();
    } catch (_) {}
  }

  Future<void> _applyVolume() async {
    try {
      final double ambientVol = _isMuted
          ? 0.0
          : (0.2 + (_currentIntensityZone.clamp(0, 2) * 0.25)).clamp(0.2, 0.8);
      await _ambientPlayer.setVolume(ambientVol);
      await _stingPlayer.setVolume(_isMuted ? 0.0 : 0.8);
    } catch (_) {}
  }

  Future<void> updateAmbientIntensity(int corruptionLevel) async {
    int zone;
    if (corruptionLevel < 30) {
      zone = 0;
    } else if (corruptionLevel < 70) {
      zone = 1;
    } else {
      zone = 2;
    }

    if (zone == _currentIntensityZone) return;
    _currentIntensityZone = zone;

    try {
      final double volume = _isMuted
          ? 0.0
          : (0.2 + (zone * 0.25)).clamp(0.2, 0.8);
      await _ambientPlayer.setVolume(volume);
      if (!_isAmbientPlaying) {
        await playAmbient();
      }
    } catch (_) {}
  }

  Future<void> playAmbient() async {
    if (_isAmbientPlaying) return;
    try {
      await _ambientPlayer.setReleaseMode(ReleaseMode.loop);
      await _ambientPlayer.setVolume(_isMuted ? 0.0 : 0.3);
      await _ambientPlayer.play(AssetSource('audio/ambient.mp3'));
      _isAmbientPlaying = true;
    } catch (_) {}
  }

  Future<void> stopAmbient() async {
    try {
      await _ambientPlayer.stop();
      _isAmbientPlaying = false;
    } catch (_) {}
  }

  Future<void> playSting(String? cueKey) async {
    if (cueKey == null || _isMuted) return;
    final path = _cues[cueKey] ?? 'audio/creak.mp3';

    try {
      await _stingPlayer.setReleaseMode(ReleaseMode.release);
      await _stingPlayer.setVolume(_isMuted ? 0.0 : 0.8);
      await _stingPlayer.play(AssetSource(path));
    } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await _ambientPlayer.dispose();
      await _stingPlayer.dispose();
    } catch (_) {}
  }
}
