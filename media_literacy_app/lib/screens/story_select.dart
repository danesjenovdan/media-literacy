import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/selector_cards.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class StorySelectScreen extends StatelessWidget {
  const StorySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: createAppBar(context, appState.appTitle),
      extendBodyBehindAppBar: true,
      body: Container(
        color: AppColors.selectStoryBackground,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
              child: Column(
                children: [
                  ...appState.stories.values.map(
                    (story) => SelectorCard(
                      title: story.name,
                      categoryColor: AppColors.chatSelectCircle,
                      categoryName: story.description,
                      image: story.poster,
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
