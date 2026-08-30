import 'story_choice.dart';

class StoryNode {
  final String id;
  final String text;
  final List<StoryChoice> choices;
  final String? soundCue;
  final bool glitchTrigger;

  const StoryNode({
    required this.id,
    required this.text,
    required this.choices,
    this.soundCue,
    this.glitchTrigger = false,
  });
}
