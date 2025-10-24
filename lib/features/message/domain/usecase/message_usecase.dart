import 'package:housell/core/usecase/usecase.dart';
import '../../../../core/either/either.dart';
import '../../../../core/error/failure.dart';
import '../entity/conversation.dart';
import '../entity/message.dart';
import '../repository/repository.dart';

class GetConversationsUseCase implements UseCase<List<ConversationEntity>, NoParams> {
  final MessageRepository repository;

  GetConversationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ConversationEntity>>> call(NoParams params) async {
    return await repository.getConversations();
  }
}

class GetMessagesUseCase implements StreamUseCase<List<MessageEntity>, String> {
  final MessageRepository repository;

  GetMessagesUseCase(this.repository);

  @override
  Stream<Either<Failure, List<MessageEntity>>> call(String conversationId) {
    return repository.getMessages(conversationId);
  }
}

class SendMessageUseCase implements UseCase<MessageEntity, SendMessageParams> {
  final MessageRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      conversationId: params.conversationId,
      senderId: params.senderId,
      content: params.content,
    );
  }
}

class SendMessageParams {
  final String conversationId;
  final String senderId;
  final String content;

  const SendMessageParams({
    required this.conversationId,
    required this.senderId,
    required this.content,
  });

  @override
  List<Object?> get props => [conversationId, senderId, content];
}

class GetOrCreateConversationUseCase implements UseCase<String, String> {
  final MessageRepository repository;

  GetOrCreateConversationUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(String participantId) async {
    return await repository.getOrCreateConversation(participantId);
  }
}

