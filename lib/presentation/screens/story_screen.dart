import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../widgets/biometric_hud.dart';
import '../widgets/choice_button.dart';
import '../widgets/glitch_overlay.dart';
import '../widgets/jumpscare_overlay.dart';
import '../widgets/mute_toggle_button.dart';
import '../widgets/qte/camera_surveillance_widget.dart';
import '../widgets/qte/frequency_tuner_widget.dart';
import '../widgets/qte/pulse_control_widget.dart';
import '../widgets/qte/terminal_override_widget.dart';
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
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.redAccent,
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
      horizontal: isTablet ? 48.0 : 20.0,
      vertical: isTablet ? 40.0 : 16.0,
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: JumpscareOverlay(
        key: ValueKey('jumpscare_${node.id}'),
        trigger: node.jumpscareTrigger,
        hapticsService: provider.hapticsService,
        child: GlitchOverlay(
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
                      const SizedBox(height: 20.0),
                      BiometricHud(
                        corruptionLevel: provider.corruptionLevel,
                        threatLevel: node.threatLevel ?? 'ELEVATED',
                      ),
                      const SizedBox(height: 16.0),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
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
                                            if (mounted) {
                                              setState(() => _textRevealed = true);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                if (node.qteType != null)
                                  _buildQteWidget(context, provider, node)
                                else if (_textRevealed) ...[
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
                  top: 4.0,
                  right: 4.0,
                  child: MuteToggleButton(
                    audioService: provider.audioService,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQteWidget(
      BuildContext context, StoryProvider provider, dynamic node) {
    final successNode = node.qteSuccessNodeId ?? 'start';
    final failNode = node.qteFailNodeId ?? 'jumpscare_breach';

    switch (node.qteType) {
      case 'frequency_tuner':
        return FrequencyTunerWidget(
          key: ValueKey('freq_${node.id}'),
          onSuccess: () => provider.goToNode(successNode),
          onFail: () => provider.goToNode(failNode),
        );
      case 'code_override':
        return TerminalOverrideWidget(
          key: ValueKey('code_${node.id}'),
          onSuccess: () => provider.goToNode(successNode),
          onFail: () => provider.goToNode(failNode),
        );
      case 'camera_check':
        return CameraSurveillanceWidget(
          key: ValueKey('cam_${node.id}'),
          onSuccess: () => provider.goToNode(successNode),
          onFail: () => provider.goToNode(failNode),
        );
      case 'pulse_hold':
      default:
        return PulseControlWidget(
          key: ValueKey('pulse_${node.id}'),
          onSuccess: () => provider.goToNode(successNode),
          onFail: () => provider.goToNode(failNode),
        );
    }
  }

  Widget _buildDeadEndView(
      BuildContext context, StoryProvider provider, bool isTablet) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TERMINAL LINK LOST',
            style: GoogleFonts.shareTechMono(
              fontSize: isTablet ? 30.0 : 22.0,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
              letterSpacing: 4.0,
            ),
          ),
          const SizedBox(height: 16.0),
          ChoiceButton(
            label: 'REBOOT CONTAINMENT SYSTEM',
            index: 0,
            onTap: () => provider.reset(),
          ),
        ],
      ),
    );
  }
}
