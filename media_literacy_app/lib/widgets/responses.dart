import 'dart:async';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_dialog.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

class ChatResponse extends StatelessWidget {
  final Widget child;

  const ChatResponse({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Styled.widget(child: child)
        .padding(horizontal: 16, top: 16, bottom: 11)
        .safeArea(top: false, left: false, right: false)
        .backgroundColor(AppColors.chatBackground)
        .constrained(width: double.infinity);
  }
}

class ResponseButton extends StatefulWidget {
  final String text;
  final bool showArrow;
  final bool stayTapped;
  final void Function()? onTap;

  const ResponseButton({super.key, required this.text, this.showArrow = false, this.stayTapped = false, this.onTap});

  @override
  State<ResponseButton> createState() => _ResponseButtonState();
}

class _ResponseButtonState extends State<ResponseButton> {
  bool isTapped = false;

  void _resetTapped() {
    if (widget.stayTapped) return;
    setState(() {
      isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget returnWidget;

    if (widget.showArrow) {
      returnWidget = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.text)
              .textStyle(isTapped ? AppTextStyles.responseConfirmationDown : AppTextStyles.responseConfirmation)
              .textAlignment(TextAlign.center),
          Icon(Icons.arrow_forward_rounded, size: 22, color: isTapped ? AppColors.text : Colors.white).padding(left: 12),
        ],
      );
    } else {
      returnWidget =
          Text(widget.text).textStyle(isTapped ? AppTextStyles.responseOptionDown : AppTextStyles.responseOption).textAlignment(TextAlign.center);
    }

    return returnWidget
        .alignment(Alignment.center)
        .padding(vertical: 10, horizontal: 8)
        .backgroundColor(isTapped ? AppColors.chatResponseOptionBackgroundDown : AppColors.chatResponseOptionBackground)
        .constrained(width: double.infinity, minHeight: 64)
        .gestures(
          onTapDown: (_) {
            setState(() {
              isTapped = true;
            });
          },
          onTapUp: (_) {
            Timer(const Duration(milliseconds: 150), _resetTapped);
          },
          onTapCancel: () {
            Timer(const Duration(milliseconds: 150), _resetTapped);
          },
          onTap: widget.onTap,
        )
        .clipRRect(all: 12)
        .padding(bottom: 5);
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

    return ResponseButton(
      text: message.response.text,
      showArrow: true,
      onTap: () => _onTap(appState),
    );
  }
}

class OptionsResponse extends StatefulWidget {
  final Message message;

  const OptionsResponse({super.key, required this.message});

  @override
  State<OptionsResponse> createState() => _OptionsResponseState();
}

class _OptionsResponseState extends State<OptionsResponse> {
  List<String> correctOptionsIds = [];
  List<String> correctOptionsSelectedIds = [];

  @override
  void initState() {
    correctOptionsIds = widget.message.response.options
        .where((option) {
          var isCorrect = option.isCorrect || option.hideResponseToChat;
          return isCorrect;
        })
        .map((option) => option.id)
        .toList();

    super.initState();
  }

  void _onTapOption(BuildContext context, AppState appState, MessageResponseOption option) async {
    if (correctOptionsIds.isNotEmpty) {
      var isCorrect = correctOptionsIds.contains(option.id);

      if ((isCorrect && correctOptionsIds.length == 1 && option.text.isEmpty)) {
        // dont show dialog for single correct option without text
      } else {
        await showDialog(
          context: context,
          barrierDismissible: true,
          barrierColor: AppColors.text.withAlpha(200),
          builder: (context) {
            return CustomDialog(
              text: option.text.isEmpty ? "<no text>" : option.text,
            );
          },
        );
      }

      if (!isCorrect || correctOptionsSelectedIds.contains(option.id)) {
        return;
      }

      setState(() {
        correctOptionsSelectedIds.add(option.id);
      });
    }

    if (correctOptionsSelectedIds.length == correctOptionsIds.length) {
      String text = "";

      if (correctOptionsIds.isEmpty) {
        text = option.buttonText;
      } else {
        List<MessageResponseOption> correctOptions =
            widget.message.response.options.where((option) => correctOptionsIds.contains(option.id)).toList();
        for (var correctOption in correctOptions) {
          if (correctOptionsIds.length > 1) {
            text += "- ${correctOption.buttonText}\n";
          } else {
            text += correctOption.buttonText;
          }
        }
      }

      appState.addDisplayedMessage(DisplayedMessage.fromResponse(widget.message.thread!.id, widget.message.id, text));

      if (widget.message.thread!.id == option.thread) {
        var lastMessageIndex = widget.message.thread!.messages.indexWhere((m) => m.id == widget.message.id);
        if ((lastMessageIndex + 1) < widget.message.thread!.messages.length) {
          var newMessage = widget.message.thread!.messages[lastMessageIndex + 1];
          appState.addDisplayedMessage(DisplayedMessage.fromMessage(newMessage));
        }
      } else {
        var newThread = widget.message.thread!.chat!.threads.firstWhereOrNull((thread) => thread.id == option.thread);
        if (newThread != null) {
          var newMessage = newThread.messages.first;
          appState.addDisplayedMessage(DisplayedMessage.fromMessage(newMessage));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      children: [
        ...widget.message.response.options.map((option) {
          var isCorrect = correctOptionsIds.contains(option.id);
          return ResponseButton(
            text: option.buttonText,
            stayTapped: isCorrect,
            onTap: () => _onTapOption(context, appState, option),
          );
        }),
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
      // var points = quizMaxPoints - (disabledOptions.length * quizWrongAnswerPoints);
      // appState.addPoints(points);
      if (option.photo != null) {
        appState.addDisplayedMessage(DisplayedMessage.fromResponseImage(widget.message.thread!.id, widget.message.id, option.photo));
      } else {
        appState.addDisplayedMessage(DisplayedMessage.fromResponse(widget.message.thread!.id, widget.message.id, option.buttonText));
      }

      // appState.addDisplayedMessage(DisplayedMessage.system(text: '+$points points!'));

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
        .textAlignment(TextAlign.center)
        .alignment(Alignment.center)
        .padding(vertical: 10, horizontal: 8)
        .backgroundColor(isDisabled ? Colors.grey : AppColors.chatResponseOptionBackground)
        .constrained(width: double.infinity, minHeight: 64)
        .clipRRect(all: 12)
        .padding(bottom: 5);

    if (!disabledOptions.contains(option.id)) {
      return optionWidget.gestures(onTap: () => _onTapOption(appState, option));
    }

    return Stack(
      fit: StackFit.passthrough,
      alignment: Alignment.centerRight,
      children: [
        optionWidget,
        // Positioned(
        //   right: 10,
        //   child: Text('-$quizWrongAnswerPoints').textColor(Colors.red),
        // ),
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
            // Positioned(
            //   top: 8,
            //   right: 8,
            //   child: Text('-$quizWrongAnswerPoints').textColor(Colors.red).fontSize(21).fontWeight(FontWeight.bold),
            // ),
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
