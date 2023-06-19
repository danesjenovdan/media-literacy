import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/selector_cards.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatSelectScreen extends StatelessWidget {
  const ChatSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    Story story = appState.selectedStory!;
    String title = story.name;

    return Scaffold(
      appBar: CustomAppBar(
        height: 80,
        backgroundColor: AppColors.selectChatBackground,
        appBarColor: AppColors.selectStoryAppBarBackground,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.maybePop(context);
              },
              icon: const SizedBox.square(
                dimension: 32,
                child: Icon(Icons.arrow_back),
              ).backgroundColor(AppColors.text).clipOval(),
              color: Colors.white,
            ),
            Text(
              title,
              style: GoogleFonts.quicksand(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text,
                ),
              ),
            ).padding(left: 8),
          ],
        ).padding(left: 16).alignment(Alignment.centerLeft),
      ),
      body: Container(
        color: AppColors.selectChatBackground,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
              child: Column(
                children: [
                  ...story.chats.map(
                    (chat) => SelectorCard(
                      title: chat.title,
                      categoryColor: chat.isMainChat ? Colors.green : Colors.red,
                      categoryName: chat.id,
                      image: chat.poster,
                    ).gestures(onTap: () {
                      appState.selectChat(chat.id, context);
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
