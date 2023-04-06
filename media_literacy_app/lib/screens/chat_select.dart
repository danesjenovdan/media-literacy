import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:provider/provider.dart';

class ChatSelectScreen extends StatelessWidget {
  const ChatSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    List<Widget> content = [
      Container(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(
          'Select chapter for story "${appState.selectedStoryId}":',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
    ];
    if (appState.selectedStory == null) {
      content += [const CircularProgressIndicator()];
    } else {
      Story story = appState.selectedStory!;
      content += [
        ...story.chats.map(
          (chat) => Container(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () {
                appState.selectChat(chat.id, context);
              },
              child: Text(
                chat.title,
                style: TextStyle(
                  fontWeight: chat.isMainChat ? FontWeight.bold : FontWeight.normal,
                  fontSize: 24,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
        )
      ];
    }

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: content,
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
