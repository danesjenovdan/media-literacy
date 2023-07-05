import 'package:flutter/material.dart';
import 'package:media_literacy_app/screens/fullscreen_video.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class LazyYoutubePlayer extends StatefulWidget {
  final String youtubeId;
  final String thumbUrl;

  const LazyYoutubePlayer(this.youtubeId, this.thumbUrl, {super.key});

  @override
  State<LazyYoutubePlayer> createState() => _LazyYoutubePlayerState();
}

class _LazyYoutubePlayerState extends State<LazyYoutubePlayer> {
  bool showThumbnail = true;
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.youtubeId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
      ),
    );
    _controller.setFullScreenListener((value) async {
      var navigator = Navigator.of(context);

      _controller.pauseVideo();
      double currentTime = await _controller.currentTime;

      navigator.push(
        MaterialPageRoute(
          settings: const RouteSettings(name: 'FullscreenVideoScreen'),
          builder: (context) => FullscreenVideoScreen(youtubeId: widget.youtubeId, startAt: currentTime),
        ),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (showThumbnail) {
      return Stack(
        fit: StackFit.expand,
        children: [
          FadeInImageLoader(widget.thumbUrl).clipRRect(bottomLeft: 12, bottomRight: 12),
          Center(
            child: const SizedBox.square(
              dimension: 48,
              child: Icon(Icons.play_arrow, color: Colors.white, size: 42),
            ).backgroundColor(AppColors.youtubePlayButton).clipOval(),
          ),
        ],
      ).gestures(
        onTap: () {
          setState(() {
            showThumbnail = false;
          });
        },
      );
    }
    return YoutubePlayer(
      controller: _controller,
      backgroundColor: Colors.black,
      enableFullScreenOnVerticalDrag: false,
    );
  }
}
