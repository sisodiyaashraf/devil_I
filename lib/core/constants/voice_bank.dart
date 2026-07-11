import 'dart:math';

class VoiceBank {
  // We've expanded your JSON into a full Flutter List!
  static const List<Map<String, dynamic>> devilQuotes = [
    // --- SINS (Missed Habits) ---
    {
      "trigger": "missed_habit",
      "message": "Pathetic. Your discipline is as weak as your excuses.",
      "severity": "high",
    },
    {
      "trigger": "missed_habit",
      "message": "Another failure. I expected nothing less from you.",
      "severity": "high",
    },
    // --- SINS (Focus Timer Fails) ---
    {
      "trigger": "focus_distracted",
      "message": "I see your eyes wandering. The void is watching.",
      "severity": "critical",
    },
    {
      "trigger": "focus_surrender",
      "message": "You gave up. Weakness is a choice, and you just made it.",
      "severity": "critical",
    },
    // --- VIRTUES (Successes) ---
    {
      "trigger": "virtue_earned",
      "message": "Adequate. But do not let it go to your head.",
      "severity": "low",
    },
    {
      "trigger": "virtue_earned",
      "message": "Your soul survives another day. Barely.",
      "severity": "low",
    },
  ];

  // The engine that grabs a random quote based on what the user did
  static String getTaunt(String triggerType, String fallback) {
    // Find all quotes that match the trigger
    final matchingQuotes = devilQuotes
        .where((q) => q['trigger'] == triggerType)
        .toList();

    // If we can't find one, use the fallback
    if (matchingQuotes.isEmpty) return fallback;

    // Pick a random quote from the matching list
    final random = Random();
    final selectedQuote = matchingQuotes[random.nextInt(matchingQuotes.length)];

    return selectedQuote['message'];
  }
}
