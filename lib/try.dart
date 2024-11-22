import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoApp());

class VideoApp extends StatefulWidget {
  const VideoApp({super.key});

  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    // Provide a streaming-compatible URL.
    _controller = VideoPlayerController.network(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4', // Example URL
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true), // Streaming-optimized
    )
      ..addListener(_onControllerUpdate)
      ..initialize().then((_) {
        setState(() {}); // Refresh to show the player.
      });
  }

  // Listener to handle updates
  void _onControllerUpdate() {
    setState(() {});
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours != "00" ? "$hours:$minutes:$seconds" : "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Streaming Video Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text("Streaming Video Player")),
        body: Column(
          children: [
            if (_controller.value.isInitialized)
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            else
              const Center(child: CircularProgressIndicator()),

            if (_controller.value.isInitialized)
              Column(
                children: [
                  Slider(
                    value: _controller.value.position.inSeconds.toDouble(),
                    max: _controller.value.duration.inSeconds.toDouble(),
                    onChanged: (value) {
                      _controller.seekTo(Duration(seconds: value.toInt()));
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDuration(_controller.value.position)),
                      Text(_formatDuration(_controller.value.duration)),
                    ],
                  ),
                ],
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _controller.value.isPlaying ? _controller.pause() : _controller.play();
            });
          },
          child: Icon(
            _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }
}
