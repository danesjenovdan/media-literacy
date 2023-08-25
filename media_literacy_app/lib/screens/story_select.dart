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

    // remove the old about story
    var stories = appState.stories.values.where((story) => story.id != "6495a84511622f51d8e2abbf");

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
                      ...stories.map(
                        (story) => SelectorCard(
                          title: story.name,
                          categoryName: story.description,
                          image: story.poster,
                        ).padding(horizontal: 16).gestures(onTap: () {
                          appState.selectStory(story.id, context);
                        }),
                      ),
                      SecondarySelectorCard(
                        color: AppColors.selectInfoBackground,
                        title: 'Dodatne informacije',
                        image: Image.asset('assets/images/icon-logo.png'),
                      ).padding(horizontal: 16).gestures(onTap: () {
                        appState.selectStory('info', context);
                      }),
                      SecondarySelectorCard(
                        color: AppColors.selectAboutBackground,
                        title: 'Za nastavnike/ce',
                        image: Image.asset('assets/images/icon-info.png'),
                      ).padding(horizontal: 16).gestures(onTap: () {
                        appState.selectStory('about', context);
                      }),
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
