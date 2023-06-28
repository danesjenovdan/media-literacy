import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:styled_widget/styled_widget.dart';

class CustomDialog extends StatelessWidget {
  final String text;

  const CustomDialog({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/images/popup.png', width: 72, height: 72).padding(bottom: 16),
          Text(text).textStyle(AppTextStyles.popup).textAlignment(TextAlign.center),
        ],
      ).padding(vertical: 21, horizontal: 28).backgroundColor(AppColors.popupBackground).clipRRect(all: 12),
    );
  }
}
