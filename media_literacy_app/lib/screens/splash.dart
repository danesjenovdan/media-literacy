import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/screens/story_select.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return FutureBuilder(
      future: appState.initAppState(),
      builder: (context, snapshot) {
        Widget widget = Container();
        if (snapshot.hasError) {
          widget = const Text('Error :(');
        } else if (!snapshot.hasData) {
          widget = const CircularProgressIndicator();
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
          color: Theme.of(context).primaryColorLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [widget],
          ),
        );
      },
    );
  }
}
