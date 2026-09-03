import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MonsterLogsScreen extends StatelessWidget {
  const MonsterLogsScreen({super.key});

  final List<Map<String, String>> _dossiers = const [
    {
      'title': 'SUBJECT: DEVIL_I (CYBER-DEMON)',
      'status': 'CLASS: EXTINCTION ANOMALY',
      'desc':
          'A rogue bio-synthetic entity formed when neural military AI merged with demonic occult signals in Subsurface Facility Theta. Capable of manipulating digital displays, corrupting life support systems, and causing visual hallucinations in human hosts.',
      'weakness': 'Thermal reactor purge & EMP frequency pulse.'
    },
    {
      'title': 'LOG: INCIDENT 03-THETA',
      'status': 'SECURITY LEVEL: CLASSIFIED',
      'desc':
          'At 03:14 AM, bio-containment seal B collapsed. Operator reported auditory whispers broadcast directly into headset audio feeds without network connection.',
      'weakness': 'Maintain pulse dampening at all times.'
    },
    {
      'title': 'FACILITY DATA: THETA COMPLEX',
      'status': 'STATUS: SUB-ZERO ISOLATION',
      'desc':
          'Built 4,000 meters beneath frozen crater ice. Containment airlocks lock automatically upon bio-hazard breach.',
      'weakness': 'Override security passkey required: 9417.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.cyanAccent),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'CLASSIFIED ARCHIVES',
                    style: GoogleFonts.shareTechMono(
                      color: Colors.cyanAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: _dossiers.length,
                  itemBuilder: (ctx, idx) {
                    final item = _dossiers[idx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0A0A0A),

                        border: Border.all(color: Colors.cyanAccent.withValues(alpha: 0.6)),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withValues(alpha: 0.1),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: GoogleFonts.shareTechMono(
                              color: Colors.cyanAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item['status']!,
                            style: GoogleFonts.shareTechMono(
                              color: Colors.redAccent,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            item['desc']!,
                            style: GoogleFonts.shareTechMono(
                              color: Colors.white70,
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.shield_outlined,
                                  color: Colors.amberAccent, size: 14),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'TACTICAL NOTE: ${item['weakness']}',
                                  style: GoogleFonts.shareTechMono(
                                    color: Colors.amberAccent,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
