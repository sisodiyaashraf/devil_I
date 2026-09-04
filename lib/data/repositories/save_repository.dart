import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class SaveRepository {
  Future<void> saveSessionCorruption(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(AppConstants.sessionCorruptionKey, level);
    } catch (_) {}
  }

  Future<int> loadLastSessionCorruption() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(AppConstants.sessionCorruptionKey) ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
