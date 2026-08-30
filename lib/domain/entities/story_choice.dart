class StoryChoice {
  final String label;
  final String nextNodeId;
  final bool isDark;

  const StoryChoice({
    required this.label,
    required this.nextNodeId,
    this.isDark = false,
  });
}
