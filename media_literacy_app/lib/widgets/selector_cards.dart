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

  const SelectorCard({super.key, required this.title, required this.categoryColor, required this.categoryName, this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
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
    ).backgroundColor(Colors.white).clipRRect(all: 12).padding(bottom: 12);
  }
}
