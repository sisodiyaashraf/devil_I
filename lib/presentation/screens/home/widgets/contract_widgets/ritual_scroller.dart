import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class RitualScroller extends StatelessWidget {
  final Color accent;
  final Function(String, String) onSelect;

  const RitualScroller({
    super.key,
    required this.accent,
    required this.onSelect
  });

  // EXPANDED RITUAL BANK: More text, more atmosphere
  final List<Map<String, dynamic>> rituals = const [
    {
      'title': 'CODE ABYSS',
      'threat': 'LOGIC WILL ROT. BUGS WILL MULTIPLY.',
      'icon': Icons.terminal,
      'desc': 'DEEP WORK'
    },
    {
      'title': 'DIGITAL SILENCE',
      'threat': 'THE SCROLL CONSUMES YOUR SOUL.',
      'icon': Icons.phonelink_erase,
      'desc': 'DETOX'
    },
    {
      'title': 'IRON TEMPLE',
      'threat': 'FLESH WILL FAIL. WEAKNESS REMAINS.',
      'icon': Icons.fitness_center,
      'desc': 'BODY'
    },
    {
      'title': 'VOID MEDITATION',
      'threat': 'THE NOISE WILL NEVER LEAVE.',
      'icon': Icons.self_improvement,
      'desc': 'MIND'
    },
    {
      'title': 'GRAND CAMPAIGN',
      'threat': 'DEFEAT IS ETERNAL. LOSE EVERYTHING.',
      'icon': Icons.sports_esports,
      'desc': 'GOALS'
    },
    {
      'title': 'PAGED PACT',
      'threat': 'IGNORANCE IS A SLOW DEATH.',
      'icon': Icons.auto_stories,
      'desc': 'STUDY'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with atmospheric letter spacing
        Text(
          "SELECT ARCHETYPE",
          style: GoogleFonts.cinzel(
            color: Colors.grey[800],
            fontSize: 10,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // The Ritual Carousel
        SizedBox(
          height: 70, // Increased height for descriptions
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: rituals.length,
            itemBuilder: (context, i) {
              final r = rituals[i];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: () {
                    // FEATURE: Tactile selection
                    HapticFeedback.mediumImpact();
                    onSelect(r['title'], r['threat']);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.01),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                      // Subtle glow on the container
                      boxShadow: [
                        BoxShadow(
                          color: accent.withOpacity(0.02),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                                r['icon'],
                                size: 16,
                                color: accent.withOpacity(0.8)
                            ),
                            const SizedBox(width: 10),
                            Text(
                              r['title'],
                              style: GoogleFonts.spaceMono(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r['desc'],
                          style: GoogleFonts.spaceMono(
                            color: Colors.grey[700],
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}