import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final FlutterTts _tts;
  bool _isInitialized = false;

  VoiceService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      await _tts.setSpeechRate(0.38);
      await _tts.setPitch(0.65);
      await _tts.setVolume(1.0);
      _isInitialized = true;
    } catch (_) {}
  }

  Future<void> speak(String text, {bool enabled = true}) async {
    if (!enabled || text.trim().isEmpty) return;
    try {
      if (!_isInitialized) {
        await init();
      }
      await _tts.stop();
      final cleanText = text
          .replaceAll(RegExp(r'[^\x00-\x7F]'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (cleanText.isNotEmpty) {
        await _tts.speak(cleanText);
      }
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
