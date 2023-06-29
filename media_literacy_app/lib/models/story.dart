import 'dart:io';
import 'package:collection/collection.dart';

class Story {
  final String id;
  final String name;
  final String description;
  final List<Actor> actors;
  final List<Chat> chats;
  final RemoteImageDefinition? poster;

  final Directory bundleFolder;

  Story.fromJson(Map<String, dynamic> json, this.bundleFolder)
      : id = json['_id'],
        name = json['name'],
        description = json['description'] ?? '',
        actors = Actor.fromJsonList(json['actors']),
        chats = Chat.fromJsonList(json['chats']),
        poster = json['poster'] != null ? RemoteImageDefinition.fromJson(json['poster']) : null {
    for (var actor in actors) {
      actor.setStory(this);
    }
    for (var chat in chats) {
      chat.setStory(this);
    }
    poster?.setStory(this);
  }
}

class Actor {
  final String id;
  final String name;
  final RemoteImageDefinition avatar;

  Story? _story;
  Story? get story => _story;

  Actor.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        avatar = RemoteImageDefinition.fromJson(json['avatar']);

  static List<Actor> fromJsonList(List<dynamic> json) {
    return json.map((j) => Actor.fromJson(j)).toList();
  }

  void setStory(Story story) {
    _story = story;
    avatar.setStory(story);
  }
}

class RemoteImageDefinition {
  final String id;
  final int width;
  final int height;
  final String fileName;
  final String url;
  final String miniThumbUrl;

  Story? _story;
  Story? get story => _story;

  RemoteImageDefinition.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        width = json['width'],
        height = json['height'],
        fileName = json['remote'],
        url = json['url'],
        miniThumbUrl = json['miniThumbUrl'];

  void setStory(Story story) {
    _story = story;
  }
}

class Chat {
  final String id;
  final String title;
  final String description;
  final bool isMainChat;
  final bool isLocked;
  final List<Thread> threads;
  final RemoteImageDefinition? poster;

  Story? _story;
  Story? get story => _story;

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        description = json['description'] ?? '',
        isMainChat = json['isMainChat'] ?? false,
        isLocked = json['isLocked'] ?? false,
        threads = Thread.fromJsonList(json['threads']),
        poster = json['poster'] != null ? RemoteImageDefinition.fromJson(json['poster']) : null {
    for (var thread in threads) {
      thread.chat = this;
    }
  }

  static List<Chat> fromJsonList(List<dynamic> json) {
    return json.map((j) => Chat.fromJson(j)).toList();
  }

  void setStory(Story story) {
    _story = story;
    for (var thread in threads) {
      thread.setStory(story);
    }
    poster?.setStory(story);
  }
}

class Thread {
  final String id;
  final String name;
  final List<Message> messages;

  Chat? chat;

  Thread.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        messages = Message.fromJsonList(json['messages']) {
    for (var message in messages) {
      message.thread = this;
    }
  }

  static List<Thread> fromJsonList(List<dynamic> json) {
    return json.map((j) => Thread.fromJson(j)).toList();
  }

  void setStory(Story story) {
    for (var message in messages) {
      message.setStory(story);
    }
  }
}

class Message {
  final String id;
  final String type;
  final String text;
  final String actor;
  final RemoteImageDefinition? image;
  final String youtubeId;
  final String youtubeThumbUrl;
  final String youtubeTitle;
  final MessageActionOptions? actionOptions;
  final MessageResponse response;

  Thread? thread;

  Message.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        type = json['type'],
        text = json['text'] ?? '',
        actor = json['actor'] ?? '',
        image = json['file'] != null ? RemoteImageDefinition.fromJson(json['file']) : null,
        youtubeId = json['youtubeId'] ?? '',
        youtubeThumbUrl = json['youtubeThumbUrl'] ?? '',
        youtubeTitle = json['youtubeTitle'] ?? '',
        actionOptions = json['actionOptions'] != null ? MessageActionOptions.fromJson(json['actionOptions']) : null,
        response = MessageResponse.fromJson(json['response']) {
    response.message = this;
  }

  static List<Message> fromJsonList(List<dynamic> json) {
    return json.map((j) => Message.fromJson(j)).toList();
  }

  void setStory(Story story) {
    image?.setStory(story);
    actionOptions?.setStory(story);
    response.setStory(story);
  }

  String? getActionTriggerChatId() {
    String triggerChatId = actionOptions?.triggerChatId ?? '';
    return triggerChatId.isNotEmpty ? triggerChatId : null;
  }

  Chat? getActionTriggerChat() {
    String? triggerChatId = getActionTriggerChatId();
    if (triggerChatId != null) {
      return thread!.chat!.story!.chats.firstWhereOrNull((chat) => chat.id == triggerChatId);
    }
    return null;
  }
}

