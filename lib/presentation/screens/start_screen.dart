import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../widgets/start_option_button.dart';
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
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
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
                    StartOptionButton(
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
                    StartOptionButton(
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
                    StartOptionButton(
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
      ),
    );
  }
}
