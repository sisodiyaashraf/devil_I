import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

import '../../../../presentation/providers/devil_provider.dart';

class DevilEye extends StatefulWidget {
  const DevilEye({super.key});

  @override
  State<DevilEye> createState() => _DevilEyeState();
}

class _DevilEyeState extends State<DevilEye>
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  Timer? _randomTimer;

  @override
  void initState() {
    super.initState();

    // 1. Pulsing Glow (Stays active to show the eye is "alive")
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 10.0, end: 35.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _initEyeVideo();
    _startRandomTrigger();
  }

  Future<void> _initEyeVideo() async {
    try {
      _videoController = VideoPlayerController.asset(
        "assets/videos/devileye_shutter.mp4",
      );
      await _videoController!.initialize();

      // THE FIX: Disable automatic looping
      await _videoController!.setLooping(false);
      await _videoController!.setVolume(0);

      if (mounted) setState(() => _isVideoInitialized = true);
    } catch (e) {
      debugPrint("EYE VIDEO ERROR: $e");
    }
  }

  // THE FEATURE: Random play every 50-60 seconds
  void _startRandomTrigger() {
    _randomTimer?.cancel();
    // Generate a random delay between 50 and 60 seconds
    int nextTick = 50 + Random().nextInt(11);

    _randomTimer = Timer(Duration(seconds: nextTick), () {
      _playEyeSequence();
      _startRandomTrigger(); // Schedule the next random blink
    });
  }

  // THE ENGINE: Handles rewinding and playing
  void _playEyeSequence() {
    if (_isVideoInitialized && _videoController != null) {
      HapticFeedback.mediumImpact(); // Feel the blink
      _videoController!.seekTo(Duration.zero);
      _videoController!.play();
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _videoController?.dispose();
    _randomTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DevilProvider>();
    final realm = provider.currentRealm;
    final message = provider.devilMessage;

    Color accentColor = realm == "HEAVEN"
        ? Colors.amberAccent
        : (realm == "HELL" ? Colors.redAccent : Colors.grey[400]!);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          // THE FEATURE: Play on click
          onTap: _playEyeSequence,
          child: AnimatedBuilder(
            animation: _glowAnimation,
            builder: (context, child) {
              return Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor.withOpacity(0.5),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: _glowAnimation.value,
                      spreadRadius: _glowAnimation.value / 3,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _isVideoInitialized && _videoController != null
                      ? FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: _videoController!.value.size.width,
                            height: _videoController!.value.size.height,
                            child: VideoPlayer(_videoController!),
                          ),
                        )
                      : Container(color: Colors.black),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        Text(
          message.toUpperCase(),
          textAlign: TextAlign.center,
          style: GoogleFonts.cinzel(
            color: accentColor,
            fontSize: 13,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
