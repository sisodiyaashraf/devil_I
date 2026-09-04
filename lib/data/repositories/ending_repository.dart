import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class EndingRepository {
  Future<void> recordEnding(String nodeId) async {
    final prefs = await SharedPreferences.getInstance();
    final currentList =
        prefs.getStringList(AppConstants.unlockedEndingsKey) ?? [];
    final unlockedSet = currentList.toSet();

    if (!unlockedSet.contains(nodeId)) {
      unlockedSet.add(nodeId);
      await prefs.setStringList(
        AppConstants.unlockedEndingsKey,
        unlockedSet.toList(),
      );
    }
  }

  Future<Set<String>> getUnlockedEndingIds() async {
    final prefs = await SharedPreferences.getInstance();
    final currentList =
        prefs.getStringList(AppConstants.unlockedEndingsKey) ?? [];
    return currentList.toSet();
  }
}
