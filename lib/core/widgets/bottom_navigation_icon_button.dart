import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'app_text.dart';

class BottomNavigationIconButton extends StatelessWidget {
  const BottomNavigationIconButton({
    super.key,
    this.title,
    this.titleS = true,
    required this.svg,
    required this.iconColor,
    required this.titleColor, required this.callback,
  });

  final String  svg;
  final bool titleS;
  final String? title;
  final Color iconColor, titleColor;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        width: 75.w,
        height: 56.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: 1.sp,
          children: [
            SvgPicture.asset(
              svg,
              width: 24.w,
              height: 24.h,
              fit: BoxFit.cover,
              // ignore: deprecated_member_use
              color: iconColor,
            ),
            ?titleS
            ? AppText(
              text: title!,
              color: titleColor,
              fontWeight: 400,
              fontSize: 12.sp,
            )
            : null,

          ],
        ),
      ),
    );
  }
}
