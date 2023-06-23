import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/dialog.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

int quizMaxPoints = 50;
int quizWrongAnswerPoints = 10;

class ChatResponse extends StatelessWidget {
  final Widget child;

  const ChatResponse({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Styled.widget(child: child)
        .padding(horizontal: 16, top: 18, bottom: 10)
        .backgroundColor(AppColors.chatResponseBackground)
        .constrained(width: double.infinity)
        .clipRRect(topLeft: 12, topRight: 12);
  }
}

class ConfirmationResponse extends StatelessWidget {
  final Message message;

  const ConfirmationResponse({super.key, required this.message});

  void _onTap(AppState appState) {
    var lastMessageIndex = message.thread!.messages.indexWhere((m) => m.id == message.id);
    if ((lastMessageIndex + 1) < message.thread!.messages.length) {
      var nextMessage = message.thread!.messages[lastMessageIndex + 1];
      appState.addDisplayedMessage(DisplayedMessage.fromMessage(nextMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Text(message.response.text)
        .textStyle(AppTextStyles.responseConfirmation)
        .textAlignment(TextAlign.center)
        .padding(all: 12)
        .backgroundColor(AppColors.chatResponseOptionBackground)
        .constrained(width: double.infinity)
        .clipRRect(all: 12)
        .padding(horizontal: 16, top: 18, bottom: 14)
        .gestures(onTap: () => _onTap(appState));
  }
}

class OptionsResponse extends StatelessWidget {
  final Message message;

  const OptionsResponse({super.key, required this.message});

  void _onTapOption(BuildContext context, AppState appState, MessageResponseOption option) {
    var isCorrect = option.isCorrect || option.hideResponseToChat;

    if (!isCorrect) {
      showCupertinoDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return CustomDialog(
            text: option.text,
          );
        },
      );
      return;
    }

    appState.addDisplayedMessage(DisplayedMessage.fromResponse(message.thread!.id, message.id, option.buttonText));

    if (message.thread!.id == option.thread) {
      var lastMessageIndex = message.thread!.messages.indexWhere((m) => m.id == message.id);
      if ((lastMessageIndex + 1) < message.thread!.messages.length) {
        var newMessage = message.thread!.messages[lastMessageIndex + 1];
        appState.addDisplayedMessage(DisplayedMessage.fromMessage(newMessage));
      }
    } else {
      var newThread = message.thread!.chat!.threads.firstWhereOrNull((thread) => thread.id == option.thread);
      if (newThread != null) {
        var newMessage = newThread.messages.first;
        appState.addDisplayedMessage(DisplayedMessage.fromMessage(newMessage));
      }
    }
  }

  Widget _buildOption(BuildContext context, AppState appState, MessageResponseOption option) {
    return Text(option.buttonText)
        .textStyle(AppTextStyles.responseOption)
        .padding(all: 12)
        .backgroundColor(AppColors.chatResponseOptionBackground)
        .constrained(width: double.infinity)
        .clipRRect(all: 12)
        .padding(bottom: 4)
        .gestures(onTap: () => _onTapOption(context, appState, option));
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      children: [
        ...message.response.options.map((option) => _buildOption(context, appState, option)),
      ],
    );
  }
}

class QuizResponse extends StatefulWidget {
  final Message message;

  const QuizResponse({super.key, required this.message});

  @override
  State<QuizResponse> createState() => _QuizResponseState();
}

abstract class BaseQuizResponseState<T extends QuizResponse> extends State<T> {
  List<String> disabledOptions = [];

