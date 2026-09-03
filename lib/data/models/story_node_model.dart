import '../../domain/entities/story_choice.dart';
import '../../domain/entities/story_node.dart';

class StoryNodeModel extends StoryNode {
  const StoryNodeModel({
    required super.id,
    required super.text,
    required super.choices,
    super.soundCue,
    super.glitchTrigger,
    super.jumpscareTrigger,
    super.qteType,
    super.threatLevel,
    super.cameraFeedId,
    super.qteSuccessNodeId,
    super.qteFailNodeId,
  });

  factory StoryNodeModel.fromJson(Map<String, dynamic> json) {
    final rawChoices = json['choices'] as List<dynamic>? ?? [];
    final choices = rawChoices.map((c) {
      final map = c as Map<String, dynamic>;
      return StoryChoice(
        label: map['label'] as String,
        nextNodeId: map['nextNodeId'] as String,
        isDark: map['isDark'] as bool? ?? false,
      );
    }).toList();

    return StoryNodeModel(
      id: json['id'] as String,
      text: json['text'] as String,
      choices: choices,
      soundCue: json['soundCue'] as String?,
      glitchTrigger: json['glitchTrigger'] as bool? ?? false,
      jumpscareTrigger: json['jumpscareTrigger'] as bool? ?? false,
      qteType: json['qteType'] as String?,
      threatLevel: json['threatLevel'] as String?,
      cameraFeedId: json['cameraFeedId'] as String?,
      qteSuccessNodeId: json['qteSuccessNodeId'] as String?,
      qteFailNodeId: json['qteFailNodeId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'choices': choices.map((c) => {
        'label': c.label,
        'nextNodeId': c.nextNodeId,
        'isDark': c.isDark,
      }).toList(),
      'soundCue': soundCue,
      'glitchTrigger': glitchTrigger,
      'jumpscareTrigger': jumpscareTrigger,
      'qteType': qteType,
      'threatLevel': threatLevel,
      'cameraFeedId': cameraFeedId,
      'qteSuccessNodeId': qteSuccessNodeId,
      'qteFailNodeId': qteFailNodeId,
    };
  }
}

