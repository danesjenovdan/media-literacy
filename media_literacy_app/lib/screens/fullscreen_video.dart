import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class FullscreenVideoScreen extends StatefulWidget {
  final String youtubeId;
  final double startAt;

  const FullscreenVideoScreen({super.key, required this.youtubeId, required this.startAt});

  @override
  State<FullscreenVideoScreen> createState() => _FullscreenVideoScreenState();
}

class _FullscreenVideoScreenState extends State<FullscreenVideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    AppSystemSettings.setSystemChromeFullscreen();

    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.youtubeId,
      startSeconds: widget.startAt,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );
    _controller.setFullScreenListener((value) async {
      Navigator.of(context).pop();
    });

    super.initState();
  }

  @override
  dispose() {
    AppSystemSettings.setSystemChromeDefault();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayer(
      controller: _controller,
      backgroundColor: Colors.black,
      enableFullScreenOnVerticalDrag: false,
    );
  }
}
