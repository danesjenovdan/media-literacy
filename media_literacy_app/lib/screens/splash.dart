import 'package:flutter/material.dart';
import 'package:media_literacy_app/screens/story_select.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return FutureBuilder(
      future: appState.initAppState(),
      builder: (context, snapshot) {
        List<Widget> widgets = [
          Text(
            appState.appTitle,
            style: TextStyle(
              fontSize: 28,
              color: Theme.of(context).primaryColor,
              decoration: TextDecoration.none,
            ),
          ),
        ];
        if (snapshot.hasError) {
          widgets.add(const Text('Error loading :(').textAlignment(TextAlign.center));
        } else if (!snapshot.hasData) {
          widgets.add(const CircularProgressIndicator().padding(top: 28));
        } else {
          widgets.add(const CircularProgressIndicator(value: 1).padding(top: 28));
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
            children: widgets,
          ),
        );
      },
    );
  }
}
