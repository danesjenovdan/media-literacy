import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/selector_card.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatSelectScreen extends StatelessWidget {
  const ChatSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();
    Story story = appState.selectedStory!;

    return Scaffold(
      appBar: createAppBarWithBackButton(context, story.name),
      extendBodyBehindAppBar: true,
      body: Container(
        color: AppColors.selectStoryBackground,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
              child: Column(
                children: [
                  ...story.chats.map(
                    (chat) => SelectorCard(
                      title: chat.title,
                      categoryColor: AppColors.chatSelectCircle,
                      categoryName: chat.description,
                      image: chat.poster,
                      showCheck: true,
                      isComplete: appState.isChatCompleted(chat.id),
                      showLock: true,
                      isLocked: appState.isChatLocked(chat.id),
                    ).gestures(onTap: () {
                      if (!appState.isChatLocked(chat.id)) {
                        appState.selectChat(chat.id, context);
                      }
                    }),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
