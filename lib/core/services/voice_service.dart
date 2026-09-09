import 'package:flutter_tts/flutter_tts.dart';

class VoiceService {
  final FlutterTts _tts;
  bool _isInitialized = false;

  VoiceService({FlutterTts? tts}) : _tts = tts ?? FlutterTts();

  bool get isInitialized => _isInitialized;

  Future<void> init() async {
    try {
      _tts.setSpeechRate(0.38).catchError((_) => null);
      _tts.setPitch(0.65).catchError((_) => null);
      _tts.setVolume(1.0).catchError((_) => null);
      _isInitialized = true;
    } catch (_) {}
  }

  Future<void> speak(String text, {bool enabled = true}) async {
    if (!enabled || text.trim().isEmpty) return;
    try {
      if (!_isInitialized) {
        await init();
      }
      _tts.stop().catchError((_) => null);
      final cleanText = text
          .replaceAll(RegExp(r'[^\x00-\x7F]'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (cleanText.isNotEmpty) {
        _tts.speak(cleanText).catchError((_) => null);
      }
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      _tts.stop().catchError((_) => null);
    } catch (_) {}
  }
}
