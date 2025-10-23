// lib/models/chat_user.dart
class ChatUser {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isOnline;

  ChatUser({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isOnline = false,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) {
    return ChatUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      isOnline: json['is_online'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar_url': avatarUrl,
      'is_online': isOnline,
    };
  }
}

// lib/models/message.dart
class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String text;
  final DateTime timestamp;
  final bool isSent;
  final bool isRead;
  final MessageType type;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.text,
    required this.timestamp,
    this.isSent = false,
    this.isRead = false,
    this.type = MessageType.text,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] ?? '',
      chatId: json['chat_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      receiverId: json['receiver_id'] ?? '',
      text: json['text'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
      isSent: json['is_sent'] ?? false,
      isRead: json['is_read'] ?? false,
      type: MessageType.values.firstWhere(
            (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
      'is_sent': isSent,
      'is_read': isRead,
      'type': type.name,
    };
  }

  Message copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? receiverId,
    String? text,
    DateTime? timestamp,
    bool? isSent,
    bool? isRead,
    MessageType? type,
  }) {
    return Message(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isSent: isSent ?? this.isSent,
      isRead: isRead ?? this.isRead,
      type: type ?? this.type,
    );
  }
}

enum MessageType {
  text,
  image,
  file,
  location,
}

// lib/models/chat_item.dart
class ChatItem {
  final String id;
  final ChatUser user;
  final Message? lastMessage;
  final int unreadCount;
  final DateTime? lastActivityTime;

  ChatItem({
    required this.id,
    required this.user,
    this.lastMessage,
    this.unreadCount = 0,
    this.lastActivityTime,
  });

  factory ChatItem.fromJson(Map<String, dynamic> json) {
    return ChatItem(
      id: json['id'] ?? '',
      user: ChatUser.fromJson(json['user']),
      lastMessage: json['last_message'] != null
          ? Message.fromJson(json['last_message'])
          : null,
      unreadCount: json['unread_count'] ?? 0,
      lastActivityTime: json['last_activity_time'] != null
          ? DateTime.parse(json['last_activity_time'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'last_message': lastMessage?.toJson(),
      'unread_count': unreadCount,
      'last_activity_time': lastActivityTime?.toIso8601String(),
    };
  }

  String getTimeAgo() {
    if (lastActivityTime == null) return '';

    final now = DateTime.now();
    final difference = now.difference(lastActivityTime!);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${lastActivityTime!.day}/${lastActivityTime!.month}';
    }
  }
}