import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String participantId;
  final String participantName;
  final String participantAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  const ConversationEntity({
    required this.id,
    required this.participantId,
    required this.participantName,
    required this.participantAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [
    id,
    participantId,
    participantName,
    participantAvatar,
    lastMessage,
    lastMessageTime,
    unreadCount,
    isOnline,
  ];
}