import 'package:flutter/material.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LazyYoutubePlayer extends StatefulWidget {
  final String youtubeId;
  final String thumbUrl;

  const LazyYoutubePlayer(this.youtubeId, this.thumbUrl, {super.key});

  @override
  State<LazyYoutubePlayer> createState() => _LazyYoutubePlayerState();
}

class _LazyYoutubePlayerState extends State<LazyYoutubePlayer> {
  bool showThumbnail = true;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.youtubeId,
      flags: const YoutubePlayerFlags(mute: false, autoPlay: true),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (showThumbnail) {
      return Stack(
        fit: StackFit.expand,
        children: [
          FadeInImageLoader(widget.thumbUrl),
          const Center(
            child: Icon(
              Icons.play_arrow,
              color: Colors.white,
              size: 100,
              shadows: [Shadow(color: Colors.black, blurRadius: 25)],
            ),
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
      controller: _controller!,
      showVideoProgressIndicator: true,
    );
  }
}