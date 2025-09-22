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
