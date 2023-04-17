import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:media_literacy_app/widgets/lazy_youtube_player.dart';
import 'package:styled_widget/styled_widget.dart';

var systemTextStyle = TextStyle(
  fontSize: 14,
  fontStyle: FontStyle.italic,
  color: Colors.grey.shade700,
);

var messageTextStyle = const TextStyle(
  fontSize: 16,
  height: 1.3,
);

var messageAuthorTextStyle = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.w500,
  color: Colors.grey.shade800,
);

class SystemMessage extends StatelessWidget {
  final String text;

  const SystemMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text).textAlignment(TextAlign.center).textStyle(systemTextStyle).padding(all: 16).alignment(Alignment.center);
  }
}

class MessageAvatar extends StatelessWidget {
  final RemoteImageDefinition image;

  const MessageAvatar(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteProgressiveImageLoader(image)
        .clipOval()
        .padding(all: 2)
        .constrained(width: 48, height: 48)
        .decorated(shape: BoxShape.circle, border: Border.all(color: Theme.of(context).primaryColorLight, width: 2))
        .padding(right: 16);
  }
}

class MessageBubble extends StatelessWidget {
  final Widget child;

  const MessageBubble({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Styled.widget(child: child).backgroundColor(Theme.of(context).primaryColorLight).clipRRect(all: 8);
  }
}

Actor? getActor(Message message) {
  var actors = message.thread!.chat!.story!.actors;
  return actors.firstWhereOrNull((actor) => actor.id == message.actor);
}

class NarratorMessage extends StatelessWidget {
  final Message message;

  const NarratorMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (message.type == 'TEXT') {
      content = Text(message.text).textStyle(messageTextStyle);
    } else if (message.type == 'IMAGE') {
      content = AspectRatio(
        aspectRatio: message.image!.width / message.image!.height,
        child: RemoteProgressiveImageLoader(message.image!),
      ).backgroundColor(Theme.of(context).primaryColorLight).clipRRect(all: 8);
    } else if (message.type == 'YOUTUBE') {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: LazyYoutubePlayer(message.youtubeId, message.youtubeThumbUrl),
          ),
          Text(message.youtubeTitle).textStyle(messageTextStyle).padding(vertical: 8, horizontal: 12),
        ],
      ).backgroundColor(Theme.of(context).primaryColorLight).clipRRect(all: 8);
    } else {
      return Text('UNIMPLEMENTED NARRATOR MESSAGE: id="${message.id}" type="${message.type}"');
    }

    return Styled.widget(child: content).padding(all: 16);
  }
}

class IncomingMessage extends StatelessWidget {
  final Message message;

  const IncomingMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    var actor = getActor(message);
    if (actor == null) {
      return Text('ERROR: MESSAGE HAS INVALID ACTOR! id="${message.id}" type="${message.type}"');
    }

    Widget content;
    if (message.type == 'TEXT') {
      content = Text(message.text).textStyle(messageTextStyle).padding(vertical: 8, horizontal: 12);
    } else if (message.type == 'IMAGE') {
      content = AspectRatio(
        aspectRatio: message.image!.width / message.image!.height,
        child: RemoteProgressiveImageLoader(message.image!),
      );
    } else {
      return Text('TODO: UNIMPLEMENTED REGULAR MESSAGE: id="${message.id}" type="${message.type}"');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MessageAvatar(actor.avatar),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(actor.name).textStyle(messageAuthorTextStyle).padding(left: 4, bottom: 4),
              MessageBubble(child: content),
            ],
          ),
        )
      ],
    ).padding(all: 16);
  }
}
