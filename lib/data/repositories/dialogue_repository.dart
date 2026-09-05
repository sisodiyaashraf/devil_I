import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/ai_line.dart';

class DialogueRepository {
  final String _assetPath;

  DialogueRepository({String assetPath = 'assets/dialogue/ai_lines.json'})
    : _assetPath = assetPath;

  Future<List<AiLine>> loadLines() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => AiLine.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
