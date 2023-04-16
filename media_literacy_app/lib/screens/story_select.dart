import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:provider/provider.dart';

class StorySelectScreen extends StatelessWidget {
  const StorySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.appTitle),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: const Text(
                          'Select story:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      ...appState.stories.values.map(
                        (story) => story.id == '643599d047eb967304f115db'
                            ? Container(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    appState.selectStory(story.id, context);
                                  },
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                                  child: Text(story.name),
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    appState.selectStory(story.id, context);
                                  },
                                  child: Text(story.name),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
