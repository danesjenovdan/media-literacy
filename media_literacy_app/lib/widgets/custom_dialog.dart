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

class CustomResetDialog extends StatelessWidget {
  final String text;

  const CustomResetDialog({super.key, this.text = "Ponovi modul?"});

  Widget _buildButton(String text) {
    return Text(text)
        .textStyle(AppTextStyles.popupButton)
        .textAlignment(TextAlign.center)
        .padding(vertical: 12, horizontal: 40)
        .backgroundColor(AppColors.chatResponseOptionBackground)
        .clipRRect(all: 8)
        .padding(bottom: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            fit: StackFit.passthrough,
            clipBehavior: Clip.none,
            children: [
              Image.asset('assets/images/popup.png', width: 102, height: 102),
              Positioned(
                left: (102 / 2) + (48 / 2),
                child: SizedBox.square(
                  dimension: 48,
                  child: const Icon(Icons.replay_rounded, size: 36, color: Colors.white).rotate(angle: -45),
                ).backgroundColor(AppColors.resetButtonBackground).clipOval(),
              ),
            ],
          ).padding(bottom: 16),
          Text(text).textStyle(AppTextStyles.popup).textAlignment(TextAlign.center),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton('Da').gestures(onTap: () => Navigator.of(context).pop(true)),
              _buildButton('Ne').gestures(onTap: () => Navigator.of(context).pop(false)),
            ],
          ).padding(top: 21),
        ],
      ).constrained(width: double.infinity).padding(top: 34, bottom: 21, horizontal: 16).backgroundColor(Colors.white).clipRRect(all: 12),
    );
  }
}
