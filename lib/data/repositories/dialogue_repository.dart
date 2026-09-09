import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/ai_line.dart';
import '../../domain/entities/dialogue_fragment.dart';

class DialogueRepository {
  final String _assetPath;
  final String _fragmentsPath;

  DialogueRepository({
    String assetPath = 'assets/dialogue/ai_lines.json',
    String fragmentsPath = 'assets/dialogue/fragments.json',
  }) : _assetPath = assetPath,
       _fragmentsPath = fragmentsPath;

  Future<List<AiLine>> loadLines() async {
    try {
      final jsonString = await rootBundle
          .loadString(_assetPath)
          .timeout(const Duration(seconds: 1), onTimeout: () => '');
      if (jsonString.isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => AiLine.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<List<DialogueFragment>> loadFragments() async {
    try {
      final jsonString = await rootBundle
          .loadString(_fragmentsPath)
          .timeout(const Duration(seconds: 1), onTimeout: () => '');
      if (jsonString.isEmpty) return [];
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map(
            (item) => DialogueFragment.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }
}
