import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeSelector extends StatelessWidget {
  final int currentMinutes;
  final Color accent;
  final Function(int) onChanged;

  const TimeSelector({
    super.key,
    required this.currentMinutes,
    required this.accent,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title with atmospheric spacing
        Text(
          "CHRONOS LOCK (MINUTES)",
          style: GoogleFonts.cinzel(
            color: Colors.grey[800],
            fontSize: 9,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Standard Ritual Times
            ...[10, 30, 60].map((t) => _buildHex(t)),
            // The Manual Override
            _buildCustomTrigger(context),
          ],
        ),
      ],
    );
  }

  Widget _buildHex(int mins) {
    bool active = currentMinutes == mins;
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact(); // Tactile confirmation
        onChanged(mins);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 65,
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? accent.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: active ? accent : Colors.white.withOpacity(0.05),
            width: active ? 2 : 1.5,
          ),
          // FEATURE: Active Glow
          boxShadow: active
              ? [
                  BoxShadow(
                    color: accent.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: -2,
                  ),
                ]
              : [],
        ),
        child: Text(
          "$mins",
          style: GoogleFonts.spaceMono(
            color: active ? accent : Colors.grey[600],
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTrigger(BuildContext context) {
    bool isCustom = ![10, 30, 60].contains(currentMinutes);
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showDialog(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 85,
        height: 50,
        decoration: BoxDecoration(
          color: isCustom ? accent.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isCustom ? accent : Colors.white.withOpacity(0.05),
            width: isCustom ? 2 : 1.5,
          ),
        ),
        child: Center(
          child: Text(
            isCustom ? "$currentMinutes" : "CUSTOM",
            style: GoogleFonts.spaceMono(
              color: isCustom ? accent : Colors.grey[600],
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final controller = TextEditingController(
      text: ![10, 30, 60].contains(currentMinutes)
          ? currentMinutes.toString()
          : "",
    );

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF0D0D0D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: accent.withOpacity(0.2)),
          ),
          title: Text(
            "MANUAL OVERRIDE",
            textAlign: TextAlign.center,
            style: GoogleFonts.cinzel(
              color: accent,
              fontSize: 16,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "DEFINE THE LENGTH OF YOUR RITUAL",
                style: GoogleFonts.spaceMono(color: Colors.grey, fontSize: 10),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                autofocus: true,
                textAlign: TextAlign.center,
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: "00",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.1)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accent.withOpacity(0.3)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: accent),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  int? val = int.tryParse(controller.text);
                  if (val != null && val > 0) {
                    onChanged(val);
                    HapticFeedback.heavyImpact();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "SEAL TIME",
                  style: GoogleFonts.spaceMono(
                    color: accent,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
