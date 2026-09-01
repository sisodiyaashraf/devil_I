import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class ChapterCard extends StatelessWidget {
  final String chapterNumber;
  final String title;
  final VoidCallback onTap;

  const ChapterCard({
    super.key,
    required this.chapterNumber,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.bloodRed, width: 0.8),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chapterNumber,
                    style: GoogleFonts.cinzel(
                      fontSize: 12.0,
                      color: AppColors.bloodRed,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    title,
                    style: GoogleFonts.cinzel(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whisperWhite,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.fadedText),
          ],
        ),
      ),
    );
  }
}
