import 'package:housell/core/error/failure.dart';

import '../../../../core/dio/dio_client.dart';
import '../model/chat_model.dart';
import '../model/conversation_model.dart';

abstract class MessageDatasource {
  /// Get all conversations
  Future<List<ConversationModel>> getConversations();

  /// Get messages for conversation (Stream for real-time updates)
  Stream<List<MessageModel>> getMessages(String conversationId);

  /// Send a message
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  });

  /// Create a new conversation
  Future<ConversationModel> createConversation({
    required String participantId,
  });

  /// Mark messages as read
  Future<void> markAsRead(String conversationId);

  /// Get or create conversation with user
  Future<String> getOrCreateConversation(String participantId);

  factory MessageDatasource(DioClient dioClient) =>
      MessageDatasourceImpl(client: dioClient);
}

class MessageDatasourceImpl implements MessageDatasource {
  final DioClient client;

  MessageDatasourceImpl({required this.client});

  @override
  Future<List<ConversationModel>> getConversations() async {
    try {
      final response = await client.get('/conversations');

      if (response.ok && response.result != null) {
        final List<dynamic> data = response.result as List<dynamic>;
        return data.map((json) => ConversationModel.fromJson(json)).toList();
      } else {
        throw ApiException(
          response.detail?['description'] ?? 'Failed to load conversations',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String conversationId) async* {
    // Bu yerda WebSocket yoki Server-Sent Events ishlatish kerak
    // Hozircha polling usulida qilamiz
    while (true) {
      try {
        final response = await client.get('/conversations/$conversationId/messages');

        if (response.ok && response.result != null) {
          final List<dynamic> data = response.result as List<dynamic>;
          final messages = data.map((json) => MessageModel.fromJson(json)).toList();
          yield messages;
        } else {
          throw ApiException(
            response.detail?['description'] ?? 'Failed to load messages',
          );
        }
      } catch (e) {
        throw ApiException(e.toString());
      }

      // 3 soniyada bir yangilanadi
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  @override
  Future<MessageModel> sendMessage({
    required String conversationId,
    required String senderId,
    required String content,
  }) async {
    try {
      final response = await client.post(
        '/chat/message',
        data: {
          'conversationId': conversationId,
          'senderId': senderId,
          'content': content,
        },
      );

      if (response.ok && response.result != null) {
        return MessageModel.fromJson(response.result as Map<String, dynamic>);
      } else {
        throw ApiException(
          response.detail?['description'] ?? 'Failed to send message',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Future<ConversationModel> createConversation({
    required String participantId,
  }) async {
    try {
      final response = await client.post(
        '/conversations',
        data: {
          'participantId': participantId,
        },
      );

      if (response.ok && response.result != null) {
        return ConversationModel.fromJson(response.result as Map<String, dynamic>);
      } else {
        throw ApiException(
          response.detail?['description'] ?? 'Failed to create conversation',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    try {
      final response = await client.put('/conversations/$conversationId/read');

      if (!response.ok) {
        throw ApiException(
          response.detail?['description'] ?? 'Failed to mark as read',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  @override
  Future<String> getOrCreateConversation(String participantId) async {
    try {
      final response = await client.post(
        '/conversations/get-or-create',
        data: {
          'participantId': participantId,
        },
      );

      if (response.ok && response.result != null) {
        final data = response.result as Map<String, dynamic>;
        return data['conversationId'] as String;
      } else {
        throw ApiException(
          response.detail?['description'] ?? 'Failed to get or create conversation',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}
