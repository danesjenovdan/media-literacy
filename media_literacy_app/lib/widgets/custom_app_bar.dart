import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color appBarColor;
  final Widget child;

  const CustomAppBar({
    super.key,
    required this.height,
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
          height: preferredSize.height,
          color: appBarColor,
          alignment: Alignment.centerLeft,
          child: child,
        ),
      ),
    ).clipRRect(bottomLeft: 40);
  }
}

CustomAppBar createAppBar(BuildContext context, String title) {
  var appState = context.watch<AppState>();

  return CustomAppBar(
    height: 80,
    appBarColor: AppColors.selectStoryAppBarBackground,
    child: Row(
      children: [
        Expanded(
          child: Text(title).textStyle(AppTextStyles.appBarTitle).padding(left: 4),
        ),
        ElevatedButton(
          onPressed: () {
            appState.resetDisplayedMessages();
          },
          child: const Text('reset progress'),
        ),
      ],
    ).padding(left: 16),
  );
}

CustomAppBar createAppBarWithBackButton(BuildContext context, String title) {
  return CustomAppBar(
    height: 80,
    appBarColor: AppColors.selectStoryAppBarBackground,
    child: Row(
      children: [
        IconButton(
          icon: const SizedBox.square(dimension: 32, child: Icon(Icons.arrow_back)).backgroundColor(AppColors.text).clipOval(),
          color: Colors.white,
          onPressed: () {
            Navigator.maybePop(context);
          },
        ),
        Expanded(
          child: Text(title).textStyle(AppTextStyles.appBarSmallTitle).padding(left: 4),
        ),
      ],
    ).padding(left: 8), // IconButton already has an implicit padding of 8
  );
}
