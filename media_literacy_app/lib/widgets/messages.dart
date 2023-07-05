import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:media_literacy_app/models/story.dart';
import 'package:media_literacy_app/state/app_state.dart';
import 'package:media_literacy_app/widgets/images.dart';
import 'package:media_literacy_app/widgets/lazy_youtube_player.dart';
import 'package:styled_widget/styled_widget.dart';

class SystemMessage extends StatelessWidget {
  final String text;

  const SystemMessage({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text.trim())
        .textAlignment(TextAlign.center)
        .textStyle(AppTextStyles.systemMessage)
        .padding(horizontal: 16, vertical: 8)
        .alignment(Alignment.center);
  }
}

class MessageAvatar extends StatelessWidget {
  final RemoteImageDefinition image;

  const MessageAvatar(this.image, {super.key});

  @override
  Widget build(BuildContext context) {
    return RemoteProgressiveImageLoader(image).backgroundColor(Colors.red).clipOval().constrained(width: 32, height: 32).padding(right: 14);
  }
}

class MessageBubble extends StatelessWidget {
  final Widget child;
  final bool isOutgoing;

  const MessageBubble({super.key, required this.child, this.isOutgoing = false});

  @override
  Widget build(BuildContext context) {
    var bgColor = isOutgoing ? AppColors.chatMessageOutgoingBackground : AppColors.chatMessageIncomingBackground;
    return Styled.widget(child: child).backgroundColor(bgColor).clipRRect(all: 16);
  }
}

Actor? getActor(Message message) {
  List<Actor> actors = message.thread!.chat!.story!.actors;
  return actors.firstWhereOrNull((actor) => actor.id == message.actor);
}

class NarratorMessage extends StatelessWidget {
  final Message message;

  const NarratorMessage(this.message, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget content;
    if (message.type == 'TEXT') {
      if (message.text.isEmpty) {
        return const SizedBox.shrink();
      }
      content = Text(message.text.trim()).textStyle(AppTextStyles.message);
    } else if (message.type == 'IMAGE') {
      content = AspectRatio(
        aspectRatio: message.image!.width / message.image!.height,
        child: RemoteProgressiveImageLoader(message.image!, openViewerOnTap: true),
      ).backgroundColor(AppColors.chatMessageIncomingBackground).clipRRect(all: 16);
    } else if (message.type == 'YOUTUBE') {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: LazyYoutubePlayer(message.youtubeId, message.youtubeThumbUrl),
          ),
          Text(message.youtubeTitle).textStyle(AppTextStyles.youtubeMessage).padding(vertical: 8, horizontal: 12),
        ],
      )
          .backgroundColor(AppColors.youtubeMessageBackground)
          .clipRRect(all: 16)
          .boxShadow(color: const Color(0x1F000000), offset: const Offset(0, 8), blurRadius: 16);
    } else {
      return Text('UNIMPLEMENTED NARRATOR MESSAGE: id="${message.id}" type="${message.type}"');
    }

    return Styled.widget(child: content).padding(horizontal: 16, vertical: 12);
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
      if (message.text.isEmpty) {
        return const SizedBox.shrink();
      }
      content = Text(message.text.trim()).textStyle(AppTextStyles.message).padding(horizontal: 12, top: 10, bottom: 8);
    } else if (message.type == 'IMAGE') {
      content = AspectRatio(
        aspectRatio: message.image!.width / message.image!.height,
        child: RemoteProgressiveImageLoader(message.image!, openViewerOnTap: true),
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
              Text(actor.name).textStyle(AppTextStyles.messageAuthor).padding(bottom: 6),
              MessageBubble(child: content),
            ],
          ),
        )
      ],
    ).padding(horizontal: 16, vertical: 8);
  }
}

class OutgoingMessage extends StatelessWidget {
  final String? text;
  final RemoteImageDefinition? image;

  const OutgoingMessage({super.key, required this.text, required this.image});

  @override
  Widget build(BuildContext context) {
    // limit height to third of screen
    final double maxWidth = MediaQuery.of(context).size.width * 0.66;

    Widget content;
    if (text != null) {
      content = Text(text!.trim()).textStyle(AppTextStyles.message).padding(horizontal: 12, top: 10, bottom: 8);
    } else if (image != null) {
      content = content = AspectRatio(
        aspectRatio: image!.width / image!.height,
        child: RemoteProgressiveImageLoader(image!, openViewerOnTap: true),
      ).constrained(maxWidth: maxWidth);
    } else {
      return const Text('TODO: UNIMPLEMENTED REGULAR MESSAGE: text and image both empty');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MessageBubble(isOutgoing: true, child: content),
            ],
          ),
        )
      ],
    ).padding(horizontal: 16, vertical: 8);
  }
}
