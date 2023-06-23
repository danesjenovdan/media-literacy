import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final bool checkComplete;

  const SelectorCard({
    super.key,
    required this.title,
    required this.categoryColor,
    required this.categoryName,
    this.image,
    this.showCheck = false,
    this.checkComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            image != null
                ? AspectRatio(
                    aspectRatio: 2,
                    child: RemoteProgressiveImageLoader(
                      image!,
                      fit: BoxFit.cover,
                    ))
                : const SizedBox.shrink(),
            Text(
              title,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ).padding(all: 8),
            Row(
              children: [
                const SizedBox.square(dimension: 26).backgroundColor(categoryColor).clipOval(),
                Text(
                  categoryName,
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.text,
                    ),
                  ),
                ).padding(left: 8),
              ],
            ).padding(all: 8, top: 0),
          ],
        ).backgroundColor(Colors.white).clipRRect(all: 12).padding(bottom: 12),
        showCheck ? Check(complete: checkComplete).positioned(top: 8, right: 8) : const SizedBox.shrink(),
      ],
    );
  }
}

class Check extends StatelessWidget {
  final bool complete;

  const Check({super.key, required this.complete});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 26,
      child: Icon(
        Icons.check,
        color: complete ? AppColors.checkComplete : AppColors.checkIncomplete,
        size: 18,
      ),
    ).backgroundColor(complete ? AppColors.checkCompleteBackground : AppColors.checkIncompleteBackground).clipOval();
  }
}
