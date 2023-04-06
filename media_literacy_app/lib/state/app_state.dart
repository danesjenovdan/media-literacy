import 'dart:convert';

import 'package:media_literacy_app/screens/chat.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/screens/chat_select.dart';
import 'package:flutter/services.dart';

class AppState extends ChangeNotifier {
  String appTitle = 'Media Literacy App';

  List<String> storyIds = [];

  Future<bool> initAppState() async {
    final Map<String, dynamic> assets = jsonDecode(await rootBundle.loadString('AssetManifest.json'));

    storyIds = assets.keys
        .where((String key) => key.contains('stories/') && key.endsWith('.json'))
        .map((key) {
          var regex = RegExp(r'story-([0-9a-f]+)\.json$');
          return regex.firstMatch(key)?.group(1) ?? '';
        })
        .where((key) => key.isNotEmpty)
        .toList();

    return true;
  }

  String? selectedStoryId;
  Story? selectedStory;

  selectStory(String storyId, BuildContext context) async {
    selectedStoryId = storyId;
    selectedStory = null;
    notifyListeners();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatSelectScreen(),
      ),
    );

    String data = await DefaultAssetBundle.of(context).loadString("assets/stories/story-$storyId.json");
    selectedStory = Story.fromJson(jsonDecode(data));
    notifyListeners();
  }

  String? selectedChatId;
  Chat? selectedChat;

  selectChat(String chatId, BuildContext context) async {
    selectedChatId = chatId;
    selectedChat = null;
    notifyListeners();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );

    selectedChat = selectedStory!.chats.firstWhere((chat) => chat.id == chatId);
    notifyListeners();
  }
}
