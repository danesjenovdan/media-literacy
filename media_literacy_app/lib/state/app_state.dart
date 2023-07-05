import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/screens/about_screen.dart';
import 'package:media_literacy_app/screens/chat_select.dart';
import 'package:media_literacy_app/screens/chat.dart';
import 'package:media_literacy_app/screens/splash.dart';
import 'package:media_literacy_app/state/app_storage.dart';
import 'package:media_literacy_app/widgets/custom_dialog.dart';

class AppSystemSettings {
  static Future<void> setSystemChromeDefault() async {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static Future<void> setSystemChromeFullscreen() async {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black.withAlpha(170),
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }
}

class AppColors {
  static const Color appBarText = Color(0xFF191D21);
  static const Color text = Color(0xFF333333);
  static const Color categoryText = Color(0xFF656F77);

  static const Color selectStoryBackground = Color(0xFFFFFFFF);
  static const Color selectStoryAppBarBackground = Color(0xFFD0F1EB);

  static const Color chatBackground = Color(0xFFFFFFFF);

  static const Color youtubeMessageBackground = Color(0xFFECDDFF);
  static const Color youtubePlayButton = Color(0xFFEA4335);

  static const Color chatMessageIncomingBackground = Color(0xFFE9EFFF);
  static const Color chatMessageOutgoingBackground = Color(0xFF1DD882);

  static const Color chatResponseOptionBackground = Color(0xFF333333);
  static const Color chatResponseOptionBackgroundDown = Color(0xFFFFE3D2);

  static const Color storySelectCircle = Color(0xFF9CD9D3);
  static const Color chatSelectCircle = Color(0xFFFFE3D2);

  static const Color popupBackground = Color(0xFFF6675B);

  static const Color checkIncompleteBackground = Color(0xFF3F3F3F);
  static const Color checkCompleteBackground = Color(0xFF9DFFCE);
  static const Color checkIncomplete = Color(0xFF000000);
  static const Color checkComplete = Color(0xFF125933);

  static const Color resetButtonBackground = Color(0xFF789AED);

