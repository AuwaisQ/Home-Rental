part of dash_chat;

/// A message data structure used by dash chat to handle messages
/// and also to handle quick replies
class ChatMessage {
  /// Id of the message if no id is supplied a new id is assigned
  /// using a [UUID v4] this behaviour could be overriden by provind
  /// and [optional] paramter called [messageIdGenerator].
  /// [messageIdGenerator] take a function with this
  /// signature [String Function()]
  String? id;

  /// Actual text message.
  String? text;

  /// It's a [non-optional] pararmter which specifies the time the
  /// message was delivered takes a [DateTime] object.
  DateTime createdAt = DateTime.now();

  /// Takes a [ChatUser] object which is used to distinguish between
  /// users and also provide avaatar URLs and name.
  ChatUser? user;

  /// A [non-optional] parameter which is used to display images
  /// takes a [Sring] as a url
  String? image;

  /// A [non-optional] parameter which is used to display vedio
  /// takes a [Sring] as a url
  String? video;

  /// A [non-optional] parameter which is used to show quick replies
  /// to the user
  QuickReplies? quickReplies;

  /// Allows to set custom-properties that could help with implementing custom
  /// functionality to dashchat.
  Map<String, dynamic>? customProperties;

  /// Allows to set buttons that could help with implementing custom
  /// actions in message container.
  List<Widget>? buttons;

  ChatMessage(
      {String? id,
      required this.text,
      required this.user,
      image,
      video,
      quickReplies,
      String Function()? messageIdGenerator,
      DateTime? createdAt,
      customProperties,
      buttons}) {
    createdAt = createdAt ?? DateTime.now();
    id = id ?? messageIdGenerator?.call() ?? const Uuid().v4().toString();
  }

  ChatMessage.fromJson(final Map<dynamic, dynamic> json) {
    id = json['id'];
    text = json['text'];
    image = json['image'];
    video = json['video'] ?? json['vedio'];
    createdAt = (json['createdAt'] != null)
        ? DateTime.fromMillisecondsSinceEpoch(json['createdAt'])
        : DateTime.now();
    user = json['user'] != null ? ChatUser.fromJson(json['user']) : null;
    quickReplies = json['quickReplies'] != null
        ? QuickReplies.fromJson(json['quickReplies'])
        : null;
    customProperties = json['customProperties'] as Map<String, dynamic>?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    try {
      data['id'] = id;
      data['text'] = text;
      data['image'] = image;
      data['video'] = video;
      data['createdAt'] = createdAt.millisecondsSinceEpoch;
      data['user'] = user!.toJson();
      data['quickReplies'] = quickReplies?.toJson();
      data['customProperties'] = customProperties;
    } catch (e, stack) {
      debugPrint('ERROR caught when trying to convert ChatMessage to JSON:');
      debugPrint(e.toString());
      debugPrint(stack.toString());
    }
    return data;
  }
}
