import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

Actor getActor(Message message) {
  var actors = message.thread!.chat!.story!.actors;
  return actors.firstWhere((actor) => actor.id == message.actor);
}

Widget buildMessage(BuildContext context, DisplayedMessage displayedMessage) {
  var message = displayedMessage.message!;

  if (message.type.startsWith('ACTION')) {
    return Text('UNIMPLEMENTED ACTION MESSAGE: id="${message.id}" type="${message.type}"');
  }

  if (message.actor.isEmpty) {
    return Text('MESSAGE HAS NO ACTOR! id="${message.id}" type="${message.type}"');
  }

  if (message.actor == 'NARRATOR') {
    if (message.type == 'TEXT') {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          message.text,
          style: const TextStyle(
            fontSize: 16,
            height: 1.3,
          ),
        ),
      );
    }

    if (message.type == 'IMAGE') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.circular(8),
          ),
          clipBehavior: Clip.hardEdge,
          child: AspectRatio(
            aspectRatio: message.image!.width / message.image!.height,
            child: ProgressiveImage.custom(
              placeholderBuilder: (context) {
                return const Center(child: CircularProgressIndicator());
              },
              thumbnail: NetworkImage(message.image!.miniThumbUrl),
              image: NetworkImage(message.image!.url),
              width: message.image!.width.toDouble(),
              height: message.image!.height.toDouble(),
            ),
          ),
        ),
      );
    }

    return Text('UNIMPLEMENTED NARRATOR MESSAGE: id="${message.id}" type="${message.type}"');
  } else {
    // Non-NARRATOR actor messages:
    if (message.type == 'TEXT') {
      return Container(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 16),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColorLight, width: 2),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(getActor(message).avatar.url),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 4, bottom: 4),
                    child: Text(
                      getActor(message).name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.3,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      );
    }

    return Text('UNIMPLEMENTED REGULAR MESSAGE: id="${message.id}" type="${message.type}"');
  }
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

  print('UNIMPLEMENTED RESPONSE: id="${lastMessage.id}" type="${lastMessage.response.type}"');
  return Text('UNIMPLEMENTED RESPONSE: id="${lastMessage.id}" type="${lastMessage.response.type}"');
}

Future advanceMessages(AppState appState, List<DisplayedMessage> displayedMessages) {
  if (displayedMessages.isEmpty) {
    return Future.microtask(() {
      var firstMessage = appState.selectedChat!.threads.first.messages.first;
      appState.addDisplayedMessage(DisplayedMessage.fromMessage(firstMessage));
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
  ScrollController _scrollController = new ScrollController();

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
