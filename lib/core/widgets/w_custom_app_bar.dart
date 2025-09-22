import 'package:flutter/material.dart';
import 'package:housell/core/extensions/widget_extension.dart';

import 'app_image.dart';

// ignore: must_be_immutable
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
    this.centerTitle = true, // Default true qilib qo'ydim
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
          child: Row(
            children: [
              if (leading != null || leadingImage != null)
                SizedBox(
                  width: 50,
                  child: leading != null
                      ? Align(
                    alignment: Alignment.centerLeft,
                    child: leading!,
                  )
                      : (leadingImage != null
                      ? Align(
                    alignment: Alignment.centerLeft,
                    child: AppImage(path: leadingImage!),
                  )
                      : null),
                ),
              Expanded(
                child: title != null
                    ? Container(
                  alignment: centerTitle && (leading != null || leadingImage != null)
                      ? Alignment.center
                      : Alignment.centerLeft,
                  child: title!,
                )
                    : const SizedBox.shrink(),
              ),
              SizedBox(
                width: 50,
                child: actions != null && actions!.isNotEmpty
                    ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: actions!,
                )
                    : null,
              ),
            ],
          ),
        ),
      ),
    ).paddingOnly(top: 44);
  }
}