class EnvironmentLine {
  final String text;
  final bool requiresNight;
  final bool requiresLowBattery;
  final int minCorruption;

  const EnvironmentLine({
    required this.text,
    this.requiresNight = false,
    this.requiresLowBattery = false,
    this.minCorruption = 0,
  });

  factory EnvironmentLine.fromJson(Map<String, dynamic> json) {
    return EnvironmentLine(
      text: json['text'] as String,
      requiresNight: json['requiresNight'] as bool? ?? false,
      requiresLowBattery: json['requiresLowBattery'] as bool? ?? false,
      minCorruption: json['minCorruption'] as int? ?? 0,
    );
  }
}
