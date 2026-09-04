import 'presence_signal.dart';

class AiLine {
  final String text;
  final PresenceSignal? triggeredBy;
  final int minCorruption;

  const AiLine({
    required this.text,
    this.triggeredBy,
    required this.minCorruption,
  });

  factory AiLine.fromJson(Map<String, dynamic> json) {
    PresenceSignal? signal;
    final signalStr = json['triggeredBy'] as String?;
    if (signalStr != null) {
      for (final val in PresenceSignal.values) {
        if (val.name == signalStr) {
          signal = val;
          break;
        }
      }
    }
    return AiLine(
      text: json['text'] as String,
      triggeredBy: signal,
      minCorruption: json['minCorruption'] as int? ?? 0,
    );
  }
}
