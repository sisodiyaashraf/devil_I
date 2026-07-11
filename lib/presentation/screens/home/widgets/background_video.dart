import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BackgroundVideo extends StatefulWidget {
  const BackgroundVideo({super.key});

  @override
  State<BackgroundVideo> createState() => _BackgroundVideoState();
}

class _BackgroundVideoState extends State<BackgroundVideo> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset("assets/videos/hell_bg.mp4");

    try {
      await _controller.initialize();

      // 1. Play immediately on start
      await _controller.setLooping(true);
      await _controller.setVolume(0);
      await _controller.play();

      // 2. Standard Loop Listener (Ensures no flicker on loop)
      _controller.addListener(() {
        if (_controller.value.position >= _controller.value.duration) {
          _controller.seekTo(Duration.zero);
          _controller.play();
        }
      });

      if (mounted) {
        setState(() => _isInitialized = true);
        // 3. Start the random refresh cycle (30-35s)
        _startRandomRefresh();
      }
    } catch (e) {
      debugPrint("HELL_VIDEO_ERROR: $e");
    }
  }

  // THE NEW LOGIC: Randomly "shifts" the hellscape every 30-35 seconds
  void _startRandomRefresh() {
    _refreshTimer?.cancel();

    // Generate random interval between 30 and 35
    int nextTick = 30 + Random().nextInt(6);

    _refreshTimer = Timer(Duration(seconds: nextTick), () {
      if (_isInitialized && mounted) {
        // Soft reset to beginning for a fresh loop start
        _controller.seekTo(Duration.zero);
        _controller.play();
        _startRandomRefresh(); // Recursive call for the next cycle
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _controller.removeListener(() {});
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: AnimatedOpacity(
        opacity: _isInitialized ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 1500),
        child: _isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : Container(color: Colors.black),
      ),
    );
  }
}
