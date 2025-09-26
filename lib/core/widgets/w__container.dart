import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../config/theme/app_colors.dart';
import 'app_text.dart';

class WContainer extends StatelessWidget {
  const WContainer({
    super.key,
    this.textColor = AppColors.white,
    this.child,
    this.text,
    this.width = double.infinity,
    this.height = 48,
    this.color = AppColors.base,
    this.borderColor = Colors.transparent,
    this.onTap,
    this.radius = 30,
    this.formKey,
    this.isValidNotifier,
  });

  final ValueNotifier<bool>? isValidNotifier;

  final Widget? child;
  final String? text;
  final double? width;
  final Color? color, borderColor, textColor;
  final double? height;
  final double? radius;
  final VoidCallback? onTap;
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    // final bool isValid = formKey?.currentState?.validate() ?? false;
    return ValueListenableBuilder(
      valueListenable: isValidNotifier!,
      builder: (context, isValid, _) {
        return GestureDetector(
          onTap: isValid ? onTap : null,
          child: Container(
            width: width?.w,
            height: height?.h,
            decoration: BoxDecoration(
              color: isValid ? color : AppColors.lightSky,
              borderRadius: BorderRadius.circular(radius!),
              border: Border.all(color: borderColor!),
            ),
            child:
                child ??
                Center(
                  child: AppText(
                    text: text!,
                    fontSize: 15,
                    fontWeight: 500,
                    color: isValid ? textColor : AppColors.grey300,
                  ),
                ),
          ),
        );
      },
    );
  }
}

class ContainerW extends StatelessWidget {
  const ContainerW({
    this.boxShadow,
    this.border,
    super.key,
    this.child,
    this.margin,
    this.text,
    this.width = double.infinity,
    this.height,
    this.color = AppColors.base,
    this.borderColor = Colors.transparent,
    this.onTap,
    this.radius = 30,
    this.formKey,
    // this.isValidNotifier,
  });

  // final ValueNotifier<bool>? isValidNotifier;
  final List<BoxShadow>? boxShadow;
  final Widget? child;
  final Border? border;
  final String? text;
  final double? width;
  final Color? color, borderColor;
  final double? height;
  final double? radius;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final GlobalKey<FormState>? formKey;

  @override
  Widget build(BuildContext context) {
    // final bool isValid = formKey?.currentState?.validate() ?? false;
    return GestureDetector(
      onTap:  onTap ,
      child: Container(
        width: width?.w,
        height: height?.h,
        margin: margin,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius!),
          border: border ?? Border.all(color: borderColor!),
          boxShadow: boxShadow
        ),
        child:
        child ??
            Center(
              child: AppText(
                text: text!,
                fontSize: 15,
                fontWeight: 500,
                color: AppColors.white,
              ),
            ),
      ),
    );
  }
}
