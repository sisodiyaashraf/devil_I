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

class _MuteToggleButtonState extends State<MuteToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 140),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.78).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    await _scaleCtrl.forward();
    await widget.audioService.toggleMute();
    await _scaleCtrl.reverse();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isMuted = widget.audioService.isMuted;
    final color = isMuted ? AppColors.staticGray : AppColors.terminalGreen;

    return GestureDetector(
      onTap: _toggle,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 28.0,
          height: 28.0,
          decoration: BoxDecoration(
            color: isMuted
                ? Colors.transparent
                : AppColors.terminalGreen.withValues(alpha: 0.1),
            border: Border.all(
              color: color.withValues(alpha: 0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(2.0),
            boxShadow: isMuted ? [] : neonGlow(color, blur: 6),
          ),
          child: Icon(
            isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            size: 14.0,
            color: color,
          ),
        ),
      ),
    );
  }
}
