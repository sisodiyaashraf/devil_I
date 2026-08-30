import 'dart:convert';
import 'package:flutter/services.dart';
import '../../domain/entities/story_node.dart';
import '../models/story_node_model.dart';

class StoryRepository {
  Future<Map<String, StoryNode>> loadChapter(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return jsonMap.map((key, value) {
      final nodeMap = value as Map<String, dynamic>;
      return MapEntry(key, StoryNodeModel.fromJson(nodeMap));
    });
  }
}
