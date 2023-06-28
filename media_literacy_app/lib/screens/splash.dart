import 'package:flutter/material.dart';
import 'package:media_literacy_app/screens/story_select.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    )..repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return FutureBuilder(
      future: appState.initAppState(),
      builder: (context, snapshot) {
        var showSpinner = !snapshot.hasData && !snapshot.hasError;
        var showError = snapshot.hasError;

        List<Widget> widgets = [];

        if (showSpinner) {
          widgets.add(
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Image.asset('assets/images/spinner.png', width: 96, height: 96),
            ),
          );
        } else if (!showError) {
          widgets.add(
            const SizedBox.square(dimension: 96),
          );
        }

        widgets.addAll([
          Image.asset('assets/images/logo.png', width: 215, height: 215).padding(bottom: 12),
          const Text(AppConstants.title).textStyle(AppTextStyles.splashTitle),
          const Text(AppConstants.subtitle).textStyle(AppTextStyles.splashSubtitle),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo-zastone.png', width: 127, height: 24).padding(right: 16),
              Image.asset('assets/images/logo-stepbystep.png', width: 31, height: 36),
            ],
          ).padding(top: 85),
        ]);

        if (showError) {
          var errorString = snapshot.error.toString();
          widgets.add(
            Text('Error: $errorString').fontSize(12).textAlignment(TextAlign.center).padding(top: 16),
          );
        }

        if (!showError && !showSpinner) {
          Future.microtask(
            () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const StorySelectScreen(),
              ),
            ),
          );
        }

        return Stack(
          fit: StackFit.passthrough,
          children: [
            Positioned.fill(
              child: Opacity(
                opacity: 0.06,
                child: Image.asset('assets/images/grid-bg.png', scale: 2, repeat: ImageRepeat.repeat),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgets,
            ).padding(all: 16),
          ],
        ).backgroundColor(Colors.white);
      },
    );
  }
}
