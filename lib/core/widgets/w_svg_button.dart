import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme/app_colors.dart';
import 'app_image.dart';

class WSvgButton extends StatelessWidget {
  const WSvgButton({
    super.key,
    required this.image,
    this.onTap,
    this.color = AppColors.white,
    this.svgSize = 20,
    this.width = 48,
    this.height = 48, this.iconColor = AppColors.black,
  });

  final String image;
  final VoidCallback? onTap;
  final Color? color,iconColor;
  final double? width, height;
  final double? svgSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width?.w,
        height: height?.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: AppColors.divider),
        ),
        child: Center(
          child: AppImage(path: image, size: svgSize, color: iconColor,),
        ),
      ),
    );
  }
}
