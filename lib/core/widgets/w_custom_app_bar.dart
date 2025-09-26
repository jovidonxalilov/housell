import 'package:flutter/material.dart';
import 'package:housell/core/extensions/widget_extension.dart';

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
  final Color backgroundColor;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  final bool centerTitle;
  bool automaticallyImplyLeading;

  WCustomAppBar({
    super.key,
    this.leading,
    this.title,
    this.leadingImage,
    this.actions,
    this.backgroundColor = Colors.white,
    this.elevation = 0,
    this.padding,
    this.centerTitle = true,
    this.automaticallyImplyLeading = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      elevation: elevation,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          padding: padding ?? const EdgeInsets.only(left: 24, right: 24),
          height: preferredSize.height,
          child: Stack(
            children: [
              // Leading widget (chap tomon)
              if (leading != null || leadingImage != null)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: leading != null
                        ? leading!
                        : (leadingImage != null
                        ? AppImage(path: leadingImage!)
                        : const SizedBox.shrink()),
                  ),
                ),

              // Actions widget (o'ng tomon)
              if (actions != null && actions!.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    ),
                  ),
                ),

              // Title widget (har doim centerda)
              if (title != null)
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: title!,
                  ),
                ),
            ],
          ),
        ),
      ),
    ).paddingOnly(top: 44);
  }
}

