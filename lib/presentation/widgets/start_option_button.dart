import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class StartOptionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const StartOptionButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 360.0),
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.whisperWhite,
          side: const BorderSide(color: AppColors.bloodRed, width: 0.6),
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
        ),
        onPressed: onTap,
        child: Column(
          children: [
            Text(
              title.toUpperCase(),
              style: GoogleFonts.cinzel(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
                color: AppColors.whisperWhite,
              ),
            ),
            const SizedBox(height: 4.0),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Georgia',
                fontSize: 11.0,
                color: AppColors.fadedText,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
