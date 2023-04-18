import 'package:flutter_image/flutter_image.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:transparent_image/transparent_image.dart';

class RemoteProgressiveImageLoader extends StatelessWidget {
  final RemoteImageDefinition image;
  final BoxFit fit;

  const RemoteProgressiveImageLoader(this.image, {Key? key, this.fit = BoxFit.fill}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressiveImage.custom(
      placeholderBuilder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
      thumbnail: NetworkImageWithRetry(image.miniThumbUrl),
      image: NetworkImageWithRetry(image.url),
      width: image.width.toDouble(),
      height: image.height.toDouble(),
      fit: fit,
    );
  }
}

class FadeInImageLoader extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const FadeInImageLoader(this.imageUrl, {Key? key, this.fit = BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      placeholder: MemoryImage(kTransparentImage),
      image: NetworkImageWithRetry(imageUrl),
      fit: fit,
    );
  }
}
