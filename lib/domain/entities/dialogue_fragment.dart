import '../../domain/entities/presence_signal.dart';

class DialogueFragment {
  final String id;
  final String slot;
  final String text;
  final PresenceSignal? requiredSignal;
  final int minCorruption;
  final int maxUsesPerSession;
  final String tone;

  const DialogueFragment({
    required this.id,
    required this.slot,
    required this.text,
    this.requiredSignal,
    this.minCorruption = 0,
    this.maxUsesPerSession = 2,
    this.tone = 'neutral',
  });

  factory DialogueFragment.fromJson(Map<String, dynamic> json) {
    PresenceSignal? signal;
    if (json['requiredSignal'] != null) {
      final sigStr = json['requiredSignal'] as String;
      signal = PresenceSignal.values.firstWhere(
        (e) => e.name == sigStr,
        orElse: () => PresenceSignal.idle,
      );
    }
    return DialogueFragment(
      id: json['id'] as String,
      slot: json['slot'] as String,
      text: json['text'] as String,
      requiredSignal: signal,
      minCorruption: json['minCorruption'] as int? ?? 0,
      maxUsesPerSession: json['maxUsesPerSession'] as int? ?? 2,
      tone: json['tone'] as String? ?? 'neutral',
    );
  }
}
