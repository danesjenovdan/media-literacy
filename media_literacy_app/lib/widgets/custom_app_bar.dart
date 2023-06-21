import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:styled_widget/styled_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color backgroundColor;
  final Color appBarColor;
  final Widget child;

  const CustomAppBar({
    super.key,
    required this.height,
    required this.backgroundColor,
    required this.appBarColor,
    required this.child,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: SafeArea(
        child: Container(
          color: backgroundColor,
          child: Container(
            height: preferredSize.height,
            color: appBarColor,
            alignment: Alignment.centerLeft,
            child: child,
          ).clipRRect(bottomLeft: 40),
        ),
      ),
    );
  }
}

CustomAppBar createAppBar(BuildContext context, String title) {
  return CustomAppBar(
    height: 80,
    backgroundColor: AppColors.selectStoryBackground,
    appBarColor: AppColors.selectStoryAppBarBackground,
    child: Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ).padding(left: 4),
        ),
      ],
    ).padding(left: 16),
  );
}

CustomAppBar createAppBarWithBackButton(BuildContext context, String title) {
  return CustomAppBar(
    height: 80,
    backgroundColor: AppColors.selectChatBackground,
    appBarColor: AppColors.selectStoryAppBarBackground,
    child: Row(
      children: [
        IconButton(
          icon: const SizedBox.square(
            dimension: 32,
            child: Icon(Icons.arrow_back),
          ).backgroundColor(AppColors.text).clipOval(),
          color: Colors.white,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
              ),
            ),
          ).padding(left: 4),
        ),
      ],
    ).padding(left: 8), // IconButton already has an implicit padding of 8
  );
}
