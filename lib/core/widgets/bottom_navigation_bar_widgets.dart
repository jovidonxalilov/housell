import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import '../../config/theme/app_colors.dart';
import '../constants/app_assets.dart';
import 'bottom_navigation_icon_button.dart';

class WBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;

  const WBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity.w,
      // iOS uchun SafeArea padding qo'shish
      height: Platform.isIOS ? 56.h + bottomPadding : 56.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
        color: AppColors.white,
        // iOS uchun shadow qo'shish (ixtiyoriy)
        boxShadow: Platform.isIOS ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ] : null,
      ),
      child: Column(
        children: [
          // Asosiy navigation content
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomNavigationIconButton(
                  callback: () {onTap(0);},
                  svg: AppAssets.home,
                  iconColor: selectedIndex == 0 ? AppColors.primary : AppColors.botttomIcon,
                  title: "Home",
                  titleColor: selectedIndex == 0 ? AppColors.primary : AppColors.light,
                ),
                BottomNavigationIconButton(
                  callback: () {onTap(1);},
                  svg: AppAssets.map,
                  iconColor: selectedIndex == 1 ? AppColors.primary : AppColors.botttomIcon,
                  title: "Map",
                  titleColor: selectedIndex == 1 ? AppColors.primary : AppColors.light,
                ),
                BottomNavigationIconButton(
                  callback: () {onTap(2);},
                  svg: AppAssets.add,
                  iconColor: selectedIndex == 2 ? AppColors.primary : AppColors.botttomIcon,
                  titleS: false,
                  titleColor: selectedIndex == 2 ? AppColors.primary : AppColors.light,
                ),
                BottomNavigationIconButton(
                  callback: () {onTap(3);},
                  svg: AppAssets.chat,
                  iconColor: selectedIndex == 3 ? AppColors.primary : AppColors.botttomIcon,
                  title: "Message",
                  titleColor: selectedIndex == 3 ? AppColors.primary : AppColors.light,
                ),
                // Profile tugmasidagi xato tuzatildi (index 4 bo'lishi kerak)
                BottomNavigationIconButton(
                  callback: () {onTap(4);},
                  svg: AppAssets.profile,
                  iconColor: selectedIndex == 4 ? AppColors.primary : AppColors.botttomIcon,
                  title: "Profile",
                  titleColor: selectedIndex == 4 ? AppColors.primary : AppColors.light,
                ),
              ],
            ).paddingOnly(top: 8, bottom: 0),
          ),

          // iOS uchun SafeArea spacing
          if (Platform.isIOS)
            SizedBox(height: bottomPadding),
        ],
      ),
    );
  }
}
