class SessionMemory {
  final DateTime lastOpenedAt;
  final int sessionCount;
  final int peakCorruption;
  final String? userLabel;

  const SessionMemory({
    required this.lastOpenedAt,
    required this.sessionCount,
    required this.peakCorruption,
    this.userLabel,
  });
}
