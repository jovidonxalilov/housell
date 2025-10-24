

import 'package:housell/features/message/data/data_source/message_datasource.dart';
import 'package:housell/features/message/data/repository_impl/repository_impl.dart';

import '../../../../core/either/either.dart';
import '../../../../core/error/failure.dart';
import '../entity/conversation.dart';
import '../entity/message.dart';

abstract class MessageRepository {
  /// Get all conversations for current user
  Future<Either<Failure, List<ConversationEntity>>> getConversations();

  /// Get messages for specific conversation
  Stream<Either<Failure, List<MessageEntity>>> getMessages(String conversationId);

  /// Send a message
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  });

  /// Create a new conversation
  Future<Either<Failure, ConversationEntity>> createConversation({
    required String participantId,
  });

  /// Mark messages as read
  Future<Either<Failure, void>> markAsRead(String conversationId);

  /// Get or create conversation with user
  Future<Either<Failure, String>> getOrCreateConversation(String participantId);

  factory MessageRepository(MessageDatasource profileDataSource) =>
      MessageRepositoryImpl(remoteDataSource: profileDataSource);
}