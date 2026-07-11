import 'package:isar/isar.dart';

// This line connects your model to the generated Isar code!
part 'habit.g.dart';

@collection
class Habit {
  Id id = Isar.autoIncrement;

  @Index(type: IndexType.value)
  late String title;

  // -------------------------------------------------------------------
  // PACT SETTINGS & SEVERITY
  // -------------------------------------------------------------------
  bool isBloodOath = false;

  // NEW: Determines the weight of the pact ("MINOR", "MAJOR", "MORTAL")
  String severityLevel = "MAJOR";

  // -------------------------------------------------------------------
  // THE GRAVEYARD MECHANIC: Soft Deletion
  // -------------------------------------------------------------------
  @Index()
  bool isActive = true; // True = Ledger, False = Graveyard

  DateTime? shatteredDate; // The exact moment they surrendered

  // -------------------------------------------------------------------
  // GAMIFICATION METRICS
  // -------------------------------------------------------------------
  int virtues = 0; // Successful completions
  int sins = 0; // Missed days or broken focus sessions

  int currentStreak = 0;
  int highestStreak = 0;

  // -------------------------------------------------------------------
  // TIME & FOCUS SETTINGS
  // -------------------------------------------------------------------
  int targetDurationSeconds = 1500; // Default: 25 minutes (1500 seconds)

  // NEW: The exact time of day they must complete the task (e.g., "18:30")
  String? reminderTimeStr;

  // NEW: How many minutes before the reminderTime the Devil warns them
  int warningMinutes = 15;

  bool isCompletedToday = false;
  DateTime? lastCompletedDate;

  // The exact moment the pact was sealed
  DateTime creationDate = DateTime.now();

  // The offline "Devil's Brain" uses this to taunt the user
  late String punishmentThreat;
}
