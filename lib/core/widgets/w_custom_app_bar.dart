import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:housell/core/extensions/widget_extension.dart';

import '../../config/theme/app_colors.dart';
import 'app_image.dart';
// import 'package:housell/core/extensions/widget_extension.dart';
//
// import 'app_image.dart';
//
// // ignore: must_be_immutable
// import 'package:flutter/material.dart';

class WCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final String? leadingImage;
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final bool centerTitle;
  final bool showLeadingAutomatically;

  const WCustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.leadingImage,
    this.actions,
    this.backgroundColor = AppColors.backgroundP,
    this.elevation = 0,
    this.padding,
    this.centerTitle = true,
    this.showLeadingAutomatically = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final shouldShowLeading = (leading != null || leadingImage != null) &&
        (!showLeadingAutomatically || canPop);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _getSystemUiOverlayStyle(),
      child: Material(
        color: backgroundColor,
        elevation: elevation,
        child: SafeArea(
          bottom: false,
          child: Container(
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
            height: preferredSize.height,
            child: Stack(
              children: [
                // Leading - chap tomonda
                if (shouldShowLeading)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: _buildLeading(),
                  ),

                // Title - centerTitle ga qarab joylashadi
                if (title != null)
                  centerTitle
                      ? Positioned.fill(
                    child: Center(child: title!),
                  )
                      : Positioned(
                    left: shouldShowLeading ? 56 : 0, // leadingdan keyin joy
                    top: 0,
                    bottom: 0,
                    right: actions != null && actions!.isNotEmpty ? 56 : 0,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: title!,
                    ),
                  ),

                // Actions - o'ng tomonda
                if (actions != null && actions!.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SystemUiOverlayStyle _getSystemUiOverlayStyle() {
    final isLightBackground = backgroundColor == Colors.white ||
        backgroundColor == const Color(0xFFF2F2F7) ||
        backgroundColor == AppColors.backgroundP;

    return SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isLightBackground ? Brightness.dark : Brightness.light,
      statusBarBrightness: isLightBackground ? Brightness.light : Brightness.dark,
    );
  }

  Widget _buildLeading() {
    return Center(
      child: leading ??
          (leadingImage != null
              ? AppImage(path: leadingImage!)
              : const SizedBox.shrink()),
    );
  }
}