import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/footer_logos.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                bottom: false,
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      const AboutText().padding(horizontal: 16),
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

class AboutText extends StatelessWidget {
  const AboutText({super.key});

  Widget _buildHeading(String text) {
    return Text(text).textStyle(AppTextStyles.systemMessage).padding(bottom: 12);
  }

  Widget _buildParagraph(String text) {
    return Text(text).textStyle(AppTextStyles.message).padding(bottom: 12);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeading("The standard Lorem Ipsum passage, used since the 1500s"),
        _buildParagraph(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
          "minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit "
          "in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia "
          "deserunt mollit anim id est laborum.",
        ),
        _buildHeading("Section 1.10.32 of \"de Finibus Bonorum et Malorum\", written by Cicero in 45 BC"),
        _buildParagraph(
          "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab "
          "illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur "
          "aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem "
          "ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam "
          "aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex "
          "ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum "
          "qui dolorem eum fugiat quo voluptas nulla pariatur?",
        ),
      ],
    ).padding(bottom: 16);
  }
}
