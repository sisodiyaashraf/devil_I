import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../../domain/entities/lore_fragment.dart';

class LoreRepository {
  final String _assetPath;
  final Random _random;

  LoreRepository({
    String assetPath = 'assets/dialogue/lore_fragments.json',
    Random? random,
  })  : _assetPath = assetPath,
        _random = random ?? Random();

  Future<List<LoreFragment>> loadLore() async {
    try {
      final jsonStr = await rootBundle.loadString(_assetPath);
      final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
      return list
          .map((i) => LoreFragment.fromJson(i as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<LoreFragment?> pickUnseenLore(
    int sessionCount,
    Set<String> alreadyShownTexts,
  ) async {
    final allLore = await loadLore();
    final eligible = allLore.where((item) {
      final meetsSession = sessionCount >= item.minSessionCount;
      final notShown = !alreadyShownTexts.contains(item.text);
      return meetsSession && notShown;
    }).toList();

    if (eligible.isEmpty) return null;
    return eligible[_random.nextInt(eligible.length)];
  }
}
