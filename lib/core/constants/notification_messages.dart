import 'dart:math';

class NotificationMessages {
  // --- THE DAILY RITUAL CYCLE ---
  // Cycle 0: Morning (The Awakening)
  // Cycle 1: Midday (The Struggle)
  // Cycle 2: Evening (The Weakness)
  // Cycle 3: Night (The Reckoning)

  static final Map<int, List<String>> weeklyMessages = {
    DateTime.monday: [
      "Mondays are for the weak. Prove me wrong.",
      "The week begins its descent. Are you prepared?",
      "The void is fresh today. Don't waste it.",
      "Monday's ledger is still empty. Fill it with virtues.",
    ],
    DateTime.tuesday: [
      "Tuesday's chains are heavy. Break them.",
      "Logic is your only weapon today.",
      "Keep building the abyss. One pact at a time.",
      "The Mirror is watching your Tuesday progress.",
    ],
    DateTime.wednesday: [
      "The midpoint of your suffering. Don't slow down.",
      "Balance your sins. The scales are tipping.",
      "Halfway to heaven or hell? You decide.",
      "Wednesday's audit will be unforgiving.",
    ],
    DateTime.thursday: [
      "Thursday's rot is setting in. Push through.",
      "Your focus is flickering. Focus on the Vow.",
      "The void grows impatient with your silence.",
      "Your pact is bleeding. Seal the leaks.",
    ],
    DateTime.friday: [
      "The end is near. Keep your focus sharp.",
      "Friday's fire burns bright. Don't get scorched.",
      "Do not celebrate yet. The ritual isn't over.",
      "The weekend is a trap. Stay vigilant.",
    ],
    DateTime.saturday: [
      "Saturday: The trap of leisure awaits.",
      "Do not fall for the scroll. Discipline is king.",
      "The Devil never rests, why should you?",
      "Your soul is weighed by your Saturday choices.",
    ],
    DateTime.sunday: [
      "The final reckoning. Look into the Mirror.",
      "Sunday's peace is an illusion. Prepare.",
      "A new cycle begins tomorrow. Audit your soul.",
      "You survived the week. But did you thrive?",
    ],
  };

  /// Gets a message based on the current day and the specific cycle (0-3)
  static String getDailyMessage(int cycleIndex) {
    final int weekday = DateTime.now().weekday;
    final messages = weeklyMessages[weekday] ?? ["I AM WATCHING YOU."];

    // Ensure we don't go out of bounds if cycleIndex > 3
    return messages[cycleIndex % messages.length].toUpperCase();
  }

  /// Optional: Get a random "Urgent" taunt for the 2-minute warning
  static String getUrgentWarning() {
    final List<String> taunts = [
      "TIME IS A CURRENCY YOU CANNOT REFUND.",
      "THE VOID CALLS YOUR NAME.",
      "A BROKEN VOW IS A PERMANENT SCAR.",
      "TIC TOC. THE DEVIL IS WAITING.",
    ];
    return taunts[Random().nextInt(taunts.length)];
  }
}
