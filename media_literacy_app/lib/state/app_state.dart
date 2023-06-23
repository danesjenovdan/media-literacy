import 'dart:convert';
// import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/screens/chat_select.dart';
import 'package:media_literacy_app/screens/chat.dart';
import 'package:flutter_image/flutter_image.dart';
import 'package:archive/archive_io.dart';
// import 'package:path_provider/path_provider.dart';

class AppColors {
  static Color text = const Color(0xFF333333);

  static Color selectStoryBackground = const Color(0xFFE8EEF3);
  static Color selectStoryAppBarBackground = const Color(0xFFFFE3D2);

  static Color selectChatBackground = const Color(0xFF9CD9D3);

  static Color youtubeMessageBackground = const Color(0xFFEA4335);

  static Color chatMessageIncomingBackground = const Color(0xFFE9EFFF);
  static Color chatMessageOutgoingBackground = const Color(0xFF1DD882);

  static Color chatResponseBackground = const Color(0xFFFFE3D2);
  static Color chatResponseOptionBackground = const Color(0xFF333333);
}

class AppTextStyles {
  static TextStyle messageAuthor = GoogleFonts.quicksand(
    textStyle: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: AppColors.text,
    ),
  );

  static TextStyle message = GoogleFonts.quicksand(
    textStyle: TextStyle(
      fontSize: 14,
      color: AppColors.text,
    ),
  );

  static TextStyle youtubeMessage = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
  );

  static TextStyle responseConfirmation = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  );

  static TextStyle responseOption = GoogleFonts.quicksand(
    textStyle: const TextStyle(
      fontSize: 12,
      color: Colors.white,
    ),
  );
}

class AppState extends ChangeNotifier {
  String appTitle = 'Mislimetar';
  String appSubtitle = 'Medijska pismenost';

  Map<String, Story> stories = {};

  // list of already displayed messages for each chat id
  Map<String, DisplayedState> displayedChatMessages = {};

  Future<bool> initAppState() async {
    final Map<String, dynamic> assets = jsonDecode(await rootBundle.loadString('AssetManifest.json'));

    var storyIds = assets.keys.where((String key) => key.contains('stories/') && key.endsWith('.json')).map((key) {
      var regex = RegExp(r'story-([0-9a-f]+)\.json$');
      return regex.firstMatch(key)?.group(1) ?? '';
    }).where((key) => key.isNotEmpty);

    // var tempDir = await getTemporaryDirectory();

    for (var storyId in storyIds) {
      if (storyId == "643599d047eb967304f115db") {
        var response = await http.get(Uri.parse("https://api.locogames.live/v1/story/$storyId/bundleInfo"));
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          var zipResponse = await http.get(Uri.parse(jsonData["data"]["bundle"]["url"]));
          if (zipResponse.statusCode == 200) {
            final archive = ZipDecoder().decodeBytes(zipResponse.bodyBytes);
            for (final file in archive) {
              if (file.isFile && file.name.endsWith(".json")) {
                // var storyFile = File("${tempDir.path}/story-${file.name}");
                // await storyFile.create(recursive: true);
                // storyFile.writeAsBytesSync(file.content);
                stories[storyId] = Story.fromJson(jsonDecode(utf8.decode(file.content)));
              }
            }
          } else {
            throw Exception("Failed to load zip");
          }
        } else {
          throw Exception("Failed to load story");
        }
      } else {
        String data = await rootBundle.loadString("assets/stories/story-$storyId.json");
        stories[storyId] = Story.fromJson(jsonDecode(data));
      }
    }

    stories = Map.fromEntries(stories.entries.toList()..sort((e1, e2) => e1.value.name.compareTo(e2.value.name)));

    return true;
  }

  String? selectedStoryId;
  Story? selectedStory;

  selectStory(String storyId, BuildContext context) {
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

  selectChat(String chatId, BuildContext context) {
    selectedChatId = chatId;
    selectedChat = selectedStory!.chats.firstWhere((chat) => chat.id == chatId);
    notifyListeners();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ChatScreen(),
      ),
    );
  }

  DisplayedState getDisplayedState() {
    return displayedChatMessages.putIfAbsent(selectedChatId!, () => DisplayedState());
  }

  addDisplayedMessage(DisplayedMessage displayedMessage) {
    var state = getDisplayedState();
    state.messageList.add(displayedMessage);
    if (displayedMessage.type == DisplayedMessageType.message) {
      if (state.threadStack.isEmpty || displayedMessage.threadId != state.threadStack.last) {
        state.threadStack.add(displayedMessage.threadId);
      }
    }
    notifyListeners();
  }

  void addPoints(int amount) {
    var state = getDisplayedState();
    state.points += amount;
    notifyListeners();
  }
}

class DisplayedState {
  int points = 0;
  List<DisplayedMessage> messageList = [];
  List<String> threadStack = [];
}
