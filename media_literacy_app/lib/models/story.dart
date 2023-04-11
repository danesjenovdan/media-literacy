class Story {
  final String id;
  final String name;
  final List<Actor> actors;
  final List<Chat> chats;

  Story.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        actors = Actor.fromJsonList(json['actors']),
        chats = Chat.fromJsonList(json['chats']) {
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
  final bool isMainChat;
  final List<Thread> threads;

  Story? story;

  Chat.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        title = json['title'],
        isMainChat = json['isMainChat'] ?? false,
        threads = Thread.fromJsonList(json['threads']) {
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
  final MessageResponse response;

  Thread? thread;

  Message.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        type = json['type'],
        text = json['text'] ?? '',
        actor = json['actor'] ?? '',
        image = json['file'] != null ? RemoteImageDefinition.fromJson(json['file']) : null,
        response = MessageResponse.fromJson(json['response']) {
    response.message = this;
  }

  static List<Message> fromJsonList(List<dynamic> json) {
    return json.map((j) => Message.fromJson(j)).toList();
  }
}

class MessageResponse {
  final String id;
  final String type;
  final String text;
  final List<MessageResponseOption> options;

  Message? message;

  MessageResponse.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        type = json['type'],
        text = json['confirmText'] ?? '',
        options = MessageResponseOption.fromJsonList(json['options']) {
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

  MessageResponse? response;

  MessageResponseOption.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        text = json['text'] ?? '',
        buttonText = json['buttonText'] ?? '',
        thread = json['thread'] ?? '';

  static List<MessageResponseOption> fromJsonList(List<dynamic> json) {
    return json.map((j) => MessageResponseOption.fromJson(j)).toList();
  }
}

enum DisplayedMessageType {
  message,
  response,
}

class DisplayedMessage {
  final DisplayedMessageType type;
  final String threadId;
  final String messageId;
  final String? text;

  Message? message;

  DisplayedMessage.fromMessage(this.message)
      : type = DisplayedMessageType.message,
        threadId = message!.thread!.id,
        messageId = message.id,
        text = null;

  DisplayedMessage.fromResponse(this.threadId, this.messageId, this.text) : type = DisplayedMessageType.response;
}
