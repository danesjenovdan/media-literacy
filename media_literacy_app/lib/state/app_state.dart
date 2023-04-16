import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/screens/chat_select.dart';
import 'package:media_literacy_app/screens/chat.dart';

class AppState extends ChangeNotifier {
  String appTitle = 'Media Literacy App';

  Map<String, Story> stories = {};

  // list of already displayed messages for each chat id
  Map<String, List<DisplayedMessage>> displayedChatMessages = {};

  Future<bool> initAppState() async {
    final Map<String, dynamic> assets = jsonDecode(await rootBundle.loadString('AssetManifest.json'));

    var storyIds = assets.keys.where((String key) => key.contains('stories/') && key.endsWith('.json')).map((key) {
      var regex = RegExp(r'story-([0-9a-f]+)\.json$');
      return regex.firstMatch(key)?.group(1) ?? '';
    }).where((key) => key.isNotEmpty);

    for (var storyId in storyIds) {
      String data = await rootBundle.loadString("assets/stories/story-$storyId.json");
      stories[storyId] = Story.fromJson(jsonDecode(data));
    }

    stories = Map.fromEntries(stories.entries.toList()..sort((e1, e2) => e1.value.name.compareTo(e2.value.name)));

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

    if (stories[storyId] == null) {
      String data = await DefaultAssetBundle.of(context).loadString("assets/stories/story-$storyId.json");
      stories[storyId] = Story.fromJson(jsonDecode(data));
    }

    selectedStory = stories[storyId];
    notifyListeners();
  }

  String? selectedChatId;
  Chat? selectedChat;

  selectChat(String chatId, BuildContext context) async {
    selectedChatId = chatId;
    selectedChat = selectedStory!.chats.firstWhere((chat) => chat.id == chatId);
    notifyListeners();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );
  }

  List<DisplayedMessage> getDisplayedMessages() {
    return displayedChatMessages.putIfAbsent(selectedChatId!, () => []);
  }

  addDisplayedMessage(DisplayedMessage displayedMessage) {
    var list = getDisplayedMessages();
    list.add(displayedMessage);
    notifyListeners();
  }
}
