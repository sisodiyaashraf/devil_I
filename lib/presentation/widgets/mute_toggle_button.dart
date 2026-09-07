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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        await widget.audioService.toggleMute();
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
        child: Icon(
          isMuted ? Icons.volume_off : Icons.volume_up,
          size: 16.0,
          color: isMuted ? AppColors.staticGray : AppColors.terminalGreen,
        ),
      ),
    );
  }
}
