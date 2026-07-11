import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

// RELATIVE IMPORTS: Ensuring type-safety across the Ritual
import '../models/habit.dart';
import '../models/soul_entry.dart';

class DatabaseService {
  // Static instance to ensure a single connection to the void
  static Isar? _isar;

  // Getter that ensures the database is initialized before any operation
  Future<Isar> get db async {
    if (_isar != null) return _isar!;
    await init();
    return _isar!;
  }

  /// Initialize the offline database (The Devil's Brain)
  Future<void> init() async {
    // 1. Check if an instance is already open by name (Standard is 'default')
    if (Isar.instanceNames.isNotEmpty) {
      _isar = Isar.getInstance();
      return;
    }

    // 2. Get the physical path on the device
    final dir = await getApplicationDocumentsDirectory();

    // 3. Open the gates to the Habit and SoulEntry collections
    _isar = await Isar.open(
      [HabitSchema, SoulEntrySchema],
      directory: dir.path,
      inspector: true, // Allows you to debug the DB via Isar Inspector in dev
    );
  }

  // ==========================================
  // PACT (HABIT) LOGIC
  // ==========================================

  /// Saves or updates a Pact. Returns the unique ID for Notification scheduling.
  Future<int> saveHabit(Habit habit) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      return await isar.habits.put(habit);
    });
  }

  /// Retrieves all contracts currently stored in the void.
  Future<List<Habit>> getAllHabits() async {
    final isar = await db;
    return await isar.habits.where().findAll();
  }

  /// Permanent deletion of a pact from the ledger.
  Future<void> deleteHabit(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
  }

  // ==========================================
  // SOUL LEDGER (HISTORY) LOGIC
  // ==========================================

  /// Log a new score entry into the eternal record.
  Future<int> saveSoulEntry(SoulEntry entry) async {
    final isar = await db;
    return await isar.writeTxn(() async {
      return await isar.soulEntrys.put(entry);
    });
  }

  /// FEATURE: Optimized for the Mirror Chart.
  /// Fetches only the last 30 days of history to keep the UI fast.
  Future<List<SoulEntry>> getRecentSoulHistory() async {
    final isar = await db;
    final thirtyDaysAgo = DateTime.now().subtract(const Duration(days: 30));

    return await isar.soulEntrys
        .filter()
        .timestampGreaterThan(thirtyDaysAgo)
        .sortByTimestamp()
        .findAll();
  }

  /// Get the full history (Use sparingly for deep audits).
  Future<List<SoulEntry>> getSoulHistory() async {
    final isar = await db;
    return await isar.soulEntrys.where().sortByTimestamp().findAll();
  }

  // ==========================================
  // SYSTEM MAINTENANCE
  // ==========================================

  /// The "Soul Reset": Wipes all habits and history.
  Future<void> clearAllData() async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.habits.clear();
      await isar.soulEntrys.clear();
    });
  }
}
