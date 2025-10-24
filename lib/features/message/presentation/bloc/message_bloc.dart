import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/usecase/message_usecase.dart';
import 'message_event.dart';
import 'message_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetConversationsUseCase getConversationsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;
  final GetOrCreateConversationUseCase getOrCreateConversationUseCase;

  StreamSubscription? _messagesSubscription;

  ChatBloc(
     this.getConversationsUseCase,
     this.getMessagesUseCase,
     this.sendMessageUseCase,
     this.getOrCreateConversationUseCase,
  ) : super(ChatInitial()) {
    on<LoadConversationsEvent>(_onLoadConversations);
    on<OpenConversationEvent>(_onOpenConversation);
    on<SelectConversationEvent>(_onSelectConversation);
    on<LoadMessagesEvent>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
    on<MarkAsReadEvent>(_onMarkAsRead);
  }

  Future<void> _onLoadConversations(
      LoadConversationsEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoading());

    final result = await getConversationsUseCase(NoParams());

    result.either(
          (failure) => emit(ChatErrorState(failure.message)),
          (conversations) {
        if (conversations.isEmpty) {
          emit(const ChatEmptyState());
        } else {
          emit(ConversationsLoadedState(conversations));
        }
      },
    );
  }

  Future<void> _onOpenConversation(
      OpenConversationEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoading());

    // Profile dan kelganda conversationId ni olish yoki yaratish
    final result = await getOrCreateConversationUseCase(event.participantId);

    result.either(
          (failure) => emit(ChatErrorState(failure.message)),
          (conversationId) {
        // Conversation ochilgandan keyin messagelarni yuklash
        add(LoadMessagesEvent(conversationId));
      },
    );
  }

  Future<void> _onSelectConversation(
      SelectConversationEvent event,
      Emitter<ChatState> emit,
      ) async {
    emit(ChatLoading());
    add(LoadMessagesEvent(event.conversationId));
  }

  Future<void> _onLoadMessages(
      LoadMessagesEvent event,
      Emitter<ChatState> emit,
      ) async {
    await _messagesSubscription?.cancel();

    _messagesSubscription = getMessagesUseCase(event.conversationId).listen(
          (result) {
        result.either(
              (failure) => emit(ChatErrorState(failure.message)),
              (messages) {
            // Participant ma'lumotlarini birinchi messagega qarab olish
            // Yoki conversation ma'lumotlaridan olish kerak
            emit(MessagesLoadedState(
              conversationId: event.conversationId,
              participantName: 'Mike Chen', // Bu ma'lumot conversation dan kelishi kerak
              participantAvatar: '', // Bu ma'lumot conversation dan kelishi kerak
              messages: messages,
              isOnline: false,
            ));
          },
        );
      },
    );
  }

  Future<void> _onSendMessage(
      SendMessageEvent event,
      Emitter<ChatState> emit,
      ) async {
    if (state is MessagesLoadedState) {
      final currentState = state as MessagesLoadedState;

      // Optimistic update
      emit(MessageSendingState(
        conversationId: event.conversationId,
        messages: currentState.messages,
      ));

      final result = await sendMessageUseCase(
        SendMessageParams(
          conversationId: event.conversationId,
          senderId: event.senderId,
          content: event.content,
        ),
      );

      result.either(
            (failure) => emit(ChatErrorState(failure.message)),
            (message) {
          // Message yuborildi, stream orqali yangi message keladi
          // Hozircha eski holatga qaytamiz
          emit(currentState);
        },
      );
    }
  }

  Future<void> _onMarkAsRead(
      MarkAsReadEvent event,
      Emitter<ChatState> emit,
      ) async {
    // Mark as read logic
    // Bu yerda repositoryga so'rov yuboriladi
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}