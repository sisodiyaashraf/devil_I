import 'dart:ui';
import 'package:devil_i/presentation/screens/home/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

// RELATIVE IMPORTS
import '../../providers/devil_provider.dart';
import '../../../data/models/habit.dart';

class MirrorScreen extends StatelessWidget {
  const MirrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevilProvider>();
    final habits = provider.habits;
    final realm = provider.currentRealm;
    final soulScore = provider.soulScore;

    // 2026 THEMATIC ACCENTS
    Color accentColor = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.cyanAccent);

    String judgmentHeader = realm == "HEAVEN"
        ? "DIVINE REFLECTION"
        : (realm == "HELL" ? "CORRUPTED IMAGE" : "NEUTRAL VOID");

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // LAYER 1: THE ABYSS GLOW
          _buildAtmosphericGlow(accentColor),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. THE AUDIT HEADER
                SliverToBoxAdapter(
                  child: _buildMirrorHeader(
                    judgmentHeader,
                    soulScore,
                    accentColor,
                  ),
                ),

                // 2. THE SOUL TREND (Historical Analysis)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildSoulTrendChart(provider.history, accentColor),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),

                // 3. SECTION LABEL
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Text(
                      "THE INDIVIDUAL LEDGER",
                      style: GoogleFonts.cinzel(
                        color: Colors.white24,
                        fontSize: 10,
                        letterSpacing: 4,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // 4. THE CONTRACT CARDS (Wrapped in optimized Glass)
                habits.isEmpty
                    ? _buildEmptyState(accentColor)
                    : SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _ReflectiveContractCard(
                            habit: habits[index],
                            accent: accentColor,
                          ),
                          childCount: habits.length,
                        ),
                      ),

                const SliverToBoxAdapter(child: SizedBox(height: 140)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildAtmosphericGlow(Color accent) {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.8),
            radius: 1.4,
            colors: [accent.withOpacity(0.12), Colors.black],
          ),
        ),
      ),
    );
  }

  Widget _buildMirrorHeader(String title, int score, Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
      child: Column(
        children: [
          Text(
            "THE MIRROR",
            style: GoogleFonts.cinzel(
              color: accent.withOpacity(0.5),
              letterSpacing: 10,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          // SCORE WITH BLOOM EFFECT
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                score >= 0 ? "+$score" : "$score",
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: accent.withOpacity(0.8), blurRadius: 40),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.cinzel(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              letterSpacing: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSoulTrendChart(List<dynamic> history, Color accent) {
    if (history.isEmpty) return const SizedBox.shrink();

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      padding: const EdgeInsets.all(20),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: history.asMap().entries.map((e) {
                return FlSpot(e.key.toDouble(), e.value.score.toDouble());
              }).toList(),
              isCurved: true,
              color: accent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [accent.withOpacity(0.2), Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(Color accent) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Center(
          child: Text(
            "THE MIRROR IS DARK.\nNO PACTS RECORDED.",
            textAlign: TextAlign.center,
            style: GoogleFonts.spaceMono(
              color: accent.withOpacity(0.1),
              fontSize: 12,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReflectiveContractCard extends StatelessWidget {
  final Habit habit;
  final Color accent;

  const _ReflectiveContractCard({required this.habit, required this.accent});

  @override
  Widget build(BuildContext context) {
    int balance = habit.virtues - habit.sins;
    // Card accent depends on the individual habit's health
    Color cardColor = balance < 0
        ? Colors.redAccent
        : (balance > 0 ? Colors.amberAccent : Colors.grey);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: GlassCard(
        accentColor: cardColor,
        blur: 15,
        opacity: 0.08,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      habit.title.toUpperCase(),
                      style: GoogleFonts.cinzel(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.isBloodOath
                          ? "BLOOD OATH • MORTAL"
                          : "STANDARD VOW",
                      style: GoogleFonts.spaceMono(
                        color: Colors.white24,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  balance >= 0 ? "+$balance" : "$balance",
                  style: GoogleFonts.spaceMono(
                    color: cardColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // THE MORAL SCALE (Visual Virtue vs Sin)
            _buildMoralBar(habit.virtues, habit.sins),

            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniStat("VIRTUES", habit.virtues, Colors.white),
                _miniStat("SINS", habit.sins, Colors.redAccent),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoralBar(int virtues, int sins) {
    int total = virtues + sins;
    if (total == 0) return Container(height: 2, color: Colors.white10);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Expanded(
            flex: virtues,
            child: Container(height: 4, color: Colors.white),
          ),
          const SizedBox(width: 2),
          Expanded(
            flex: sins,
            child: Container(height: 4, color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, int val, Color color) {
    return Row(
      children: [
        Text(
          "$val ",
          style: GoogleFonts.spaceMono(
            color: color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.cinzel(
            color: Colors.white12,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
