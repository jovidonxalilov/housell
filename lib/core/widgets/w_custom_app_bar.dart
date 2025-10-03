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
    this.backgroundColor,
    this.elevation = 0,
    this.padding,
    this.centerTitle = true,
    this.showLeadingAutomatically = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();

    return Material(
      color: backgroundColor,
      elevation: elevation,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Container(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24),
          height: preferredSize.height,
          child: Stack(
            children: [
              // Leading (chap taraf)
              if ((leading != null || leadingImage != null) &&
                  (!showLeadingAutomatically || canPop))
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: leading ??
                        (leadingImage != null
                            ? AppImage(path: leadingImage!)
                            : const SizedBox.shrink()),
                  ),
                ),

              // Actions (o'ng taraf)
              if (actions != null && actions!.isNotEmpty)
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: actions!,
                    ),
                  ),
                ),

              // Title - centerTitle true bo'lsa markazda, false bo'lsa leadingdan keyin
              if (title != null)
                centerTitle
                    ? Positioned.fill(
                  child: Center(
                    child: title!,
                  ),
                )
                    : Positioned(
                  left: (leading != null || leadingImage != null) &&
                      (!showLeadingAutomatically || canPop)
                      ? 56 // Leading elementdan keyin joy qoldirish
                      : 0,
                  top: 0,
                  bottom: 0,
                  child: Align(
                    alignment: Alignment.centerLeft,
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
