import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_dialog.dart';
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

class ResetButton extends StatelessWidget {
  final void Function() onTap;

  const ResetButton({super.key, required this.onTap});

  void _onTap(BuildContext context) async {
    var value = await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.text.withAlpha(200),
      builder: (context) => const CustomResetDialog(),
    );
    if (value is bool && value) {
      onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 48,
      child: const Icon(Icons.replay_rounded, size: 36, color: Colors.white).rotate(angle: -45),
    ).backgroundColor(AppColors.resetButtonBackground).clipOval().gestures(onTap: () => _onTap(context));
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo.png', width: 48, height: 48);
  }
}

class BrainLogo extends StatelessWidget {
  const BrainLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.center,
      children: [
        const SizedBox.square(dimension: 53).backgroundColor(const Color(0xFF282A40)).clipOval(),
        Image.asset('assets/images/logo-brain.png', width: 58, height: 39),
      ],
    );
  }
}

CustomAppBar createAppBar(BuildContext context, String title) {
  return CustomAppBar(
    height: 80,
    appBarColor: AppColors.selectStoryAppBarBackground,
    child: Row(
      children: [
        Expanded(
          child: Text(title).textStyle(AppTextStyles.appBarTitle).padding(left: 2),
        ),
        const AppLogo(),
      ],
    ).padding(left: 16, right: 16),
  );
}

CustomAppBar createAppBarWithBackButton(
  BuildContext context,
  String title, {
  required Color color,
  Image? logo,
  void Function()? onLogoTap,
  void Function()? onLogoDoubleTap,
}) {
  Widget logoOrButton = onLogoTap != null ? ResetButton(onTap: onLogoTap) : logo ?? const AppLogo();
  logoOrButton = logoOrButton.constrained(width: 49, height: 49);
  if (onLogoDoubleTap != null) {
    logoOrButton = logoOrButton.gestures(onDoubleTap: onLogoDoubleTap);
  }

  return CustomAppBar(
    height: 80,
    appBarColor: color,
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
        logoOrButton,
      ],
    ).padding(left: 0, right: 16), // left padding is already in back button
  );
}
