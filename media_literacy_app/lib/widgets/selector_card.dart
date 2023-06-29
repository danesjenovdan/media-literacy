import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:styled_widget/styled_widget.dart';

class SelectorCard extends StatelessWidget {
  final String title;
  final Color categoryColor;
  final String categoryName;
  final RemoteImageDefinition? image;
  final bool showCheck;
  final bool isComplete;
  final bool showLock;
  final bool isLocked;

  const SelectorCard({
    super.key,
    required this.title,
    required this.categoryColor,
    required this.categoryName,
    this.image,
    this.showCheck = false,
    this.isComplete = false,
    this.showLock = false,
    this.isLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image != null ? AspectRatio(aspectRatio: 2, child: RemoteProgressiveImageLoader(image!, fit: BoxFit.cover)) : const SizedBox.shrink(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                categoryName.isNotEmpty
                    ? Text(categoryName).textStyle(AppTextStyles.selectorCardCategory).padding(bottom: 4)
                    : const SizedBox.shrink(),
                Text(title).textStyle(AppTextStyles.selectorCardTitle),
              ],
            ).padding(all: 16),
          ],
        ).backgroundColor(Colors.white).clipRRect(all: 16),
        showLock ? Lock(locked: isLocked).positioned(top: 12, left: 12) : const SizedBox.shrink(),
        (showCheck && isComplete) ? const Check(complete: true).positioned(top: 12, right: 12) : const SizedBox.shrink(),
      ],
    ).width(double.infinity).boxShadow(color: const Color(0x1F000000), offset: const Offset(0, 8), blurRadius: 16).padding(bottom: 24);
  }
}

class Lock extends StatelessWidget {
  final bool locked;

  const Lock({super.key, required this.locked});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: Icon(locked ? Icons.lock_rounded : Icons.lock_open_rounded, color: AppColors.checkIncomplete, size: 18),
    ).backgroundColor(locked ? AppColors.checkIncompleteBackground : AppColors.checkCompleteBackground).clipOval();
  }
}

class Check extends StatelessWidget {
  final bool complete;

  const Check({super.key, required this.complete});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 28,
      child: Icon(Icons.check, color: complete ? AppColors.checkComplete : AppColors.checkIncomplete, size: 20),
    ).backgroundColor(complete ? AppColors.checkCompleteBackground : AppColors.checkIncompleteBackground).clipOval();
  }
}
