import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/dp/dp_injection.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/features/message/domain/usecase/message_usecase.dart';

import '../../domain/entity/message.dart';
import '../bloc/message_bloc.dart';
import '../bloc/message_event.dart';
import '../bloc/message_state.dart';

// class MessagePage extends StatefulWidget {
//   const MessagePage({super.key});
//
//   @override
//   State<MessagePage> createState() => _MessagePageState();
// }
//
// class _MessagePageState extends State<MessagePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.white,
//       body: Column(
//         children: [
//           Center(child: AppText(text: "Message", fontSize: 40,))
//         ],
//       ),
//     );
//   }
// }

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage(String conversationId, String senderId) {
    final content = _messageController.text.trim();
    if (content.isNotEmpty) {
      context.read<ChatBloc>().add(
        SendMessageEvent(
          conversationId: conversationId,
          senderId: senderId,
          content: content,
        ),
      );
      _messageController.clear();

      // Scroll to bottom after sending
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        getIt<GetConversationsUseCase>(),
        getIt<GetMessagesUseCase>(),
        getIt<SendMessageUseCase>(),
        getIt<GetOrCreateConversationUseCase>(),
      ),
      child: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          if (state is ChatLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ChatErrorState) {
            return Scaffold(body: Center(child: Text(state.message)));
          }

          if (state is MessagesLoadedState || state is MessageSendingState) {
            final String conversationId;
            final String participantName;
            final String participantAvatar;
            final List<MessageEntity> messages;
            final bool isOnline;

            if (state is MessagesLoadedState) {
              conversationId = state.conversationId;
              participantName = state.participantName;
              participantAvatar = state.participantAvatar;
              messages = state.messages;
              isOnline = state.isOnline;
            } else {
              final sendingState = state as MessageSendingState;
              // MessageSendingState dan ma'lumotlarni olish
              conversationId = sendingState.conversationId;
              messages = sendingState.messages;
              // Default qiymatlar
              participantName = 'Mike Chen';
              participantAvatar = '';
              isOnline = false;
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    context.read<ChatBloc>().add(LoadConversationsEvent());
                    Navigator.pop(context);
                  },
                ),
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundImage: participantAvatar.isNotEmpty
                          ? NetworkImage(participantAvatar)
                          : null,
                      child: participantAvatar.isEmpty
                          ? Text(
                              participantName[0].toUpperCase(),
                              style: const TextStyle(fontSize: 16),
                            )
                          : null,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      participantName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: messages.isEmpty
                        ? const Center(child: Text('No messages yet'))
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final message = messages[index];
                              final isMe =
                                  message.senderId ==
                                  'currentUserId'; // Bu dynamic bo'lishi kerak

                              return _MessageBubble(
                                message: message.content,
                                isMe: isMe,
                                time: message.createdAt,
                              );
                            },
                          ),
                  ),
                  _ChatInputField(
                    controller: _messageController,
                    onSend: () => _sendMessage(
                      conversationId,
                      'currentUserId', // Bu dynamic bo'lishi kerak
                    ),
                  ),
                ],
              ),
            );
          }

          return const Scaffold(
            body: Center(child: Text('Something went wrong')),
          );
        },
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime time;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.time,
  });

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe) const Spacer(),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe ? const Color(0xFF6C5CE7) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(time),
                    style: TextStyle(
                      color: isMe ? Colors.white70 : Colors.grey[600],
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (!isMe) const Spacer(),
        ],
      ),
    );
  }
}

class _ChatInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const _ChatInputField({required this.controller, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSend,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: Color(0xFF6C5CE7),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.send, color: Colors.white, size: 22),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
