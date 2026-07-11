import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// RELATIVE IMPORTS
import '../../../../data/models/soul_entry.dart';

class ReapingHeatmap extends StatelessWidget {
  final List<SoulEntry> history;
  final Color glowColor;

  const ReapingHeatmap({
    super.key,
    required this.history,
    required this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER: Standardized Cinzel Spacing
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 12),
          child: Text(
            "THE 30-DAY LEDGER",
            style: GoogleFonts.cinzel(
              color: Colors.white12,
              fontSize: 10,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // THE GLASS PANEL (Utilizing GlassCard V2)
        GlassCard(
          accentColor: glowColor,
          opacity: 0.08,
          blur: 20,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 10, // 3 rows of 10 for a clean 30-day block
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: 30,
                itemBuilder: (context, index) {
                  return _buildHeatMapNode(index);
                },
              ),
              const SizedBox(height: 16),
              _buildLegend(glowColor),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeatMapNode(int index) {
    // REAL LOGIC: We map the last 30 days.
    // index 29 is Today, index 0 is 30 days ago.
    final DateTime targetDate = DateTime.now().subtract(
      Duration(days: 29 - index),
    );

    // Find entry for this specific date
    final entry = history.cast<SoulEntry?>().firstWhere(
      (e) =>
          e?.timestamp.day == targetDate.day &&
          e?.timestamp.month == targetDate.month,
      orElse: () => null,
    );

    Color nodeColor = Colors.white.withOpacity(0.05); // Default: Empty/Void
    double glowOpacity = 0.0;

    if (entry != null) {
      if (entry.score > 0) {
        nodeColor = glowColor.withOpacity(0.6); // Virtue
        glowOpacity = 0.2;
      } else if (entry.score < 0) {
        nodeColor = Colors.redAccent.withOpacity(0.6); // Sin
        glowOpacity = 0.2;
      } else {
        nodeColor = Colors.white24; // Neutral/Zero
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: nodeColor,
        borderRadius: BorderRadius.circular(4),
        boxShadow: glowOpacity > 0
            ? [
                BoxShadow(
                  color: nodeColor.withOpacity(glowOpacity),
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ]
            : [],
      ),
    );
  }

  Widget _buildLegend(Color accent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem("SINS", Colors.redAccent),
        const SizedBox(width: 16),
        _legendItem("VOID", Colors.white10),
        const SizedBox(width: 16),
        _legendItem("VIRTUE", accent),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.spaceMono(
            color: Colors.white24,
            fontSize: 8,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