  static const Color footerBackground = Color(0xFFECDDFF);
}

class AppTextStyles {
  static final TextStyle splashTitle = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w800,
      color: AppColors.text,
      decoration: TextDecoration.none,
    ),
  );

  static final TextStyle splashSubtitle = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.text,
      decoration: TextDecoration.none,
    ),
  );

  static final TextStyle appBarTitle = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: AppColors.appBarText,
    ),
  );

  static final TextStyle appBarSmallTitle = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w800,
      color: AppColors.appBarText,
    ),
  );

  static final TextStyle selectorCardTitle = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w800,
      color: AppColors.text,
    ),
  );

  static final TextStyle selectorCardCategory = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 14,
      color: AppColors.categoryText,
    ),
  );

  static final TextStyle systemMessage = GoogleFonts.nunito(
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
      fontWeight: FontWeight.w700,
      color: AppColors.text,
    ),
  );

  static final TextStyle message = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 18,
      color: AppColors.text,
    ),
  );

  static final TextStyle youtubeMessage = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 16,
      color: AppColors.text,
    ),
  );

  static final TextStyle responseConfirmation = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static final TextStyle responseConfirmationDown = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.text,
    ),
  );

  static final TextStyle responseOption = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static final TextStyle responseOptionDown = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.text,
    ),
  );

  static final TextStyle popup = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.appBarText,
    ),
  );

  static final TextStyle popupButton = GoogleFonts.nunito(
    textStyle: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
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
  // list of already displayed messages for each chat id
  Map<String, DisplayedState> displayedChatMessages = {};

  String? selectedStoryId;
  Story? selectedStory;

  String? selectedChatId;
  Chat? selectedChat;

  Future<bool> initAppState() async {
    AppStorage appStorage = AppStorage();
    await appStorage.init();

    stories = appStorage.stories;
    stories = Map.fromEntries(stories.entries.toList()..sort((e1, e2) => e1.value.name.compareTo(e2.value.name)));

    displayedChatMessages = appStorage.displayedChatMessages;

    return true;
  }

  Future<bool> resetAppState(BuildContext context) async {
    var navigator = Navigator.of(context);

    var value = await showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.text.withAlpha(200),
      builder: (context) => const CustomResetDialog(
        text: "Completely reset progress and try downloading updated modules?",
      ),
    );
    if (value is! bool || !value) {
      return false;
    }

    stories = {};
    displayedChatMessages = {};
    selectedStoryId = null;
    selectedStory = null;
    selectedChatId = null;
    selectedChat = null;

    AppStorage appStorage = AppStorage();
    await appStorage.clear();

    navigator.popUntil((route) => route.isFirst);
    navigator.pushReplacement(
      MaterialPageRoute(
        settings: const RouteSettings(name: 'SplashScreen'),
        builder: (context) => const SplashScreen(),
      ),
    );

    return true;
  }

  void resetChatState() {
    bool wasUnlocked = displayedChatMessages[selectedChatId!]?.unlocked ?? false;
    displayedChatMessages[selectedChatId!] = DisplayedState(unlocked: wasUnlocked);
    saveDisplayedState();
    notifyListeners();
  }

  void resetStoryState() {
    for (var chat in selectedStory!.chats) {
      displayedChatMessages[chat.id] = DisplayedState();
    }
    saveDisplayedState();
    notifyListeners();
  }

  void selectStory(String storyId, BuildContext context) {
    selectedStoryId = storyId;
    selectedStory = stories[storyId];
    notifyListeners();

    var navigator = Navigator.of(context);

    // if this is the about story, show the about screen
    if (storyId == "6495a84511622f51d8e2abbf") {
      navigator.push(
        MaterialPageRoute(
          settings: const RouteSettings(name: 'AboutScreen'),
          builder: (context) => const AboutScreen(),
        ),
      );
    } else {
      navigator.push(
        MaterialPageRoute(
          settings: const RouteSettings(name: 'ChatSelectScreen'),
          builder: (context) => const ChatSelectScreen(),
        ),
      );
    }
  }

  void selectChat(String chatId, BuildContext context) {
    selectedChatId = chatId;
    selectedChat = selectedStory!.chats.firstWhere((chat) => chat.id == chatId);
    notifyListeners();

    Navigator.of(context).push(
      MaterialPageRoute(
        settings: const RouteSettings(name: 'ChatScreen'),
        builder: (context) => const ChatScreen(),
      ),
    );
  }

  DisplayedState getDisplayedChatState() {
    return displayedChatMessages.putIfAbsent(selectedChatId!, () => DisplayedState());
  }

  void addDisplayedMessage(DisplayedMessage displayedMessage) {
    var chatState = getDisplayedChatState();
    chatState.messageList.add(displayedMessage);
    if (displayedMessage.type == DisplayedMessageType.message) {
      if (chatState.threadStack.isEmpty || displayedMessage.threadId != chatState.threadStack.last) {
        chatState.threadStack.add(displayedMessage.threadId);
      }
    }
    saveDisplayedState();
    notifyListeners();
  }

  void setChatCompleted() {
    var chatState = getDisplayedChatState();
    if (chatState.completed) {
      return;
    }
    chatState.completed = true;
    saveDisplayedState();
    notifyListeners();
  }

  bool isChatCompleted(chatId) {
    var state = displayedChatMessages[chatId];
    return state?.completed ?? false;
  }

  void setChatUnlocked(chatId) {
    var state = displayedChatMessages.putIfAbsent(chatId, () => DisplayedState());
    if (state.unlocked) {
      return;
    }
    state.unlocked = true;
    saveDisplayedState();
    notifyListeners();
  }

  bool isChatLocked(chatId) {
    Chat? chat = selectedStory?.chats.firstWhereOrNull((chat) => chat.id == chatId);
    bool chatLocked = chat?.isLocked ?? false;
    var state = displayedChatMessages[chatId];
    bool chatStateUnlocked = state?.unlocked ?? false;
    return chatLocked && !chatStateUnlocked;
  }

  void saveDisplayedState() async {
    AppStorage appStorage = AppStorage();
    await appStorage.saveDisplayedState(displayedChatMessages);
  }
}
