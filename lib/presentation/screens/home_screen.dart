import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/glitch_utils.dart';
import '../../core/theme.dart';
import '../providers/story_provider.dart';
import '../widgets/chapter_card.dart';
import '../widgets/start_option_button.dart';
import 'endings_list_screen.dart';
import 'monster_logs_screen.dart';
import 'story_screen.dart';
import 'survival_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasSave = false;
  int _unlockedEndings = 0;
  int _totalEndings = 0;
  bool _isLoading = true;
  double _titleOpacity = 1.0;
  Timer? _flickerTimer;

  @override
  void initState() {
    super.initState();
    _loadState();
    _flickerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!mounted) return;
      setState(() => _titleOpacity = 0.5 + math.Random().nextDouble() * 0.3);
      Timer(GlitchUtils.randomFlickerDuration(), () {
        if (mounted) setState(() => _titleOpacity = 1.0);
      });
    });
  }

  @override
  void dispose() {
    _flickerTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadState() async {
    final provider = context.read<StoryProvider>();
    final hasSave = await provider.hasSavedProgress();
    final unlocked = await provider.getUnlockedEndings();
    final definitions = await provider.loadEndingDefinitions();
    if (mounted) {
      setState(() {
        _hasSave = hasSave;
        _unlockedEndings = unlocked.length;
        _totalEndings = definitions.length;
        _isLoading = false;
      });
    }
  }

  Future<void> _launchStory(StoryProvider provider, Future<void> Function() action) async {
    await action();
    if (mounted) {
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, animation, __) => const StoryScreen(),
          transitionsBuilder: (_, animation, __, child) {
            final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            final scale = Tween<double>(begin: 0.95, end: 1.0).animate(fade);
            return FadeTransition(opacity: fade, child: ScaleTransition(scale: scale, child: child));
          },
        ),
      ).then((_) => _loadState());
    }
  }

  void _showContinueDialog(StoryProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0A0A0A),

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StartOptionButton(
              title: 'Continue Mission',
              subtitle: 'Resume neural terminal session',
              onTap: () {
                Navigator.pop(ctx);
                _launchStory(provider, () => provider.continueFromSave());
              },
            ),
            const SizedBox(height: 16.0),
            StartOptionButton(
              title: 'Reboot System',
              subtitle: 'Purge current session memory',
              onTap: () {
                Navigator.pop(ctx);
                provider.reset();
                _launchStory(provider, () => provider.loadStory());
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.redAccent, strokeWidth: 2.0),
        ),
      );
    }

    final provider = context.read<StoryProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 10.0),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: _titleOpacity,
                child: Text(
                  'PROJECT DEVIL_I',
                  style: GoogleFonts.shareTechMono(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                    letterSpacing: 6.0,
                    shadows: [
                      const Shadow(blurRadius: 12, color: Colors.redAccent),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Text(
                'CYBERNETIC HORROR CONTAINMENT SYSTEM',
                style: GoogleFonts.shareTechMono(
                  fontSize: 11.0,
                  color: Colors.grey.shade400,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 30.0),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ChapterCard(
                      chapterNumber: 'CAMPAIGN MODE',
                      title: 'CONTAINMENT BREACH THETA',
                      onTap: () {
                        if (_hasSave) {
                          _showContinueDialog(provider);
                        } else {
                          _launchStory(provider, () => provider.loadStory());
                        }
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildMenuCard(
                      title: 'SURVIVE THE BREACH',
                      subtitle: 'Endless Arcade QTE Horror Survival',
                      icon: Icons.shield_sharp,
                      color: Colors.redAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const SurvivalScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildMenuCard(
                      title: 'CLASSIFIED ARCHIVES',
                      subtitle: 'Monster Dossier & Security Logs',
                      icon: Icons.folder_special,
                      color: Colors.cyanAccent,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MonsterLogsScreen()),
                        );
                      },
                    ),
                    const SizedBox(height: 16.0),
                    _buildEndingsCounterTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),

          border: Border.all(color: color.withValues(alpha: 0.6), width: 1.0),
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.shareTechMono(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: color,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.shareTechMono(
                      fontSize: 11.0,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color),
          ],
        ),
      ),
    );
  }

  Widget _buildEndingsCounterTile() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EndingsListScreen()),
        ).then((_) => _loadState());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.5),
          border: Border.all(color: AppColors.fadedText.withValues(alpha: 0.2), width: 0.6),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'ENDINGS UNLOCKED',
              style: GoogleFonts.shareTechMono(
                fontSize: 13.0,
                color: AppColors.fadedText,
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '$_unlockedEndings / $_totalEndings',
              style: GoogleFonts.shareTechMono(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: AppColors.whisperWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