class MessageActionOptions {
  final String id;
  final String triggerChatId;

  MessageActionOptions.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        triggerChatId = json['triggerChatId'] ?? '';

  void setStory(Story story) {}
}

class MessageResponse {
  final String id;
  final String type;
  final String text;
  final List<MessageResponseOption> options;
  final List<MessageResponseOption> photoOptions;

  Message? message;

  MessageResponse.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        type = json['type'],
        text = json['confirmText'] ?? '',
        options = MessageResponseOption.fromJsonList(json['options']),
        photoOptions = MessageResponseOption.fromJsonList(json['photoOptions']) {
    for (var option in options) {
      option.response = this;
    }
  }

  void setStory(Story story) {
    for (var option in options) {
      option.setStory(story);
    }
    for (var photoOption in photoOptions) {
      photoOption.setStory(story);
    }
  }
}

class MessageResponseOption {
  final String id;
  final String text;
  final String buttonText;
  final String thread;
  final RemoteImageDefinition? photo;
  final bool isCorrect;
  final bool hideResponseToChat;

  MessageResponse? response;

  MessageResponseOption.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        text = json['text'] ?? '',
        buttonText = json['buttonText'] ?? '',
        thread = json['thread'] ?? '',
        photo = json['photo'] != null ? RemoteImageDefinition.fromJson(json['photo']) : null,
        isCorrect = json['isCorrect'] ?? false,
        hideResponseToChat = json['hideResponseToChat'] ?? false;

  static List<MessageResponseOption> fromJsonList(List<dynamic> json) {
    return json.map((j) => MessageResponseOption.fromJson(j)).toList();
  }

  void setStory(Story story) {
    photo?.setStory(story);
  }
}

enum DisplayedMessageType {
  message,
  response,
  system,
}

class DisplayedMessage {
  final DisplayedMessageType type;
  final String threadId;
  final String messageId;
  final String? text;

  RemoteImageDefinition? image;
  Message? message;

  DisplayedMessage.fromMessage(this.message)
      : type = DisplayedMessageType.message,
        threadId = message!.thread!.id,
        messageId = message.id,
        text = null;

  DisplayedMessage.fromResponse(this.threadId, this.messageId, this.text) : type = DisplayedMessageType.response;

  DisplayedMessage.fromResponseImage(this.threadId, this.messageId, this.image)
      : type = DisplayedMessageType.response,
        text = null;

  DisplayedMessage.system({required String this.text})
      : type = DisplayedMessageType.system,
        threadId = '',
        messageId = '';

  DisplayedMessage.fromJson(Map<String, dynamic> json, Chat chat)
      : type = DisplayedMessageType.values.byName(json['type']),
        threadId = json['threadId'],
        messageId = json['messageId'],
        text = json['text'] {
    if (type == DisplayedMessageType.response && json['imageId'] != null) {
      var thread = chat.threads.firstWhereOrNull((t) => t.id == threadId);
      if (thread != null) {
        var message = thread.messages.firstWhereOrNull((m) => m.id == messageId);
        if (message != null) {
          var option = message.response.options.firstWhereOrNull((o) => o.photo?.id == json['imageId']) ??
              message.response.photoOptions.firstWhereOrNull((o) => o.photo?.id == json['imageId']);
          if (option != null) {
            image = option.photo;
          }
        }
      }
    }
    if (type == DisplayedMessageType.message) {
      message = chat.threads.firstWhere((t) => t.id == threadId).messages.firstWhere((m) => m.id == messageId);
    }
  }

  static List<DisplayedMessage> fromJsonList(List<dynamic> json, Chat chat) {
    return json.map((j) => DisplayedMessage.fromJson(j, chat)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      "type": type.name,
      "threadId": threadId,
      "messageId": messageId,
      "text": text,
      "imageId": image?.id,
    };
  }
}

class DisplayedState {
  List<DisplayedMessage> messageList = [];
  List<String> threadStack = [];
  bool completed = false;
  bool unlocked = false;

  DisplayedState();

  DisplayedState.fromJson(Map<String, dynamic> json, Chat chat)
      : messageList = DisplayedMessage.fromJsonList(json['messageList'], chat),
        threadStack = json['threadStack'].cast<String>(),
        completed = json['completed'] ?? false,
        unlocked = json['unlocked'] ?? false;

  Map<String, dynamic> toJson() {
    return {
      "messageList": messageList.map((m) => m.toJson()).toList(),
      "threadStack": threadStack,
      "completed": completed,
      "unlocked": completed,
    };
  }
}
