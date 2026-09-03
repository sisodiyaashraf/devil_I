import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

class AudioService {
  final AudioPlayer _ambientPlayer = AudioPlayer();
  final AudioPlayer _stingPlayer = AudioPlayer();

  bool _isMuted = false;
  bool _isAmbientPlaying = false;

  bool get isMuted => _isMuted;

  static const Map<String, String> _cues = {
    'creak': 'audio/creak.mp3',
    'heartbeat': 'audio/heartbeat.mp3',
    'silence': 'audio/silence.mp3',
    'whisper': 'audio/creak.mp3',
    'jumpscare': 'audio/heartbeat.mp3',
    'alarm': 'audio/creak.mp3',
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
      await _ambientPlayer.setVolume(_isMuted ? 0.0 : 0.3);
      await _stingPlayer.setVolume(_isMuted ? 0.0 : 0.8);
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
    if (cueKey == null) return;
    final path = _cues[cueKey] ?? 'audio/creak.mp3';

    try {
      await _stingPlayer.setReleaseMode(ReleaseMode.release);
      await _stingPlayer.setVolume(_isMuted ? 0.0 : 0.8);
      await _stingPlayer.play(AssetSource(path));
    } catch (_) {}
  }

  Future<void> playJumpscare() async {
    await playSting('jumpscare');
  }

  Future<void> playAlarm() async {
    await playSting('alarm');
  }
}

