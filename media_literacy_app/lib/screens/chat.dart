import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/custom_app_bar.dart';
import 'package:media_literacy_app/widgets/messages.dart';
import 'package:media_literacy_app/widgets/responses.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

Widget buildMessage(BuildContext context, DisplayedMessage displayedMessage) {
  if (displayedMessage.type == DisplayedMessageType.system) {
    return SystemMessage(text: displayedMessage.text!);
  }

  if (displayedMessage.type == DisplayedMessageType.response) {
    return OutgoingMessage(text: displayedMessage.text, image: displayedMessage.image);
  }

  if (displayedMessage.type == DisplayedMessageType.message) {
    if (displayedMessage.message == null) {
      return const Text('ERROR: DISPLAYED MESSAGE DOES NOT HAVE A MESSAGE');
    }

    var message = displayedMessage.message!;

    if (message.type.startsWith('ACTION')) {
      if (message.type == 'ACTION_QUEST_END') {
        var nextChatId = message.actionOptions!.triggerChatId;
        var nextChat = message.thread!.chat!.story!.chats.firstWhereOrNull((chat) => chat.id == nextChatId);

        if (nextChat == null) {
          return Text('ERROR: ACTION HAS INVALID TRIGGER CHAT ID! id="${message.id}" type="${message.type}"');
        }

        return Column(
          children: [
            // const Text('Quest end'),
            Text('Next quest: ${nextChat.title}'),
            ElevatedButton(
                onPressed: () {
                  Navigator.maybePop(context);
                },
                child: const Text('Finish quest!'))
          ],
        );
      }

      return Text('TODO: UNIMPLEMENTED ACTION MESSAGE: id="${message.id}" type="${message.type}"');
    }

    if (message.actor.isEmpty) {
      return Text('ERROR: MESSAGE HAS NO ACTOR! id="${message.id}" type="${message.type}"');
    }

    if (message.actor == 'NARRATOR') {
      return NarratorMessage(message);
    }

    return IncomingMessage(message);
  }

  print('ERROR: INVALID TYPE displayedMessage.type="${displayedMessage.type}"');
  throw ArgumentError.value(displayedMessage.type);
}

(Widget, bool) buildResponse(BuildContext context, AppState appState, DisplayedState displayedState) {
  var displayedMessages = displayedState.messageList;

  if (displayedMessages.isEmpty || displayedMessages.last.type != DisplayedMessageType.message) {
    return (const SizedBox.shrink(), false);
  }

  var lastMessage = displayedMessages.last.message!;

  if (lastMessage.response.type == 'NO_RESPONSE') {
    return (const SizedBox.shrink(), false);
  }

  if (lastMessage.response.type == 'CONFIRMATION') {
    return (ConfirmationResponse(message: lastMessage), false);
  }

  if (lastMessage.response.type == 'QUIZ') {
    return (QuizResponse(message: lastMessage), true);
  }

  if (lastMessage.response.type == 'PHOTO_QUIZ') {
    return (PhotoQuizResponse(message: lastMessage), true);
  }

  if (lastMessage.response.type == 'OPTIONS') {
    return (OptionsResponse(message: lastMessage), true);
  }

  print('UNIMPLEMENTED RESPONSE: id="${lastMessage.id}" type="${lastMessage.response.type}"');
  return (Text('UNIMPLEMENTED RESPONSE: id="${lastMessage.id}" type="${lastMessage.response.type}"'), true);
}

Future? queueNextMessage(AppState appState, DisplayedState displayedState) {
  var displayedMessages = displayedState.messageList;

  // if no displayed messages, show first message in first thread
  if (displayedMessages.isEmpty) {
    return Future.microtask(() {
      var threads = appState.selectedChat!.threads;
      if (threads.isNotEmpty && threads.first.messages.isNotEmpty) {
        var firstMessage = threads.first.messages.first;
        appState.addDisplayedMessage(DisplayedMessage.fromMessage(firstMessage));
      } else {
        appState.addDisplayedMessage(DisplayedMessage.system(text: 'No messages!'));
      }
    });
  }

  // if last displayed message
  var last = displayedMessages.last;
  if (last.type == DisplayedMessageType.message) {
    var lastMessage = last.message!;
    var lastThread = lastMessage.thread!;

    if (lastMessage.type.startsWith('ACTION')) {
      // TODO:
      return null;
    }

    if (lastMessage.response.type == 'NO_RESPONSE') {
      return Future.microtask(() {
        var lastMessageIndex = lastThread.messages.indexWhere((m) => m.id == lastMessage.id);
        if ((lastMessageIndex + 1) < lastThread.messages.length) {
          var message = lastThread.messages[lastMessageIndex + 1];
          appState.addDisplayedMessage(DisplayedMessage.fromMessage(message));
        }
      });
    }
  }

  return null;
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _scrollController = ScrollController();

  Future? next;

  _scrollToEnd() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    var displayedState = appState.getDisplayedState();
    next ??= queueNextMessage(appState, displayedState)?.whenComplete(() => next = null);

    var messageListView = ListView.builder(
      controller: _scrollController,
      itemCount: displayedState.messageList.length,
      itemBuilder: (context, index) =>
          Styled.widget(child: buildMessage(context, displayedState.messageList[index])).padding(top: index == 0 ? 20 : 0),
    );

    var (responseView, wrapResponse) = buildResponse(context, appState, displayedState);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollToEnd();
    });

    return Scaffold(
      appBar: createAppBarWithBackButton(context, appState.selectedChat!.title),
      extendBodyBehindAppBar: true,
      body: Container(
        color: AppColors.selectChatBackground,
        child: Column(
          children: [
            Expanded(child: messageListView),
            wrapResponse ? ChatResponse(child: responseView) : responseView,
          ],
        ),
      ),
    );
  }
}
