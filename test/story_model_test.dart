import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:whispers/data/models/story_node_model.dart';

void main() {
  test('StoryNodeModel parses chapter1.json correctly', () {
    final file = File('assets/story/chapter1.json');
    final jsonString = file.readAsStringSync();
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    expect(jsonMap.containsKey('start'), isTrue);

    final startJson = jsonMap['start'] as Map<String, dynamic>;
    final startNode = StoryNodeModel.fromJson(startJson);

    expect(startNode.id, 'start');
    expect(startNode.soundCue, 'creak');
    expect(startNode.glitchTrigger, isFalse);
    expect(startNode.choices.length, 2);
    expect(startNode.choices[0].label, 'Investigate the stairs');
    expect(startNode.choices[0].nextNodeId, 'stairs_up');
    expect(startNode.choices[0].isDark, isTrue);

    final bedroomJson = jsonMap['bedroom_trap'] as Map<String, dynamic>;
    final bedroomNode = StoryNodeModel.fromJson(bedroomJson);
    expect(bedroomNode.id, 'bedroom_trap');
    expect(bedroomNode.glitchTrigger, isTrue);
    expect(bedroomNode.choices, isEmpty);

    final serialized = bedroomNode.toJson();
    expect(serialized['id'], 'bedroom_trap');
    expect(serialized['glitchTrigger'], isTrue);
  });
}
