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
    return IconButton.filledTonal(
      constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
      padding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
      style: IconButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: isMuted ? AppColors.staticGray : AppColors.terminalGreen,
      ),
      onPressed: () async {
        await widget.audioService.toggleMute();
        setState(() {});
      },
      icon: Icon(
        isMuted ? Icons.volume_off : Icons.volume_up,
        size: 16.0,
      ),
    );
  }
}
