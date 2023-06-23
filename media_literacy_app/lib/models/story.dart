class Story {
  final String id;
  final String name;
  final String description;
  final List<Actor> actors;
  final List<Chat> chats;
  final RemoteImageDefinition? poster;

  Story.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        description = json['description'] ?? '',
        actors = Actor.fromJsonList(json['actors']),
        chats = Chat.fromJsonList(json['chats']),
        poster = json['poster'] != null ? RemoteImageDefinition.fromJson(json['poster']) : null {
    for (var actor in actors) {
      actor.story = this;
    }
    for (var chat in chats) {
      chat.story = this;
    }
  }
}

class Actor {
  final String id;
  final String name;
  final RemoteImageDefinition avatar;

  Story? story;

  Actor.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        avatar = RemoteImageDefinition.fromJson(json['avatar']);

  static List<Actor> fromJsonList(List<dynamic> json) {
    return json.map((j) => Actor.fromJson(j)).toList();
  }
}

class RemoteImageDefinition {
  final String id;
  final int width;
  final int height;
  final String url;
  final String miniThumbUrl;

  RemoteImageDefinition.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        width = json['width'],
        height = json['height'],
        url = json['url'],
        miniThumbUrl = json['miniThumbUrl'];
}

class Chat {
  final String id;
  final String title;
  final String description;
  final bool isMainChat;
  final List<Thread> threads;
  final RemoteImageDefinition? poster;

  Story? story;

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        description = json['description'] ?? '',
        isMainChat = json['isMainChat'] ?? false,
        threads = Thread.fromJsonList(json['threads']),
        poster = json['poster'] != null ? RemoteImageDefinition.fromJson(json['poster']) : null {
    for (var thread in threads) {
      thread.chat = this;
    }
  }

  static List<Chat> fromJsonList(List<dynamic> json) {
    return json.map((j) => Chat.fromJson(j)).toList();
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
}

class MessageActionOptions {
  final String id;
  final String triggerChatId;

  MessageActionOptions.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        triggerChatId = json['triggerChatId'] ?? '';
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
}

class MessageResponseOption {
  final String id;
  final String text;
  final String buttonText;
  final String thread;
  final RemoteImageDefinition? photo;
  final bool isCorrect;

  MessageResponse? response;

  MessageResponseOption.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        text = json['text'] ?? '',
        buttonText = json['buttonText'] ?? '',
        thread = json['thread'] ?? '',
        photo = json['photo'] != null ? RemoteImageDefinition.fromJson(json['photo']) : null,
        isCorrect = json['isCorrect'] ?? false;

  static List<MessageResponseOption> fromJsonList(List<dynamic> json) {
    return json.map((j) => MessageResponseOption.fromJson(j)).toList();
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
  final RemoteImageDefinition? image;

  Message? message;

  DisplayedMessage.fromMessage(this.message)
      : type = DisplayedMessageType.message,
        threadId = message!.thread!.id,
        messageId = message.id,
        text = null,
        image = null;

  DisplayedMessage.fromResponse(this.threadId, this.messageId, this.text)
      : type = DisplayedMessageType.response,
        image = null;

  DisplayedMessage.fromResponseImage(this.threadId, this.messageId, this.image)
      : type = DisplayedMessageType.response,
        text = null;

  DisplayedMessage.system({required String this.text})
      : type = DisplayedMessageType.system,
        threadId = '',
        messageId = '',
        image = null;
}
