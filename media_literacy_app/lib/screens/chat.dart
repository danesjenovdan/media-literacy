import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/messages.dart';
import 'package:provider/provider.dart';

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

Widget buildResponse(BuildContext context, AppState appState, List<DisplayedMessage> displayedMessages) {
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

  if (lastMessage.response.type == 'QUIZ') {}

  print('UNIMPLEMENTED RESPONSE: id="${lastMessage.id}" type="${lastMessage.response.type}"');
  return Text('UNIMPLEMENTED RESPONSE: id="${lastMessage.id}" type="${lastMessage.response.type}"');
}

Future advanceMessages(AppState appState, List<DisplayedMessage> displayedMessages) {
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

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    var displayedMessages = appState.getDisplayedMessages();
    next ??= advanceMessages(appState, displayedMessages).whenComplete(() => next = null);

    var messageListView = ListView.builder(
      controller: _scrollController,
      itemCount: displayedMessages.length,
      itemBuilder: (context, index) => buildMessage(context, displayedMessages[index]),
    );

    var responseView = buildResponse(context, appState, displayedMessages);

    Future.microtask(() {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
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
