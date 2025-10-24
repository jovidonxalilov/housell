import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object?> get props => [];
}

/// Conversations listini yuklash
class LoadConversationsEvent extends ChatEvent {}

/// Conversation ochish (profile dan kelganda)
class OpenConversationEvent extends ChatEvent {
  final String participantId;
  final String participantName;
  final String participantAvatar;

  const OpenConversationEvent({
    required this.participantId,
    required this.participantName,
    required this.participantAvatar,
  });

  @override
  List<Object?> get props => [participantId, participantName, participantAvatar];
}

/// Conversation tanlash
class SelectConversationEvent extends ChatEvent {
  final String conversationId;

  const SelectConversationEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

/// Messagelarni yuklash
class LoadMessagesEvent extends ChatEvent {
  final String conversationId;

  const LoadMessagesEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}

/// Message jo'natish
class SendMessageEvent extends ChatEvent {
  final String conversationId;
  final String senderId;
  final String content;

  const SendMessageEvent({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object?> get props => [conversationId, senderId, content];
}

/// O'qilgan deb belgilash
class MarkAsReadEvent extends ChatEvent {
  final String conversationId;

  const MarkAsReadEvent(this.conversationId);

  @override
  List<Object?> get props => [conversationId];
}