import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// RELATIVE IMPORTS: Maintaining the shield against Type Mismatch errors
import '../../data/models/habit.dart';
import '../../data/models/soul_entry.dart';
import '../../data/services/database_service.dart';
import '../../core/services/sensory_service.dart';
import '../../core/constants/voice_bank.dart';
import '../../core/services/notification_service.dart';

class DevilProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final SensoryService _sensory = SensoryService();
  final NotificationService _notifications = NotificationService();

  List<Habit> _habits = [];
  List<SoulEntry> _history = [];
  String _devilMessage = "I AM WATCHING YOU.";
  int _soulScore = 0;
  String _lastKnownRealm = "VOID"; // Track realm to prevent notification spam

  // RECKONING STATE
  bool _hasFacedReckoning = true;
  Map<String, dynamic> _lastReckoningReport = {};

  // --- GETTERS ---
  List<Habit> get habits => _habits;
  List<SoulEntry> get history => _history;
  String get devilMessage => _devilMessage;
  int get soulScore => _soulScore;
  bool get hasFacedReckoning => _hasFacedReckoning;
  Map<String, dynamic> get lastReckoningReport => _lastReckoningReport;

  String get currentRealm {
    if (_soulScore <= -15) return "HELL";
    if (_soulScore >= 20) return "HEAVEN";
    return "VOID";
  }

  // --- INITIALIZATION ---
  Future<void> initialize() async {
    await _db.init();
    await _handleMidnightReset();
    await loadHabits();
    await checkDailyAudit();

    // Initial sync of the voice cycle
    _lastKnownRealm = currentRealm;
    await _notifications.scheduleDailyRitualCycle(_lastKnownRealm);
  }

  Future<void> _handleMidnightReset() async {
    final prefs = await SharedPreferences.getInstance();
    final lastRunDate = prefs.getString('last_run_date') ?? "";
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastRunDate != today && lastRunDate.isNotEmpty) {
      final allHabits = await _db.getAllHabits();
      for (var habit in allHabits) {
        habit.isCompletedToday = false;
        await _db.saveHabit(habit);
      }
    }
    await prefs.setString('last_run_date', today);
  }

  Future<void> loadHabits() async {
    final allHabits = await _db.getAllHabits();
    _habits = allHabits.where((h) => h.isActive).toList();
    _history = await _db.getSoulHistory();
    await _calculateSoulScore();
    notifyListeners();
  }

  Future<void> _calculateSoulScore() async {
    int totalVirtues = 0;
    int totalSins = 0;
    int uncompletedToday = 0;

    for (var habit in _habits) {
      totalVirtues += habit.virtues;
      totalSins += habit.sins;
      if (!habit.isCompletedToday) uncompletedToday++;
    }

    _soulScore = totalVirtues - (totalSins * 2);

    // FEATURE: Only refresh cycle if the Realm changes to save battery/system resources
    if (currentRealm != _lastKnownRealm) {
      _lastKnownRealm = currentRealm;
      await _notifications.scheduleDailyRitualCycle(_lastKnownRealm);
    }

    _notifications.scheduleDailyReckoning(uncompletedToday);

    if (_history.isEmpty ||
        (_history.isNotEmpty && _history.last.score != _soulScore)) {
      final entry = SoulEntry()
        ..timestamp = DateTime.now()
        ..score = _soulScore;
      await _db.saveSoulEntry(entry);
      _history.add(entry);
    }
  }

  // --- THE RECKONING ENGINE ---
  Future<void> checkDailyAudit() async {
    final prefs = await SharedPreferences.getInstance();
    final lastAuditDate = prefs.getString('last_audit_date') ?? "";
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastAuditDate != today) {
      _hasFacedReckoning = false;
      _calculateDailyReport();
      notifyListeners();
    }
  }

  void _calculateDailyReport() {
    int kept = _habits.where((h) => h.isCompletedToday).length;
    int total = _habits.length;
    int missed = total - kept;

    _lastReckoningReport = {
      'purity': total == 0 ? 100 : (kept / total * 100).toInt(),
      'sins_added': missed,
      'verdict': missed == 0 ? "SATISFACTORY" : "DISAPPOINTING",
    };
  }

  Future<void> acknowledgeReckoning() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().split('T')[0];
    await prefs.setString('last_audit_date', today);

    _hasFacedReckoning = true;
    notifyListeners();
  }

  // --- PACT MANAGEMENT ---
  Future<void> signContract({
    required String title,
    required String threat,
    required bool isBloodOath,
    required int durationSeconds,
    TimeOfDay? reminderTime,
    required int warningMinutes,
    required String severity,
  }) async {
    final newHabit = Habit()
      ..title = title
      ..punishmentThreat = threat
      ..isBloodOath = isBloodOath
      ..targetDurationSeconds = durationSeconds
      ..isActive = true;

    final id = await _db.saveHabit(newHabit);
    newHabit.id = id;

    if (reminderTime != null) {
      newHabit.reminderTimeStr = "${reminderTime.hour}:${reminderTime.minute}";
      final now = DateTime.now();
      DateTime scheduled = DateTime(
        now.year,
        now.month,
        now.day,
        reminderTime.hour,
        reminderTime.minute,
      );

      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      DateTime warning = scheduled.subtract(Duration(minutes: warningMinutes));
      if (warning.isAfter(now)) {
        await _notifications.scheduleTaskWarning(
          id: newHabit.id,
          title: "THE VOID CALLS ($severity)",
          body: "$title is due soon. $threat",
          scheduledTime: warning,
          realm: currentRealm,
        );
      }
    }

    await _db.saveHabit(newHabit);
    _devilMessage = isBloodOath
        ? "BLOOD HAS SEALED THIS VOW. NO ESCAPE."
        : "A PACT IS SEALED. DO NOT FAIL.";
    await loadHabits();
  }

  // --- ACTIONS ---
  Future<void> earnVirtue(Habit habit) async {
    habit.virtues += 1;
    habit.isCompletedToday = true;
    habit.lastCompletedDate = DateTime.now();
    await _db.saveHabit(habit);

    _devilMessage = VoiceBank.getTaunt(
      "virtue_earned",
      "ADEQUATE.",
    ).toUpperCase();
    await _sensory.triggerReward();
    await loadHabits();
  }

  Future<void> commitSin(Habit habit, {String trigger = "missed_habit"}) async {
    habit.sins += 1;
    await _db.saveHabit(habit);

    String taunt = VoiceBank.getTaunt(trigger, "PATHETIC.");
    _devilMessage = "$taunt\nREMEMBER: ${habit.punishmentThreat}".toUpperCase();

    await _sensory.triggerPunishment(isMortal: habit.isBloodOath);
    await loadHabits();
  }

  Future<void> breakContract(Habit habit) async {
    if (habit.isBloodOath) {
      habit.sins += 5;
      await _db.saveHabit(habit);
      _devilMessage = "YOU CANNOT RUN FROM A BLOOD OATH.";
      await _sensory.triggerPunishment(isMortal: true);
      await _calculateSoulScore();
      notifyListeners();
      return;
    }

    habit.isActive = false;
    habit.shatteredDate = DateTime.now();
    await _db.saveHabit(habit);
    _devilMessage = "A VOW HAS BEEN SHATTERED.";
    await loadHabits();
  }
}
