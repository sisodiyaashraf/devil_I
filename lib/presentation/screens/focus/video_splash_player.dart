import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSplashPlayer extends StatefulWidget {
  final String assetPath;
  final VoidCallback onComplete;

  const VideoSplashPlayer({
    super.key,
    required this.assetPath,
    required this.onComplete,
  });

  @override
  State<VideoSplashPlayer> createState() => _VideoSplashPlayerState();
}

class _VideoSplashPlayerState extends State<VideoSplashPlayer> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.assetPath)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration) {
        widget.onComplete(); // Navigate to FocusScreen
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : const CircularProgressIndicator(color: Colors.redAccent),
      ),
    );
  }
}
