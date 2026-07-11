import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class GlassSettingsPanel extends StatelessWidget {
  final Color accent;
  final TimeOfDay? reminderTime;
  final String severity;
  final bool isBloodOath;
  final int warningMinutes; // NEW: Tracks the alert timing
  final Function(TimeOfDay) onTimePick;
  final Function(String) onSeverityCycle;
  final Function(bool) onOathToggle;
  final Function(int) onWarningCycle; // NEW: Toggles alert lead time

  const GlassSettingsPanel({
    super.key,
    required this.accent,
    this.reminderTime,
    required this.severity,
    required this.isBloodOath,
    required this.warningMinutes,
    required this.onTimePick,
    required this.onSeverityCycle,
    required this.onOathToggle,
    required this.onWarningCycle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02), // Slightly more visible glass
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. RECKONING TIME (When the bell tolls)
          _buildTile(
            context: context,
            icon: Icons.history_toggle_off,
            title: "DEADLINE",
            value: reminderTime?.format(context) ?? "NOT SET",
            onTap: () async {
              HapticFeedback.selectionClick();
              final t = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) => Theme(
                  data: ThemeData.dark().copyWith(
                    colorScheme: ColorScheme.dark(primary: accent),
                  ),
                  child: child!,
                ),
              );
              if (t != null) onTimePick(t);
            },
          ),

          _buildDivider(),

          // 2. THE ALERT (2-Min Warning Logic)
          _buildTile(
            context: context,
            icon: Icons.notifications_active_outlined,
            title: "THE ALERT",
            value: warningMinutes == 0
                ? "EXACT TIME"
                : "$warningMinutes MINS PRIOR",
            onTap: () {
              HapticFeedback.lightImpact();
              // Cycle through 0 (exact), 2 (urgent), and 15 (standard)
              final times = [0, 2, 15];
              final next =
                  times[(times.indexOf(warningMinutes) + 1) % times.length];
              onWarningCycle(next);
            },
          ),

          _buildDivider(),

          // 3. SEVERITY CYCLE
          _buildTile(
            context: context,
            icon: Icons.bolt,
            title: "SEVERITY",
            value: severity,
            onTap: () {
              HapticFeedback.mediumImpact();
              final levels = ["MINOR", "MAJOR", "MORTAL"];
              final next =
                  levels[(levels.indexOf(severity) + 1) % levels.length];
              onSeverityCycle(next);
            },
          ),

          _buildDivider(),

          // 4. BLOOD OATH SWITCH
          _buildTile(
            context: context,
            icon: Icons.water_drop,
            title: "BLOOD OATH",
            value: isBloodOath ? "ACTIVE" : "INACTIVE",
            highlight: isBloodOath,
            onTap: () {
              if (!isBloodOath)
                HapticFeedback.vibrate(); // Violent shake for activation
              onOathToggle(!isBloodOath);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(
    height: 1,
    color: Colors.white10,
    indent: 20,
    endIndent: 20,
  );

  Widget _buildTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
    bool highlight = false,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(
        icon,
        color: highlight ? Colors.redAccent : accent.withOpacity(0.5),
        size: 20,
      ),
      title: Text(
        title,
        style: GoogleFonts.cinzel(
          color: Colors.white30,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: GoogleFonts.spaceMono(
              color: highlight ? Colors.redAccent : accent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.white10, size: 16),
        ],
      ),
    );
  }
}
