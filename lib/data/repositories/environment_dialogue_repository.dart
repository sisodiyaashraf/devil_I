import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/environment_line.dart';

class EnvironmentDialogueRepository {
  final String _assetPath;

  EnvironmentDialogueRepository({
    String assetPath = 'assets/dialogue/environment_lines.json',
  }) : _assetPath = assetPath;

  Future<List<EnvironmentLine>> loadLines() async {
    try {
      final jsonString = await rootBundle.loadString(_assetPath);
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((item) => EnvironmentLine.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }
}
