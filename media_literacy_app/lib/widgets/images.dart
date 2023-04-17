import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:transparent_image/transparent_image.dart';

class RemoteProgressiveImageLoader extends StatelessWidget {
  final RemoteImageDefinition image;

  const RemoteProgressiveImageLoader(this.image, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProgressiveImage.custom(
      placeholderBuilder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
      thumbnail: NetworkImage(image.miniThumbUrl),
      image: NetworkImage(image.url),
      width: image.width.toDouble(),
      height: image.height.toDouble(),
    );
  }
}

class FadeInImageLoader extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;

  const FadeInImageLoader(this.imageUrl, {Key? key, this.fit = BoxFit.cover}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInImage.memoryNetwork(
      placeholder: kTransparentImage,
      image: imageUrl,
      fit: fit,
    );
  }
}
