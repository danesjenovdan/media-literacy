import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:media_literacy_app/widgets/messages.dart';
import 'package:provider/provider.dart';
import 'package:styled_widget/styled_widget.dart';

Widget buildMessage(BuildContext context, DisplayedMessage displayedMessage) {
  if (displayedMessage.type == DisplayedMessageType.system) {
    return SystemMessage(text: displayedMessage.text!);
  }

  if (displayedMessage.type == DisplayedMessageType.response) {
    return const Text('TODO: UNIMPLEMENTED RESPONSE MESSAGE');
  }

  // -> displayedMessage.type == DisplayedMessageType.message

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
        children: [const Text('Quest end'), Text('Next quest: ${nextChat.title}')],
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

Widget buildResponse(BuildContext context, AppState appState, DisplayedState displayedState) {
  var displayedMessages = displayedState.messageList;

  if (displayedMessages.isEmpty || displayedMessages.last.type != DisplayedMessageType.message) {
    return const SizedBox.shrink();
  }

  var lastMessage = displayedMessages.last.message!;
  var lastThread = lastMessage.thread!;

  if (lastMessage.response.type == 'NO_RESPONSE') {
    return const SizedBox.shrink();
  }

  if (lastMessage.response.type == 'CONFIRMATION') {
    return ElevatedButton(
      onPressed: () {
        var lastMessageIndex = lastThread.messages.indexWhere((m) => m.id == lastMessage.id);
        if ((lastMessageIndex + 1) < lastThread.messages.length) {
          var message = lastThread.messages[lastMessageIndex + 1];
          appState.addDisplayedMessage(DisplayedMessage.fromMessage(message));
        }
      },
      child: Text(lastMessage.response.text),
    );
  }

  if (lastMessage.response.type == 'QUIZ') {
    return Column(
      children: [
        ...lastMessage.response.options.map(
          (option) => ElevatedButton(
            onPressed: () {
              if (option.isCorrect) {
                var lastMessageIndex = lastThread.messages.indexWhere((m) => m.id == lastMessage.id);
                if ((lastMessageIndex + 1) < lastThread.messages.length) {
                  var message = lastThread.messages[lastMessageIndex + 1];
                  appState.addDisplayedMessage(DisplayedMessage.fromMessage(message));
                }
              }
            },
            child: Text(option.buttonText),
          ),
        ),
      ],
    );
  }

  if (lastMessage.response.type == 'PHOTO_QUIZ') {
    var columns = 2;
    var rows = (lastMessage.response.photoOptions.length / columns).ceil();

    List<Widget> widgets = [];
    for (var col = 0; col < columns; col++) {
      List<Widget> children = [];
      for (var row = 0; row < rows; row++) {
        var option = lastMessage.response.photoOptions[col * columns + row];
        children.add(RemoteProgressiveImageLoader(option.photo!).constrained(width: 50, height: 50));
      }
      widgets.add(Row(children: children));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // ...lastMessage.response.photoOptions.map(
        //   (option) => ElevatedButton(
        //     onPressed: () {
        //       // if (option.isCorrect) {
        //       //   var lastMessageIndex = lastThread.messages.indexWhere((m) => m.id == lastMessage.id);
        //       //   if ((lastMessageIndex + 1) < lastThread.messages.length) {
        //       //     var message = lastThread.messages[lastMessageIndex + 1];
        //       //     appState.addDisplayedMessage(DisplayedMessage.fromMessage(message));
        //       //   }
        //       // }
        //     },
        //     child: RemoteProgressiveImageLoader(option.photo!).constrained(width: 50, height: 50),
        //   ),
        // ),
        ...widgets,
      ],
    );
  }

  if (lastMessage.response.type == 'OPTIONS') {
    return Column(
      children: [
        ...lastMessage.response.options.map((option) => ElevatedButton(
            onPressed: () {
              if (lastThread.id == option.thread) {
                var lastMessageIndex = lastThread.messages.indexWhere((m) => m.id == lastMessage.id);
                if ((lastMessageIndex + 1) < lastThread.messages.length) {
                  var message = lastThread.messages[lastMessageIndex + 1];
                  appState.addDisplayedMessage(DisplayedMessage.fromMessage(message));
                }
              } else {
                var newThread = lastMessage.thread!.chat!.threads.firstWhereOrNull((thread) => thread.id == option.thread);
                if (newThread != null) {
                  var message = newThread.messages.first;
                  appState.addDisplayedMessage(DisplayedMessage.fromMessage(message));
                }
              }
            },
            child: Text(option.buttonText)))
      ],
    );
  }

  print('UNIMPLEMENTED RESPONSE: id="${lastMessage.id}" type="${lastMessage.response.type}"');
  return Text('UNIMPLEMENTED RESPONSE: id="${lastMessage.id}" type="${lastMessage.response.type}"');
}

Future advanceMessages(AppState appState, DisplayedState displayedState) {
  var displayedMessages = displayedState.messageList;

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

  var last = displayedMessages.last;
  if (last.type == DisplayedMessageType.message) {
    var lastMessage = last.message!;
    var lastThread = lastMessage.thread!;

    if (lastMessage.type.startsWith('ACTION')) {
      // TODO:
      return Future.value(null);
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

  return Future.value(null);
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
    next ??= advanceMessages(appState, displayedState).whenComplete(() => next = null);

    var messageListView = ListView.builder(
      controller: _scrollController,
      itemCount: displayedState.messageList.length,
      itemBuilder: (context, index) => buildMessage(context, displayedState.messageList[index]),
    );

    var responseView = buildResponse(context, appState, displayedState);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollToEnd();
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.selectedChat!.title),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: messageListView),
          responseView,
        ],
      ),
    );
  }
}
