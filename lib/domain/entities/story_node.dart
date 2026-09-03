import 'story_choice.dart';

class StoryNode {
  final String id;
  final String text;
  final List<StoryChoice> choices;
  final String? soundCue;
  final bool glitchTrigger;
  final bool jumpscareTrigger;
  final String? qteType;
  final String? threatLevel;
  final String? cameraFeedId;
  final String? qteSuccessNodeId;
  final String? qteFailNodeId;

  const StoryNode({
    required this.id,
    required this.text,
    required this.choices,
    this.soundCue,
    this.glitchTrigger = false,
    this.jumpscareTrigger = false,
    this.qteType,
    this.threatLevel,
    this.cameraFeedId,
    this.qteSuccessNodeId,
    this.qteFailNodeId,
  });
}