  void _onTapOption(AppState appState, MessageResponseOption option) {
    if (option.isCorrect) {
      var points = quizMaxPoints - (disabledOptions.length * quizWrongAnswerPoints);
      appState.addPoints(points);
      if (option.photo != null) {
        appState.addDisplayedMessage(DisplayedMessage.fromResponseImage(widget.message.thread!.id, widget.message.id, option.photo));
      } else {
        appState.addDisplayedMessage(DisplayedMessage.fromResponse(widget.message.thread!.id, widget.message.id, option.buttonText));
      }

      appState.addDisplayedMessage(DisplayedMessage.system(text: '+$points points!'));

      var lastMessageIndex = widget.message.thread!.messages.indexWhere((m) => m.id == widget.message.id);
      if ((lastMessageIndex + 1) < widget.message.thread!.messages.length) {
        var nextMessage = widget.message.thread!.messages[lastMessageIndex + 1];
        appState.addDisplayedMessage(DisplayedMessage.fromMessage(nextMessage));
      }
    } else {
      setState(() {
        disabledOptions.add(option.id);
      });
    }
  }
}

class _QuizResponseState extends BaseQuizResponseState<QuizResponse> {
  Widget _buildOption(AppState appState, MessageResponseOption option) {
    var isDisabled = disabledOptions.contains(option.id);

    var optionWidget = Text(option.buttonText)
        .textStyle(AppTextStyles.responseOption)
        .padding(all: 12)
        .backgroundColor(isDisabled ? Colors.grey : AppColors.chatResponseOptionBackground)
        .constrained(width: double.infinity)
        .clipRRect(all: 12)
        .padding(bottom: 4);

    if (!disabledOptions.contains(option.id)) {
      return optionWidget.gestures(onTap: () => _onTapOption(appState, option));
    }

    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.centerRight,
      children: [
        optionWidget,
        Positioned(
          right: 10,
          child: Text('-$quizWrongAnswerPoints').textColor(Colors.red),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      children: [
        ...widget.message.response.options.map((option) => _buildOption(appState, option)),
      ],
    );
  }
}

class PhotoQuizResponse extends QuizResponse {
  const PhotoQuizResponse({super.key, required super.message});

  @override
  State<PhotoQuizResponse> createState() => _PhotoQuizResponseState();
}

class _PhotoQuizResponseState extends BaseQuizResponseState<PhotoQuizResponse> {
  Widget _buildOption(AppState appState, int index) {
    var option = widget.message.response.photoOptions[index];
    var isDisabled = disabledOptions.contains(option.id);

    if (isDisabled) {
      return Expanded(
        child: Stack(
          fit: StackFit.passthrough,
          alignment: Alignment.topRight,
          children: [
            ColorFiltered(
              colorFilter: const ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              ),
              child: RemoteProgressiveImageLoader(
                option.photo!,
                fit: BoxFit.cover,
              ),
            ).clipRRect(all: 8).opacity(0.66),
            Positioned(
              top: 8,
              right: 8,
              child: Text('-$quizWrongAnswerPoints').textColor(Colors.red).fontSize(21).fontWeight(FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return Expanded(
      child: RemoteProgressiveImageLoader(
        option.photo!,
        fit: BoxFit.cover,
      ).clipRRect(all: 8).gestures(
        onTap: () {
          _onTapOption(appState, option);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // limit height to third of screen
    final double maxHeight = MediaQuery.of(context).size.height * 0.33;

    var numOptions = widget.message.response.photoOptions.length;

    if (numOptions == 2) {
      return Column(
        children: [
          Expanded(child: Row(children: [_buildOption(appState, 0), const SizedBox(width: 8), _buildOption(appState, 1)])),
        ],
      ).height(maxHeight / 2);
    }

    if (numOptions == 4) {
      return Column(
        children: [
          Expanded(child: Row(children: [_buildOption(appState, 0), const SizedBox(width: 8), _buildOption(appState, 1)])),
          const SizedBox(height: 8),
          Expanded(child: Row(children: [_buildOption(appState, 2), const SizedBox(width: 8), _buildOption(appState, 3)])),
        ],
      ).height(maxHeight);
    }

    return Text('UNIMPLEMENTED PHOTO QUIZ: length="$numOptions"');
  }
}
