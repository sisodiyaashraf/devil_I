import 'package:flutter/material.dart';
import '../../core/services/audio_service.dart';
import '../../core/theme.dart';

class MuteToggleButton extends StatefulWidget {
  final AudioService audioService;

  const MuteToggleButton({
    super.key,
    required this.audioService,
  });

  @override
  State<MuteToggleButton> createState() => _MuteToggleButtonState();
}

class _MuteToggleButtonState extends State<MuteToggleButton> {
  @override
  Widget build(BuildContext context) {
    final isMuted = widget.audioService.isMuted;
    return IconButton(
      icon: Icon(
        isMuted ? Icons.volume_off : Icons.volume_up,
        color: isMuted ? AppColors.staticGray : AppColors.terminalGreen,
      ),
      tooltip: isMuted ? 'Unmute Audio' : 'Mute Audio',
      onPressed: () async {
        await widget.audioService.toggleMute();
        setState(() {});
      },
    );
  }
}
