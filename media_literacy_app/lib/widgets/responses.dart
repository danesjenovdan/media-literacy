import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

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

class QuizResponse extends StatelessWidget {
  final Message message;

  const QuizResponse({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...message.response.options.map(
          (option) => ElevatedButton(
            onPressed: () {
              if (option.isCorrect) {
                var lastMessageIndex = message.thread!.messages.indexWhere((m) => m.id == message.id);
                if ((lastMessageIndex + 1) < message.thread!.messages.length) {
                  var nextMessage = message.thread!.messages[lastMessageIndex + 1];
                  appState.addDisplayedMessage(DisplayedMessage.fromMessage(nextMessage));
                }
              }
            },
            child: Text(option.buttonText),
          ),
        ),
      ],
    ).expanded();
  }
}

class PhotoQuizResponse extends StatelessWidget {
  final Message message;

  const PhotoQuizResponse({super.key, required this.message});

  void _onTapOption(AppState appState, int index) {
    var option = message.response.photoOptions[index];
    if (option.isCorrect) {
      var lastMessageIndex = message.thread!.messages.indexWhere((m) => m.id == message.id);
      if ((lastMessageIndex + 1) < message.thread!.messages.length) {
        var nextMessage = message.thread!.messages[lastMessageIndex + 1];
        appState.addDisplayedMessage(DisplayedMessage.fromMessage(nextMessage));
      }
    }
  }

  Widget _buildOption(AppState appState, int index) {
    return Expanded(
      child: RemoteProgressiveImageLoader(
        message.response.photoOptions[index].photo!,
        fit: BoxFit.cover,
      ).clipRRect(all: 8).gestures(
        onTap: () {
          _onTapOption(appState, index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    // limit height to third of screen
    final double maxHeight = MediaQuery.of(context).size.height * 0.33;

    if (message.response.photoOptions.length == 2) {
      return Column(
        children: [
          Expanded(child: Row(children: [_buildOption(appState, 0), const SizedBox(width: 8), _buildOption(appState, 1)])),
        ],
      ).height(maxHeight / 2).expanded();
    }

    if (message.response.photoOptions.length == 4) {
      return Column(
        children: [
          Expanded(child: Row(children: [_buildOption(appState, 0), const SizedBox(width: 8), _buildOption(appState, 1)])),
          const SizedBox(height: 8),
          Expanded(child: Row(children: [_buildOption(appState, 2), const SizedBox(width: 8), _buildOption(appState, 3)])),
        ],
      ).height(maxHeight).expanded();
    }

    return Text('UNIMPLEMENTED PHOTO QUIZ: length="${message.response.photoOptions.length}"');
  }
}
