import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

// RELATIVE IMPORTS
import '../../../../presentation/providers/devil_provider.dart';
import '../../focus/focus_screen.dart';

class HabitList extends StatelessWidget {
  const HabitList({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevilProvider>();
    final habits = provider.habits;
    final realm = provider.currentRealm;

    final Color accentColor = _getAccentColor(realm);

    if (habits.isEmpty) {
      return _buildEmptyState(realm, accentColor);
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 10,
        bottom: 180.0,
      ),
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        final bool doneToday = habit.isCompletedToday;

        // BLOOD OATHS maintain their red warning color regardless of realm
        final Color effectiveAccent = habit.isBloodOath
            ? Colors.redAccent
            : accentColor;

        return Dismissible(
          key: Key(habit.id.toString()),
          direction: habit.isBloodOath
              ? DismissDirection.none
              : DismissDirection.endToStart,
          background: _buildDismissBackground(),
          onDismissed: (_) {
            HapticFeedback.vibrate();
            provider.breakContract(habit);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GlassCard(
              accentColor: doneToday ? Colors.grey : effectiveAccent,
              // MODERERN LOGIC: High blur for active, low for done
              blur: doneToday ? 8.0 : 22.0,
              opacity: doneToday ? 0.04 : 0.12,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onLongPress: () {
                  HapticFeedback.heavyImpact();
                  provider.commitSin(habit);
                },
                child: Column(
                  children: [
                    _buildHabitTile(habit, doneToday, effectiveAccent),
                    if (!doneToday)
                      _buildFocusButton(context, habit, effectiveAccent),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- COMPONENT HELPERS ---

  Widget _buildHabitTile(dynamic habit, bool done, Color accent) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          habit.isBloodOath
              ? Icons.water_drop
              : Icons.auto_awesome_mosaic_outlined,
          color: done ? Colors.white10 : accent.withOpacity(0.9),
          size: 20,
        ),
      ),
      title: Text(
        habit.title.toUpperCase(),
        style: GoogleFonts.cinzel(
          color: done ? Colors.white24 : Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          decoration: done ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "VIRTUES: ${habit.virtues}  |  SINS: ${habit.sins}",
              style: GoogleFonts.spaceMono(
                color: done ? Colors.white10 : accent.withOpacity(0.6),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (!done) ...[
              const SizedBox(height: 4),
              Text(
                habit.punishmentThreat,
                style: GoogleFonts.spaceMono(
                  color: Colors.white24,
                  fontSize: 9,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
      trailing: _buildCompletionIcon(done, accent),
    );
  }

  Widget _buildFocusButton(BuildContext context, dynamic habit, Color accent) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [accent.withOpacity(0.1), Colors.transparent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: OutlinedButton.icon(
          icon: Icon(Icons.bolt, size: 16, color: accent),
          label: Text(
            "ENTER FOCUS REALM",
            style: GoogleFonts.spaceMono(
              color: accent,
              fontWeight: FontWeight.bold,
              fontSize: 11,
              letterSpacing: 2,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: accent.withOpacity(0.4)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FocusScreen(habit: habit),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompletionIcon(bool done, Color accent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: done ? Colors.greenAccent : accent.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Icon(
        done ? Icons.check : Icons.radio_button_off,
        color: done ? Colors.greenAccent : accent.withOpacity(0.4),
        size: 18,
      ),
    );
  }

  Widget _buildEmptyState(String realm, Color accent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.blur_on, color: accent.withOpacity(0.1), size: 100),
          const SizedBox(height: 20),
          Text(
            realm == "HEAVEN" ? "ASCENSION AWAITS." : "THE LEDGER IS EMPTY.",
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              color: accent.withOpacity(0.4),
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDismissBackground() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 30),
      child: const Icon(
        Icons.delete_sweep_outlined,
        color: Colors.redAccent,
        size: 28,
      ),
    );
  }

  Color _getAccentColor(String realm) {
    if (realm == "HEAVEN") return Colors.amberAccent;
    if (realm == "HELL") return Colors.redAccent;
    return Colors.cyanAccent;
  }

  Color _getBorderColor(String realm) {
    if (realm == "HEAVEN") return Colors.amber[700]!;
    if (realm == "HELL") return Colors.red[900]!;
    return Colors.grey[800]!;
  }
}
