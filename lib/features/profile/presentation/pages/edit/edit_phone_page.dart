import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';

class EditPhonePage extends StatelessWidget {
  const EditPhonePage({super.key, required this.id,});
  final String id;
  // final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WCustomAppBar(
        title: AppText(text: "Change Number", fontSize: 18, fontWeight: 400),
        leadingImage: AppAssets.chevronLeft,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppImage(path: AppAssets.simGroup),
          SizedBox(height: 23.h),
          AppText(text: "23456789o876543", fontWeight: 400, fontSize: 22),
          SizedBox(height: 24.h),
          AppText(
            text:
                "Update your phone number right here. Everything in your account—messages, listings, settings, and more—will transfer seamlessly to the new one.",
            fontWeight: 400,
            fontSize: 15,
            color: AppColors.textMuted,
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ContainerW(
            onTap: () {
              context.push('/new_phone_otp_page/${id}');
              final String name = "Shahboz";
              String surname = "Roziqov";
              surname = "safwefrew";
              print(surname);
            },
            height: 51.h,
            radius: 8,
            text: "Change Number",
          )

        ],
      ).paddingOnly(top: 48, left: 24, right: 24),
    );
  }
}
