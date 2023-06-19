import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/selector_cards.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:styled_widget/styled_widget.dart';

class StorySelectScreen extends StatelessWidget {
  const StorySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: CustomAppBar(
        height: 80,
        backgroundColor: AppColors.selectStoryBackground,
        appBarColor: AppColors.selectStoryAppBarBackground,
        child: Text(
          appState.appTitle,
          style: GoogleFonts.quicksand(
            textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
        ).padding(left: 26).alignment(Alignment.centerLeft),
      ),
      body: Container(
        color: AppColors.selectStoryBackground,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
              child: Column(
                children: [
                  ...appState.stories.values.map(
                    (story) => story.id == '643599d047eb967304f115db'
                        ? SelectorCard(
                            title: story.name,
                            categoryColor: Colors.green,
                            categoryName: story.id,
                            image: story.poster,
                          ).gestures(onTap: () {
                            appState.selectStory(story.id, context);
                          })
                        : SelectorCard(
                            title: story.name,
                            categoryColor: Colors.red,
                            categoryName: story.id,
                            // image: story.poster,
                          ).gestures(onTap: () {
                            appState.selectStory(story.id, context);
                          }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
