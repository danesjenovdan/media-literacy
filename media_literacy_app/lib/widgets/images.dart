import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:transparent_image/transparent_image.dart';

class RemoteProgressiveImageLoader extends StatelessWidget {
  final RemoteImageDefinition image;
  final BoxFit fit;
  final bool openViewerOnTap;

  const RemoteProgressiveImageLoader(this.image, {Key? key, this.fit = BoxFit.fill, this.openViewerOnTap = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget? imageWidget;
    ImageProvider? fullSizeImageProvider;

    // try loading image from bundle first
    if (image.story?.bundleFolder != null) {
      String bundlePath = image.story!.bundleFolder.path;
      File imageFile = File("$bundlePath/${image.fileName}");
      if (imageFile.existsSync()) {
        imageWidget = Image.file(
          imageFile,
          width: image.width.toDouble(),
          height: image.height.toDouble(),
        );
        fullSizeImageProvider = (imageWidget as Image).image;
      }
    }

    // if image not found in bundle, load from network
    if (imageWidget == null && fullSizeImageProvider == null) {
      var thumbImageProvider = NetworkImageWithRetry(image.miniThumbUrl);
      fullSizeImageProvider = NetworkImageWithRetry(image.url);
      imageWidget = ProgressiveImage.custom(
        placeholderBuilder: (context) {
          return const Center(child: CircularProgressIndicator());
        },
        thumbnail: thumbImageProvider,
        image: fullSizeImageProvider,
        width: image.width.toDouble(),
        height: image.height.toDouble(),
      );
    }

    imageWidget = imageWidget!.fittedBox(fit: fit).clipRect();

    if (openViewerOnTap) {
      imageWidget = imageWidget.gestures(onTap: () {
        showImageViewer(
          context,
          fullSizeImageProvider!,
          doubleTapZoomable: true,
        );
      });
    }

    return imageWidget;
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
    ).fittedBox(fit: fit).clipRect();
  }
}
