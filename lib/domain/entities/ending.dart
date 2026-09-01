class Ending {
  final String nodeId;
  final String title;
  final String description;

  const Ending({
    required this.nodeId,
    required this.title,
    required this.description,
  });

  factory Ending.fromJson(Map<String, dynamic> json) {
    return Ending(
      nodeId: json['nodeId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
