import 'package:equatable/equatable.dart';
import '../../domain/entity/conversation.dart';
import '../../domain/entity/message.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

/// Conversations list holati
class ConversationsLoadedState extends ChatState {
  final List<ConversationEntity> conversations;

  const ConversationsLoadedState(this.conversations);

  @override
  List<Object?> get props => [conversations];
}

/// Messages holati
class MessagesLoadedState extends ChatState {
  final String conversationId;
  final String participantName;
  final String participantAvatar;
  final List<MessageEntity> messages;
  final bool isOnline;

  const MessagesLoadedState({
    required this.conversationId,
    required this.participantName,
    required this.participantAvatar,
    required this.messages,
    this.isOnline = false,
  });

  @override
  List<Object?> get props => [conversationId, participantName, participantAvatar, messages, isOnline];

  MessagesLoadedState copyWith({
    String? conversationId,
    String? participantName,
    String? participantAvatar,
    List<MessageEntity>? messages,
    bool? isOnline,
  }) {
    return MessagesLoadedState(
      conversationId: conversationId ?? this.conversationId,
      participantName: participantName ?? this.participantName,
      participantAvatar: participantAvatar ?? this.participantAvatar,
      messages: messages ?? this.messages,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

/// Message jo'natish holati
class MessageSendingState extends ChatState {
  final String conversationId;
  final List<MessageEntity> messages;

  const MessageSendingState({
    required this.conversationId,
    required this.messages,
  });

  @override
  List<Object?> get props => [conversationId, messages];
}

/// Error holati
class ChatErrorState extends ChatState {
  final String message;

  const ChatErrorState(this.message);

  @override
  List<Object?> get props => [message];
}

/// Empty holati (conversation yo'q)
class ChatEmptyState extends ChatState {
  final String message;

  const ChatEmptyState([this.message = 'No conversations yet']);

  @override
  List<Object?> get props => [message];
}