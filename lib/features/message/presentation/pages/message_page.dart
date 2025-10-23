import 'package:flutter/material.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/widgets/app_text.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          Center(child: AppText(text: "Message", fontSize: 40,))
        ],
      ),
    );
  }
}



// class ChatListPage extends StatelessWidget {
//   const ChatListPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundP,
//       appBar: WCustomAppBar(
//         title: AppText(
//           text: 'Messages',
//           fontSize: 20,
//           fontWeight: 600,
//           color: AppColors.darkest,
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {
//               // Notification logic
//             },
//             icon: Icon(Icons.notifications_outlined),
//           ),
//         ],
//       ),
//       body: BlocBuilder<ChatListCubit, ChatListState>(
//         builder: (context, state) {
//           if (state is ChatListLoading) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.primary,
//               ),
//             );
//           }
//
//           if (state is ChatListError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   AppText(
//                     text: 'Error: ${state.message}',
//                     fontSize: 14,
//                     color: AppColors.red,
//                   ),
//                   SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: () {
//                       context.read<ChatListCubit>().loadChats();
//                     },
//                     child: Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           if (state is ChatListLoaded) {
//             if (state.chats.isEmpty) {
//               return Center(
//                 child: AppText(
//                   text: 'No messages yet',
//                   fontSize: 16,
//                   color: AppColors.textLight,
//                 ),
//               );
//             }
//
//             return RefreshIndicator(
//               onRefresh: () async {
//                 await context.read<ChatListCubit>().refreshChats();
//               },
//               child: ListView.separated(
//                 padding: EdgeInsets.symmetric(vertical: 8),
//                 itemCount: state.chats.length,
//                 separatorBuilder: (context, index) => Divider(
//                   height: 1,
//                   color: AppColors.lightGrey,
//                   indent: 88,
//                 ),
//                 itemBuilder: (context, index) {
//                   final chat = state.chats[index];
//                   return ChatListItem(
//                     chat: chat,
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => ChatDetailPage(
//                             chatId: chat.id,
//                             otherUser: chat.user,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             );
//           }
//
//           return SizedBox();
//         },
//       ),
//     );
//   }
// }