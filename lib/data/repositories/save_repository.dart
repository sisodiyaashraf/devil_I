import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants.dart';

class SaveRepository {
  Future<void> saveSessionCorruption(int level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(AppConstants.sessionCorruptionKey, level);
  }

  Future<int> loadLastSessionCorruption() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(AppConstants.sessionCorruptionKey) ?? 0;
  }
}
