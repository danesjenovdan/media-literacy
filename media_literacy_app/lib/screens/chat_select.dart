import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/footer_logos.dart';
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
        width: double.infinity,
        color: AppColors.selectStoryBackground,
        child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: constraints.copyWith(
                minHeight: constraints.maxHeight,
                maxHeight: double.infinity,
              ),
              child: SafeArea(
                child: IntrinsicHeight(
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
                        ).padding(horizontal: 16).gestures(onTap: () {
                          if (!appState.isChatLocked(chat.id)) {
                            appState.selectChat(chat.id, context);
                          }
                        }),
                      ),
                      const FooterLogos().padding(top: 4).alignment(Alignment.bottomCenter).expanded(),
                    ],
                  ).padding(top: 28),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
