class SessionMemory {
  final DateTime lastOpenedAt;
  final int sessionCount;
  final int peakCorruption;
  final String? userLabel;
  final Map<String, String> userAnswers;

  const SessionMemory({
    required this.lastOpenedAt,
    required this.sessionCount,
    required this.peakCorruption,
    this.userLabel,
    this.userAnswers = const {},
  });
}

