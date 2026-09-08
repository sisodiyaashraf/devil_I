class LoreFragment {
  final String text;
  final int minSessionCount;

  const LoreFragment({
    required this.text,
    required this.minSessionCount,
  });

  factory LoreFragment.fromJson(Map<String, dynamic> json) {
    return LoreFragment(
      text: json['text'] as String,
      minSessionCount: json['minSessionCount'] as int? ?? 1,
    );
  }
}
