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
import 'story_screen.dart';

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
    _flickerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      setState(() => _titleOpacity = 0.65 + math.Random().nextDouble() * 0.2);
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
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, animation, __) => const StoryScreen(),
          transitionsBuilder: (_, animation, __, child) {
            final fade = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
            final scale = Tween<double>(begin: 0.98, end: 1.0).animate(fade);
            return FadeTransition(opacity: fade, child: ScaleTransition(scale: scale, child: child));
          },
        ),
      ).then((_) => _loadState());
    }
  }

  void _showContinueDialog(StoryProvider provider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4.0)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StartOptionButton(
              title: 'Continue',
              subtitle: 'Something remembers where you left off',
              onTap: () {
                Navigator.pop(ctx);
                _launchStory(provider, () => provider.continueFromSave());
              },
            ),
            const SizedBox(height: 16.0),
            StartOptionButton(
              title: 'Start Over',
              subtitle: 'Forget everything',
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
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.bloodRed, strokeWidth: 2.0),
        ),
      );
    }

    final provider = context.read<StoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 100),
                opacity: _titleOpacity,
                child: Text(
                  'WHISPERS',
                  style: GoogleFonts.cinzel(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bloodRed,
                    letterSpacing: 8.0,
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'A text horror experience',
                style: GoogleFonts.cinzel(
                  fontSize: 12.0,
                  color: AppColors.fadedText,
                  letterSpacing: 2.0,
                ),
              ),
              const SizedBox(height: 50.0),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ChapterCard(
                      chapterNumber: 'CHAPTER 1',
                      title: 'The House Above',
                      onTap: () {
                        if (_hasSave) {
                          _showContinueDialog(provider);
                        } else {
                          _launchStory(provider, () => provider.loadStory());
                        }
                      },
                    ),
                    const SizedBox(height: 24.0),
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
          color: AppColors.surface.withOpacity(0.5),
          border: Border.all(color: AppColors.fadedText.withOpacity(0.2), width: 0.6),
          borderRadius: BorderRadius.circular(2.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Endings Found',
              style: GoogleFonts.cinzel(fontSize: 14.0, color: AppColors.fadedText, letterSpacing: 1.2),
            ),
            Text(
              '$_unlockedEndings / $_totalEndings',
              style: GoogleFonts.cinzel(fontSize: 16.0, fontWeight: FontWeight.bold, color: AppColors.whisperWhite),
            ),
          ],
        ),
      ),
    );
  }
}
