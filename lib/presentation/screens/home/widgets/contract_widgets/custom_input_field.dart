import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String label;
  final Color accent;
  final Color border;
  final bool isSmall;

  const CustomInputField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.label,
    required this.accent,
    required this.border,
    this.isSmall = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      // Subtle outer glow when focused could be added here if wrapped in a Focus detector,
      // but for now, we'll focus on the internal TextField decoration.
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onTap: () => HapticFeedback.selectionClick(),
        style: GoogleFonts.spaceMono(
          color: Colors.white,
          fontSize: isSmall ? 13 : 15,
          letterSpacing: 0.5,
        ),
        cursorColor: accent,
        maxLines: isSmall ? 1 : 2, // Allow more room for the Vow title
        minLines: 1,
        decoration: InputDecoration(
          // --- THEMATIC TEXT ---
          labelText: label.toUpperCase(),
          labelStyle: GoogleFonts.cinzel(
            color: Colors.white24,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
          floatingLabelStyle: GoogleFonts.cinzel(
            color: accent,
            fontWeight: FontWeight.bold,
            letterSpacing: 3,
          ),

          // --- ICONOGRAPHY ---
          prefixIcon: Icon(
            isSmall ? Icons.shield_outlined : Icons.auto_fix_high_outlined,
            size: 16,
            color: accent.withOpacity(0.3),
          ),

          // --- SURFACE ---
          filled: true,
          fillColor: Colors.white.withOpacity(0.02),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 22,
          ),

          // --- BORDERS (Gothic Industrial) ---
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: border.withOpacity(0.1), width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide(color: accent, width: 2),
          ),

          // Hint text for better UX
          hintText: isSmall
              ? "The consequence of failure..."
              : "State your oath...",
          hintStyle: GoogleFonts.spaceMono(color: Colors.white10, fontSize: 12),
        ),
      ),
    );
  }
}
