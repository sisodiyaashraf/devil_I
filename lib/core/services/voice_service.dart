import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final FlutterTts _tts;
  bool _isInitialized = false;

  VoiceService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      await Future.wait([
        _tts.setSpeechRate(0.38),
        _tts.setPitch(0.65),
        _tts.setVolume(1.0),
      ]).timeout(
        const Duration(seconds: 3),
        onTimeout: () => [],
      );
      _isInitialized = true;
    } catch (_) {}
  }

  Future<void> speak(String text, {bool enabled = true}) async {
    if (!enabled || text.trim().isEmpty) return;
    try {
      if (!_isInitialized) {
        await init();
      }
      await _tts.stop().timeout(const Duration(seconds: 1), onTimeout: () => 0);
      final cleanText = text
          .replaceAll(RegExp(r'[^\x00-\x7F]'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (cleanText.isNotEmpty) {
        await _tts.speak(cleanText).timeout(const Duration(seconds: 4), onTimeout: () => 0);
      }
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
