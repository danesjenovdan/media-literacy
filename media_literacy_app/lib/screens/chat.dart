import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:provider/provider.dart';

Actor getActor(Message message) {
  var actors = message.thread!.chat!.story!.actors;
  return actors.firstWhere((actor) => actor.id == message.actor);
}

Widget buildMessage(BuildContext context, Message message) {
  if (message.actor.isEmpty) {
    return const Text('MESSAGE: EMPTY ACTOR!');
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

    return Text('NARRATOR MESSAGE: TYPE ${message.type}!');
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

    // IMAGE

    return Text('MESSAGE: TYPE ${message.type}!');
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    var messages = appState.selectedChat!.threads.map((t) => t.messages).expand((e) => e).toList();

    var messageListView = ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return buildMessage(context, messages[index]);
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(appState.selectedChat!.title),
        centerTitle: true,
      ),
      body: messageListView,
    );
  }
}
