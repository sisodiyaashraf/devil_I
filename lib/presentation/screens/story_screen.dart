import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../widgets/choice_button.dart';
import '../widgets/glitch_overlay.dart';
import '../widgets/mute_toggle_button.dart';
import '../widgets/revealing_text.dart';
import '../widgets/sanity_meter.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({super.key});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  String? _lastNodeId;
  bool _textRevealed = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoryProvider>();
    final node = provider.currentNode;

    if (provider.isLoading || node == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6E1414),
            strokeWidth: 2.0,
          ),
        ),
      );
    }

    if (node.id != _lastNodeId) {
      _lastNodeId = node.id;
      _textRevealed = false;
    }

    final media = MediaQuery.of(context);
    final isTablet = media.size.width > 600;
    final padding = EdgeInsets.symmetric(
      horizontal: isTablet ? 48.0 : 24.0,
      vertical: isTablet ? 40.0 : 24.0,
    );

    return Scaffold(
      body: GlitchOverlay(
        key: ValueKey(node.id),
        corruptionLevel: provider.corruptionLevel,
        forceTrigger: node.glitchTrigger,
        hapticsService: provider.hapticsService,
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: padding,
                child: Column(
                  children: [
                    const SizedBox(height: 28.0),
                    SanityMeter(corruptionLevel: provider.corruptionLevel),
                    const SizedBox(height: 16.0),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.easeOut,
                        child: Container(
                          key: ValueKey(node.id),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RevealingText(
                                        key: ValueKey(node.id),
                                        text: node.text,
                                        onComplete: () {
                                          if (mounted) setState(() => _textRevealed = true);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_textRevealed) ...[
                                const SizedBox(height: 24.0),
                                if (provider.isDeadEnd)
                                  _buildDeadEndView(context, provider, isTablet)
                                else
                                  ...node.choices.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final choice = entry.value;
                                    return ChoiceButton(
                                      label: choice.label,
                                      index: index,
                                      onTap: () => provider.selectChoice(choice),
                                    );
                                  }),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 8.0,
                right: 8.0,
                child: MuteToggleButton(
                  audioService: provider.audioService,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeadEndView(
      BuildContext context, StoryProvider provider, bool isTablet) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'THE END',
            style: GoogleFonts.cinzel(
              fontSize: isTablet ? 32.0 : 24.0,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6E1414),
              letterSpacing: 4.0,
            ),
          ),
          const SizedBox(height: 20.0),
          ChoiceButton(
            label: 'Start Over',
            index: 0,
            onTap: () => provider.reset(),
          ),
        ],
      ),
    );
  }
}
