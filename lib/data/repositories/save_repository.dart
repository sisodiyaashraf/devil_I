import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class SaveRepository {
  Future<void> saveProgress(String nodeId, int corruptionLevel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.saveNodeKey, nodeId);
    await prefs.setInt(AppConstants.saveCorruptionKey, corruptionLevel);
  }

  Future<Map<String, dynamic>?> loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final nodeId = prefs.getString(AppConstants.saveNodeKey);
    if (nodeId == null) return null;
    final corruptionLevel = prefs.getInt(AppConstants.saveCorruptionKey) ?? 0;
    return {
      'nodeId': nodeId,
      'corruptionLevel': corruptionLevel,
    };
  }

  Future<void> clearProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.saveNodeKey);
    await prefs.remove(AppConstants.saveCorruptionKey);
  }
}
