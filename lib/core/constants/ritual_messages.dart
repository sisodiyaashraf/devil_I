import 'dart:math';

class RitualMessages {
  // --- THE SANCTUM (HEAVEN) ---
  static const Map<int, List<String>> _heavenlyWeekly = {
    DateTime.monday: [
      "A new dawn of discipline.",
      "The light of Monday is yours to claim.",
      "Begin your ascent.",
    ],
    DateTime.tuesday: [
      "The path of truth is clear.",
      "Wisdom is found in consistency.",
      "Your soul is steady.",
    ],
    DateTime.wednesday: [
      "The midpoint of grace.",
      "The light recognizes your toil.",
      "Virtue outweighs the void.",
    ],
    DateTime.thursday: [
      "Thursday’s peace is earned.",
      "Listen to the silence of the sanctum.",
      "Purity is a daily choice.",
    ],
    DateTime.friday: [
      "Divine clarity approaches.",
      "Your strength is a testament to the light.",
      "The glow intensifies.",
    ],
    DateTime.saturday: [
      "Sabbath of the disciplined.",
      "Even in rest, your soul is active.",
      "Saturday is a gift for the faithful.",
    ],
    DateTime.sunday: [
      "The Reflection of Victory.",
      "Your record is clean. Rest in peace.",
      "Prepare for a new cycle of light.",
    ],
  };

  // --- THE ABYSS (HELL) ---
  static const Map<int, List<String>> _hellishWeekly = {
    DateTime.monday: [
      "Mondays are for the weak.",
      "Start the descent. The void is hungry.",
      "Monday’s ledger is empty.",
    ],
    DateTime.tuesday: [
      "Tuesday’s chains are heavy.",
      "Logic is your only weapon in the abyss.",
      "The Mirror tracks your decay.",
    ],
    DateTime.wednesday: [
      "The midpoint of suffering.",
      "Halfway to hell? You're moving fast.",
      "The audit will be unforgiving.",
    ],
    DateTime.thursday: [
      "Thursday’s rot is setting in.",
      "Your focus is a dying candle.",
      "The void grows impatient.",
    ],
    DateTime.friday: [
      "The end is near. Sharpen your focus.",
      "Friday’s fire burns. Don't get scorched.",
      "The audit is coming. Hide your sins.",
    ],
    DateTime.saturday: [
      "The trap of leisure is set.",
      "Discipline is your master. Sunday is a lie.",
      "The Devil never rests.",
    ],
    DateTime.sunday: [
      "The final reckoning. Look inside.",
      "Prepare for a new cycle of pain.",
      "You survived. But you are thinner.",
    ],
  };

  // --- THE VOID (NEUTRAL) ---
  static const List<String> _neutralMessages = [
    "THE MIRROR IS BLANK.",
    "AWAITING YOUR FIRST PACT.",
    "THE SCALES ARE BALANCED... FOR NOW.",
    "THE VOID IS WATCHING YOUR SILENCE.",
  ];

  /// Main Logic: Fetches message based on Realm, Cycle, and Day
  static String getMessage(int cycleIndex, String realm) {
    final int weekday = DateTime.now().weekday;

    List<String> messages;
    if (realm == "HEAVEN") {
      messages = _heavenlyWeekly[weekday] ?? ["THE LIGHT WATCHES."];
    } else if (realm == "HELL") {
      messages = _hellishWeekly[weekday] ?? ["I AM WATCHING YOU."];
    } else {
      messages = _neutralMessages;
    }

    String baseMessage = messages[cycleIndex % messages.length];
    return _applyAtmosphericFormatting(baseMessage, realm);
  }

  /// Urgent 2-Minute Warnings
  static String getUrgentWarning(String realm) {
    final random = Random();
    final List<String> taunts = realm == "HEAVEN"
        ? [
            "THE LIGHT IS DIMMING.",
            "DO NOT STUMBLE NOW.",
            "YOUR VOW IS ALMOST SEALED.",
          ]
        : [
            "TIME IS A CURRENCY YOU CAN'T REFUND.",
            "TIC TOC. THE VOID WAITS.",
            "A BROKEN VOW IS AN ETERNAL SCAR.",
          ];

    return _applyAtmosphericFormatting(
      taunts[random.nextInt(taunts.length)],
      realm,
    );
  }

  /// FEATURE: Adds atmospheric character based on the Realm
  static String _applyAtmosphericFormatting(String text, String realm) {
    if (realm == "HELL") {
      // Add a touch of aggressive punctuation for Hells
      return "!! ${text.toUpperCase()} !!";
    } else if (realm == "HEAVEN") {
      // Add a touch of elegance for Heaven
      return "✧ ${text.toUpperCase()} ✧";
    }
    return text.toUpperCase();
  }
}
