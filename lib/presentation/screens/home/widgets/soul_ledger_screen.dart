import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Haptics
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/devil_provider.dart';

class SoulLedgerScreen extends StatelessWidget {
  const SoulLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevilProvider>();
    final realm = provider.currentRealm;
    final history = provider.history;

    Color themeColor = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.grey[400]!);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- THE HEADER WITH POP BACK BUTTON ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // BACK BUTTON
                  IconButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: themeColor.withOpacity(0.7),
                      size: 22,
                    ),
                  ),

                  // RIGHT SIDE ICON (Matches your previous layout)
                  Icon(
                    Icons.auto_graph_sharp,
                    color: themeColor.withOpacity(0.3),
                    size: 24,
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // TITLE & SUBTITLE
              Text(
                "SOUL LEDGER",
                style: GoogleFonts.cinzel(
                  color: themeColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  shadows: [
                    Shadow(color: themeColor.withOpacity(0.5), blurRadius: 15),
                  ],
                ),
              ),
              Text(
                "HISTORY OF YOUR VOWS",
                style: GoogleFonts.spaceMono(
                  color: Colors.grey[600],
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),

              const SizedBox(height: 40),

              // THE CHART CONTAINER
              Text(
                "DISCIPLINE VARIANCE",
                style: GoogleFonts.cinzel(
                  color: Colors.grey[800],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 10),
              AspectRatio(
                aspectRatio: 1.7,
                child: Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: LineChart(
                    LineChartData(
                      gridData: const FlGridData(show: false),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: history.isEmpty
                              ? [const FlSpot(0, 0), const FlSpot(1, 0)]
                              : history
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => FlSpot(
                                        e.key.toDouble(),
                                        e.value.score.toDouble(),
                                      ),
                                    )
                                    .toList(),
                          isCurved: true,
                          curveSmoothness: 0.35,
                          color: themeColor,
                          barWidth: 3,
                          isStrokeCapRound: true,
                          dotData: const FlDotData(show: false),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                themeColor.withOpacity(0.2),
                                themeColor.withOpacity(0.0),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ANALYTICS ROWS
              _buildStatRow("CURRENT ALIGNMENT", realm, themeColor),
              Divider(color: Colors.white.withOpacity(0.05)),
              _buildStatRow(
                "TOTAL VIRTUES",
                "${provider.habits.fold(0, (sum, h) => sum + h.virtues)}",
                Colors.white,
              ),
              Divider(color: Colors.white.withOpacity(0.05)),
              _buildStatRow(
                "TOTAL SINS",
                "${provider.habits.fold(0, (sum, h) => sum + h.sins)}",
                Colors.red[900]!,
              ),

              const Spacer(),

              // Bottom Caption
              Center(
                child: Text(
                  "THE LEDGER NEVER LIES.",
                  style: GoogleFonts.cinzel(
                    color: Colors.grey[800],
                    fontSize: 10,
                    letterSpacing: 3,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.cinzel(
              color: valColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              shadows: [
                if (valColor != Colors.white)
                  Shadow(color: valColor.withOpacity(0.5), blurRadius: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
