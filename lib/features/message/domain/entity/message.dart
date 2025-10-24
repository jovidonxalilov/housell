import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final MessageType type;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    this.isRead = false,
    this.type = MessageType.text,
  });

  @override
  List<Object?> get props => [
    id,
    conversationId,
    senderId,
    content,
    createdAt,
    isRead,
    type,
  ];
}

enum MessageType {
  text,
  image,
  file,
}