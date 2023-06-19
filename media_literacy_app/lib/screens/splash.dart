import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          Image.asset(
            'assets/images/logo.png',
            width: 111,
            height: 111,
          ).padding(bottom: 16),
          Text(
            appState.appTitle,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.text,
                decoration: TextDecoration.none,
              ),
            ),
          ),
          Text(
            appState.appSubtitle,
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.text,
                decoration: TextDecoration.none,
              ),
            ),
          ).padding(top: 8),
        ];
        if (snapshot.hasError) {
          var errorString = snapshot.error.toString();
          widgets.add(Text('Error: $errorString').fontSize(12).textAlignment(TextAlign.center));
        } else if (!snapshot.hasData) {
          widgets.add(
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_controller),
              child: Image.asset(
                'assets/images/spinner.png',
                width: 96,
                height: 96,
              ),
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

        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: widgets,
          ),
        );
      },
    );
  }
}
