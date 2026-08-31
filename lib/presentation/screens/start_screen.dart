import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import 'story_screen.dart';
import '../../core/theme.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  bool _checkingSave = true;
  bool _hasSave = false;

  @override
  void initState() {
    super.initState();
    _checkProgress();
  }

  Future<void> _checkProgress() async {
    final provider = context.read<StoryProvider>();
    final hasSave = await provider.hasSavedProgress();
    if (mounted) {
      setState(() {
        _hasSave = hasSave;
        _checkingSave = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSave) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.bloodRed,
            strokeWidth: 2.0,
          ),
        ),
      );
    }

    final provider = context.read<StoryProvider>();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'WHISPERS',
                  style: GoogleFonts.cinzel(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.bloodRed,
                    letterSpacing: 8.0,
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
                const SizedBox(height: 80.0),
                if (_hasSave) ...[
                  _buildStartOption(
                    title: 'Continue',
                    subtitle: 'Something remembers where you left off',
                    onTap: () async {
                      await provider.continueFromSave();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const StoryScreen()),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 24.0),
                  _buildStartOption(
                    title: 'Start Over',
                    subtitle: 'Forget everything',
                    onTap: () async {
                      provider.reset();
                      await provider.loadStory();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const StoryScreen()),
                        );
                      }
                    },
                  ),
                ] else ...[
                  _buildStartOption(
                    title: 'Begin',
                    subtitle: 'Step into the dark',
                    onTap: () async {
                      await provider.loadStory();
                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const StoryScreen()),
                        );
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartOption({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
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
