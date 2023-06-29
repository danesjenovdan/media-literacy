import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_dialog.dart';
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
      color: appBarColor,
      child: Container(
        height: preferredSize.height,
        alignment: Alignment.centerLeft,
        child: child,
      ).safeArea(),
    ).clipRRect(bottomLeft: 20, bottomRight: 20).boxShadow(color: const Color(0x1F000000), blurRadius: 16);
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
          child: Text(title).textStyle(AppTextStyles.appBarTitle).padding(left: 2),
        ),
        SizedBox.square(
          dimension: 48,
          child: const Text("reset + update").textAlignment(TextAlign.center).alignment(Alignment.center),
        ).backgroundColor(const Color(0xFFFF00FF)).clipOval().gestures(onTap: () => appState.resetAppState(context)),
      ],
    ).padding(left: 16, right: 16),
  );
}

CustomAppBar createAppBarWithBackButton(BuildContext context, String title) {
  var appState = context.watch<AppState>();

  return CustomAppBar(
    height: 80,
    appBarColor: AppColors.selectStoryAppBarBackground,
    child: Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(
              dimension: 24,
              child: const Icon(
                Icons.arrow_back_ios,
                size: 14,
              ).padding(left: 5),
            )
                .decorated(
                  border: Border.all(color: AppColors.appBarText, width: 2),
                  borderRadius: BorderRadius.circular(100),
                )
                .padding(horizontal: 16)
                .padding(right: 16),
          ],
        )
            .backgroundColor(Colors.transparent) // this is needed to force the whole column to be tapable
            .gestures(onTap: () => Navigator.maybePop(context)),
        Expanded(
          child: Text(title).textStyle(AppTextStyles.appBarSmallTitle).padding(left: 4, right: 8),
        ),
        SizedBox.square(
          dimension: 48,
          child: const Icon(Icons.replay_rounded, size: 36, color: Colors.white).rotate(angle: -45),
        ).backgroundColor(AppColors.resetButtonBackground).clipOval().gestures(
          onTap: () async {
            var route = ModalRoute.of(context);
            String? routeName = route?.settings.name;
            if (routeName != null) {
              var value = await showDialog(
                context: context,
                barrierDismissible: true,
                barrierColor: AppColors.text.withAlpha(200),
                builder: (context) => const CustomResetDialog(),
              );
              if (value is bool && value) {
                if (routeName == "ChatScreen") {
                  appState.resetChatState();
                }
                if (routeName == "ChatSelectScreen") {
                  appState.resetStoryState();
                }
              }
            }
          },
        ),
      ],
    ).padding(left: 0, right: 16), // left padding is already in back button
  );
}
