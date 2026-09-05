import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/session_memory.dart';

class MemoryRepository {
  static const String _keyLastOpenedAt = 'memory_last_opened_at';
  static const String _keySessionCount = 'memory_session_count';
  static const String _keyPeakCorruption = 'memory_peak_corruption';
  static const String _keyUserLabel = 'memory_user_label';

  Future<SessionMemory> loadMemory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastOpenedMs = prefs.getInt(_keyLastOpenedAt);
      final sessionCount = prefs.getInt(_keySessionCount) ?? 0;
      final peakCorruption = prefs.getInt(_keyPeakCorruption) ?? 0;
      final userLabel = prefs.getString(_keyUserLabel);

      final lastOpenedAt = lastOpenedMs != null
          ? DateTime.fromMillisecondsSinceEpoch(lastOpenedMs)
          : DateTime.now();

      return SessionMemory(
        lastOpenedAt: lastOpenedAt,
        sessionCount: sessionCount,
        peakCorruption: peakCorruption,
        userLabel: userLabel,
      );
    } catch (_) {
      return SessionMemory(
        lastOpenedAt: DateTime.now(),
        sessionCount: 0,
        peakCorruption: 0,
      );
    }
  }

  Future<void> recordSessionStart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCount = prefs.getInt(_keySessionCount) ?? 0;
      await prefs.setInt(_keySessionCount, currentCount + 1);
      await prefs.setInt(
          _keyLastOpenedAt, DateTime.now().millisecondsSinceEpoch);
    } catch (_) {}
  }

  Future<void> recordPeakCorruption(int level) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentPeak = prefs.getInt(_keyPeakCorruption) ?? 0;
      if (level > currentPeak) {
        await prefs.setInt(_keyPeakCorruption, level);
      }
    } catch (_) {}
  }

  Future<void> saveUserLabel(String label) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keyUserLabel, label);
    } catch (_) {}
  }
}
