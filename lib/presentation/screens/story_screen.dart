import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../widgets/choice_button.dart';
import '../widgets/revealing_text.dart';

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
      vertical: isTablet ? 60.0 : 36.0,
    );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: padding,
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
                          setState(() => _textRevealed = true);
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
