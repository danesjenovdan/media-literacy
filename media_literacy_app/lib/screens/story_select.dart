import 'package:flutter/material.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/selector_card.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class StorySelectScreen extends StatelessWidget {
  const StorySelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Scaffold(
      appBar: createAppBar(context, AppConstants.title),
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
                bottom: false,
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      ...appState.stories.values.map(
                        (story) => SelectorCard(
                          title: story.name,
                          categoryColor: AppColors.storySelectCircle,
                          categoryName: story.description,
                          image: story.poster,
                        ).padding(horizontal: 16).gestures(onTap: () {
                          appState.selectStory(story.id, context);
                        }),
                      ),
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
