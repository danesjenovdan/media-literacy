import 'package:flutter/material.dart';
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
            alignment: Alignment.center,
            child: child,
          ).clipRRect(bottomLeft: 40),
        ),
      ),
    );
  }
}
