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
        List<Widget> widgets = [
          Image.asset('assets/images/logo.png', width: 111, height: 111).padding(bottom: 16),
          const Text(AppConstants.title).textStyle(AppTextStyles.splashTitle),
          const Text(AppConstants.subtitle).textStyle(AppTextStyles.splashSubtitle).padding(top: 8),
        ];
        if (snapshot.hasError) {
          var errorString = snapshot.error.toString();
          widgets.add(
            Text('Error: $errorString').fontSize(12).textAlignment(TextAlign.center).padding(top: 16),
          );
        } else if (!snapshot.hasData) {
          widgets.add(
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Image.asset('assets/images/spinner.png', width: 96, height: 96),
            ),
          );
        } else {
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
                opacity: 0.1,
                child: Image.asset('assets/images/grid-bg.png', scale: 2, repeat: ImageRepeat.repeat),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgets,
            ).padding(all: 16),
          ],
        ).backgroundColor(Colors.white).safeArea().backgroundColor(Colors.black);
      },
    );
  }
}
