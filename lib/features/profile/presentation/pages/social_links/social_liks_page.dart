import 'package:flutter/material.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';

class SocialLinksPage extends StatefulWidget {
  const SocialLinksPage({super.key});

  @override
  State<SocialLinksPage> createState() => _SocialLinksPageState();
}

class _SocialLinksPageState extends State<SocialLinksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundP,
      appBar: WCustomAppBar(
        title: AppText(
          text: "Social Links",
          fontWeight: 400,
          fontSize: 18,
          color: AppColors.lightIcon,
        ),

      ),
    );
  }
}
