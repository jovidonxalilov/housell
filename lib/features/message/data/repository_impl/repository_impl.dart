import '../../../../core/either/either.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entity/conversation.dart';
import '../../domain/entity/message.dart';
import '../../domain/repository/repository.dart';
import '../data_source/message_datasource.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageDatasource _remoteDataSource;

  MessageRepositoryImpl({required MessageDatasource remoteDataSource}) : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations() async {
    try {
      final conversations = await _remoteDataSource.getConversations();
      return Right(conversations);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<MessageEntity>>> getMessages(String conversationId) async* {
    try {
      await for (final messages in _remoteDataSource.getMessages(conversationId)) {
        yield Right(messages);
      }
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    try {
      final message = await _remoteDataSource.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        content: content,
      );
      return Right(message);
    }  catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ConversationEntity>> createConversation({
    required String participantId,
  }) async {
    try {
      final conversation = await _remoteDataSource.createConversation(
        participantId: participantId,
      );
      return Right(conversation);
    }   catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String conversationId) async {
    try {
      await _remoteDataSource.markAsRead(conversationId);
      return  Right(null);
    }  catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getOrCreateConversation(String participantId) async {
    try {
      final conversationId = await _remoteDataSource.getOrCreateConversation(participantId);
      return Right(conversationId);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
