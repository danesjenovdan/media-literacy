import 'dart:convert';
import 'package:archive/archive_io.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/screens/chat_select.dart';
import 'package:media_literacy_app/screens/chat.dart';

class AppColors {
  static const Color text = Color(0xFF333333);

  static const Color selectStoryBackground = Color(0xFFE8EEF3);
  static const Color selectStoryAppBarBackground = Color(0xFFFFE3D2);

  static const Color selectChatBackground = Color(0xFF9CD9D3);

  static const Color youtubeMessageBackground = Color(0xFFEA4335);

  static const Color chatMessageIncomingBackground = Color(0xFFE9EFFF);
  static const Color chatMessageOutgoingBackground = Color(0xFF1DD882);

  static const Color chatResponseBackground = Color(0xFFFFE3D2);
  static const Color chatResponseOptionBackground = Color(0xFF333333);

  static const Color storySelectCircle = Color(0xFF9CD9D3);
  static const Color chatSelectCircle = Color(0xFFFFE3D2);

  static const Color popupBackground = Color(0xFFF6675B);

  static const Color checkIncompleteBackground = Color(0xFF747474);
  static const Color checkCompleteBackground = Color(0xFF9DFFCE);
  static const Color checkIncomplete = Color(0xFFFFFFFF);
  static const Color checkComplete = Color(0xFF125933);
}

class AppTextStyles {
  static final TextStyle splashTitle = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
      decoration: TextDecoration.none,
    ),
  );

  static final TextStyle splashSubtitle = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.text,
      decoration: TextDecoration.none,
    ),
  );

  static final TextStyle appBarTitle = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
  );

  static final TextStyle appBarSmallTitle = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
  );

  static final TextStyle selectorCardTitle = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
  );

  static final TextStyle selectorCardCategory = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 14,
      color: AppColors.text,
    ),
  );

  static final TextStyle systemMessage = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic,
      color: AppColors.text,
    ),
  );

  static final TextStyle messageAuthor = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
  );

  static final TextStyle message = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 14,
      color: AppColors.text,
    ),
  );

  static final TextStyle youtubeMessage = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
  );

  static final TextStyle responseConfirmation = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  static final TextStyle responseOption = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
  );

  static final TextStyle popup = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
  );
}

class AppConstants {
  static const String title = 'Mislimetar';
  static const String subtitle = 'Medijska pismenost';
}

class AppState extends ChangeNotifier {
  // list of loaded stories by story id
  Map<String, Story> stories = {};

  Future<List<String>> _loadLocalStoryIDs() async {
    Map<String, dynamic> assets = jsonDecode(await rootBundle.loadString('AssetManifest.json'));
    var storyIdRegex = RegExp(r'stories/story-([0-9a-f]+)\.json$');
    return assets.keys.map((key) => storyIdRegex.firstMatch(key)?.group(1) ?? '').where((key) => key.isNotEmpty).toList();
  }

  Future<List<String>> _loadRemoteStoryIDs() async {
    var url = "https://api.locogames.live/v1/team/643599b047eb967304f10aff/locale/sr/stories/translations";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> stories = jsonData["data"] ?? [];
      return stories.map((story) => story["_id"] as String).toList();
    } else {
      throw Exception("Failed to load team stories");
    }
  }

  Future<Story> _loadLocalStory(String storyId) async {
    String data = await rootBundle.loadString("assets/stories/story-$storyId.json");
    return Story.fromJson(jsonDecode(data));
  }

  Future<Story> _loadRemoteStory(String storyId) async {
    var url = "https://api.locogames.live/v1/story/$storyId/bundleInfo";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var zipResponse = await http.get(Uri.parse(jsonData["data"]["bundle"]["url"]));
      if (zipResponse.statusCode == 200) {
        var archive = ZipDecoder().decodeBytes(zipResponse.bodyBytes);
        for (var file in archive) {
          if (file.isFile && file.name.endsWith(".json")) {
            return Story.fromJson(jsonDecode(utf8.decode(file.content)));
          }
        }
        throw Exception("Failed to find story json in zip");
      } else {
        throw Exception("Failed to load story zip");
      }
    } else {
      throw Exception("Failed to load story bundle");
    }
  }

  Future _loadLocalStories() async {
    stories = {};
    var storyIds = await _loadLocalStoryIDs();
    for (var storyId in storyIds) {
      stories[storyId] = await _loadLocalStory(storyId);
    }
  }

  Future _loadRemoteStories() async {
    stories = {};
    var storyIds = await _loadRemoteStoryIDs();
    for (var storyId in storyIds) {
      stories[storyId] = await _loadRemoteStory(storyId);
    }
  }

  void _sortStories() {
    stories = Map.fromEntries(stories.entries.toList()..sort((e1, e2) => e1.value.name.compareTo(e2.value.name)));
  }

  final bool _shouldLoadLocalStories = false;

  Future<bool> initAppState() async {
    if (_shouldLoadLocalStories) {
      await _loadLocalStories();
    } else {
      await _loadRemoteStories();
    }
    _sortStories();
    return true;
  }

  String? selectedStoryId;
  Story? selectedStory;

  void selectStory(String storyId, BuildContext context) {
    selectedStoryId = storyId;
    selectedStory = stories[storyId];
    notifyListeners();

    for (var actor in selectedStory!.actors) {
      precacheImage(NetworkImageWithRetry(actor.avatar.miniThumbUrl), context);
      precacheImage(NetworkImageWithRetry(actor.avatar.url), context);
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatSelectScreen(),
      ),
    );
  }

  String? selectedChatId;
  Chat? selectedChat;

  void selectChat(String chatId, BuildContext context) {
    selectedChatId = chatId;
    selectedChat = selectedStory!.chats.firstWhere((chat) => chat.id == chatId);
    notifyListeners();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );
  }

  // list of already displayed messages for each chat id
  Map<String, DisplayedState> displayedChatMessages = {};

  DisplayedState getDisplayedState() {
    return displayedChatMessages.putIfAbsent(selectedChatId!, () => DisplayedState());
  }

  void addDisplayedMessage(DisplayedMessage displayedMessage) {
    var state = getDisplayedState();
    state.messageList.add(displayedMessage);
    if (displayedMessage.type == DisplayedMessageType.message) {
      if (state.threadStack.isEmpty || displayedMessage.threadId != state.threadStack.last) {
        state.threadStack.add(displayedMessage.threadId);
      }
    }
    notifyListeners();
  }

  void setCompleted() {
    var state = getDisplayedState();
    if (state.completed) {
      return;
    }
    state.completed = true;
    notifyListeners();
  }

  bool isChatCompleted(chatId) {
    var state = displayedChatMessages[chatId];
    return state?.completed ?? false;
  }

  void resetDisplayedMessages() {
    displayedChatMessages = {};
    notifyListeners();
  }
}

class DisplayedState {
  List<DisplayedMessage> messageList = [];
  List<String> threadStack = [];
  bool completed = false;
}
