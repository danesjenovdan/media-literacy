import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [child],
    )
        .padding(horizontal: 16, vertical: 8)
        .border(top: 1, color: Theme.of(context).dividerColor)
        .backgroundColor(Theme.of(context).dialogBackgroundColor);
  }
}

class ConfirmationResponse extends StatelessWidget {
  final Message message;

  const ConfirmationResponse({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return ElevatedButton(
      onPressed: () {
        var lastMessageIndex = message.thread!.messages.indexWhere((m) => m.id == message.id);
        if ((lastMessageIndex + 1) < message.thread!.messages.length) {
          var nextMessage = message.thread!.messages[lastMessageIndex + 1];
          appState.addDisplayedMessage(DisplayedMessage.fromMessage(nextMessage));
        }
      },
      child: Text(message.response.text),
    );
  }
}

class OptionsResponse extends StatelessWidget {
  final Message message;

  const OptionsResponse({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      children: [
        ...message.response.options.map((option) => ElevatedButton(
            onPressed: () {
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
            },
            child: Text(option.buttonText)))
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
    if (disabledOptions.contains(option.id)) {
      return Stack(
        fit: StackFit.passthrough,
        alignment: Alignment.centerRight,
        children: [
          ElevatedButton(
            onPressed: null,
            child: Text(option.buttonText),
          ),
          Positioned(
            right: 10,
            child: Text('-$quizWrongAnswerPoints').textColor(Colors.red),
          ),
        ],
      );
    }

    return ElevatedButton(
      onPressed: () {
        _onTapOption(appState, option);
      },
      child: Text(option.buttonText),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...widget.message.response.options.map((option) => _buildOption(appState, option)),
      ],
    ).expanded();
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

    if (disabledOptions.contains(option.id)) {
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
      ).height(maxHeight / 2).expanded();
    }

    if (numOptions == 4) {
      return Column(
        children: [
          Expanded(child: Row(children: [_buildOption(appState, 0), const SizedBox(width: 8), _buildOption(appState, 1)])),
          const SizedBox(height: 8),
          Expanded(child: Row(children: [_buildOption(appState, 2), const SizedBox(width: 8), _buildOption(appState, 3)])),
        ],
      ).height(maxHeight).expanded();
    }

    return Text('UNIMPLEMENTED PHOTO QUIZ: length="$numOptions"');
  }
}
