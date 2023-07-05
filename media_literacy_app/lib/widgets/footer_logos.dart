import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:styled_widget/styled_widget.dart';

class FooterLogos extends StatelessWidget {
  const FooterLogos({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.footerBackground,
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 20),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/eu-flag.png', width: 345 / 3.5, height: 233 / 3.5).padding(right: 10),
                const Text(
                  'Ovu publikaciju je financirala/sufinancirala Evropska unija. Sadržaj publikacije isključiva je '
                  'odgovornost U.G. Zašto ne/Centra za obrazovne inicijative Step by Step i ne odražavaju nužno stavove Evropske unije.',
                ).fontSize(10).expanded(),
              ],
            ).padding(bottom: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo-zastone.png', width: 127, height: 24).padding(right: 16),
                Image.asset('assets/images/logo-stepbystep.png', width: 31, height: 36),
              ],
            ),
          ],
        ),
      ).safeArea(top: false, left: false, right: false),
    ).clipRRect(topLeft: 20, topRight: 20).boxShadow(color: const Color(0x1F000000), blurRadius: 16);
  }
}
