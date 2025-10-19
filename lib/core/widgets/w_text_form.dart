import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import '../../config/theme/app_colors.dart';
import 'app_image.dart';
import 'app_text.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final bool readOnly;

  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        // label: AppText(text: "name").paddingOnly(top: 20),
        // labelStyle: TextStyle(
        //   color: Colors.grey[600],
        //   fontSize: 16,
        //   fontWeight: FontWeight.w400,
        // ),
        // floatingLabelStyle: TextStyle(
        //   color: Colors.purple,
        //   fontSize: 14,
        //   fontWeight: FontWeight.w500,
        // ),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: AppColors.bg,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        // contentPadding:
        //     const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.bgLight, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.bgLight,
            // width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.bgLight,
            // width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
            // width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
            // width: 2,
          ),
        ),
      ),
    );
  }
}

class WTextField extends StatefulWidget {
  final String? hintText;
  final String? errorText;
  final String? title;
  final String? prefixIconOnePath;
  final String? prefixIconTwoPath;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool isObscureText;
  final bool autoFocus;
  final bool readOnly;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final bool hasClearButton;
  final bool hasError;
  final Color? fillColor; // Agar berilmasa, tema rangini oladi
  final Color? borderColor; // Agar berilmasa, tema rangini oladi
  final Color? cursorColor; // Agar berilmasa, tema rangini oladi
  final Color? borderNoFocusColor; // Agar berilmasa, tema rangini oladi
  final double borderRadius;
  final Widget? prefixIcon;
  final bool suffixIcon;
  final EdgeInsets? contentPadding;
  final TextAlign textAlign;
  final Alignment hintTextAlign;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final bool autoPrefix998;
  final Widget? suffixIconWidget;
  final String? text;
  final String? suffixImage;
  final bool richText;
  final String? prefixImage;
  final String? Function(String?)? validator;
  final VoidCallback? onTap;
  final VoidCallback? suffixImageTap;
  final Function(String)? onChanged;
  final VoidCallback? onClearTap;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focusNode;

  const WTextField({
    this.errorText,
    super.key,
    this.hintText,
    this.title,
    this.prefixImage,
    this.text,
    this.suffixImage,
    this.autoPrefix998 = false,
    this.prefixIconOnePath,
    this.prefixIconTwoPath,
    this.controller,
    this.borderNoFocusColor = AppColors.lightSky,
    this.suffixIconWidget,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.isObscureText = false,
    this.autoFocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.richText = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.hasClearButton = false,
    this.hasError = false,
    this.fillColor = AppColors.backgroundP, // null bo'lsa tema rangini oladi
    this.borderColor, // null bo'lsa tema rangini oladi
    this.cursorColor,
    this.borderRadius = 8,
    this.prefixIcon,
    this.suffixIcon = false,
    this.contentPadding,
    this.textAlign = TextAlign.start,
    this.hintTextAlign = Alignment.centerLeft,
    this.textStyle,
    this.hintStyle,
    this.validator,
    this.onTap,
    this.suffixImageTap,
    this.onChanged,
    this.onClearTap,
    this.inputFormatters,
    this.focusNode,
  });

  @override
  State<WTextField> createState() => _WTextFieldState();
}

class _WTextFieldState extends State<WTextField> {
  late final FocusNode _focusNode;
  bool _obscureText = true;
  bool _hasUserStartedTyping = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });

    if (widget.autoPrefix998) {
      widget.controller?.addListener(_handleTextChange);
    }
    final controller = widget.controller;
    if (controller != null) {
      controller.text = widget.text ?? '';
      if (widget.autoPrefix998) {
        controller.addListener(_handleTextChange);
      }
    }
  }

  void _handleTextChange() {
    if (!widget.autoPrefix998) return;

    final text = widget.controller?.text;
    if (text == null) return;

    if (!_hasUserStartedTyping && text.isNotEmpty && !text.startsWith('+998')) {
      bool isNumeric = RegExp(r'^[0-9]+$').hasMatch(text);

      if (isNumeric) {
        _hasUserStartedTyping = true;
        final newText = '+998$text';
        widget.controller?.text = newText;
        widget.controller?.selection = TextSelection.fromPosition(
          TextPosition(offset: newText.length),
        );
        return;
      }
    }

    if (text.isEmpty) {
      _hasUserStartedTyping = false;
    }
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    // // Tema ranglarini olish
    // final theme = Theme.of(context);
    // final fillColor = widgets.fillColor ?? theme.inputDecorationTheme.fillColor ?? theme.cardColor;
    // final cursorColor = widgets.cursorColor ?? theme.colorScheme.primary;
    // final hintColor = theme.inputDecorationTheme.hintStyle?.color ?? theme.hintColor;
    // final titleColor = theme.textTheme.titleMedium?.color ?? theme.colorScheme.onSurface;
    // final textColor = theme.textTheme.bodyLarge?.color ?? theme.colorScheme.onSurface;
    // final iconColor = theme.iconTheme.color ?? theme.colorScheme.onSurface;

    // Border rangi
    final borderColor = widget.hasError
        ? Theme.of(context).colorScheme.error
        : isFocused
        ? (widget.borderColor ?? AppColors.base)
        : widget.borderNoFocusColor ?? AppColors.white;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: AppText(
              text: widget.title!,
              fontSize: 16,
              fontWeight: 500,
              color: AppColors.black, // Tema rangini ishlatish
            ),
          ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: widget.suffixIcon ? _obscureText : false,
          autofocus: widget.autoFocus,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          maxLines: widget.isObscureText ? 1 : widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          cursorColor: widget.cursorColor, // Tema cursor rangi
          textAlign: widget.textAlign,
          style: widget.textStyle ?? TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.darkest, // Tema matn rangi
          ),
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          validator: widget.validator ?? (value) {
            if (value == null || value.isEmpty) {
              return widget.errorText;
            }
            return null;
          },
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor, // Tema fill rangi
            contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hint: Align(
              alignment: widget.hintTextAlign,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.hintText,
                      style: TextStyle(
                        color: AppColors.textLight, // Tema hint rangi
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (widget.richText)
                      TextSpan(
                        text: ' *',
                        style: TextStyle(
                          color: AppColors.red, // Tema error rangi
                          fontSize: 16,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            hintStyle: widget.hintStyle ?? TextStyle(
              // color: widget.hintColor, // Tema hint rangi
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            prefixIcon: widget.prefixImage != null
                ? AppImage(
              size: 20,
              path: widget.prefixImage!,
              onTap: () {},
              // color: , // Tema ikonka rangi
            ).paddingAll(16)
                : null,
            suffixIcon: widget.suffixIcon
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 15.w),
                AppImage(
                  onTap: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                  path: _obscureText ? AppAssets.eyeOff : AppAssets.eyeOn,
                  // color: widget.iconColor, // Tema ikonka rangi
                ),
              ],
            )
                : (widget.suffixIconWidget != null
                ? widget.suffixIconWidget!
                : (widget.suffixImage != null
                ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 15.w),
                AppImage(
                  path: widget.suffixImage!,
                  onTap: widget.suffixImageTap,
                  // color: widget.iconColor, // Tema ikonka rangi
                ),
              ],
            )
                : null)),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: borderColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: AppColors.red, // Tema error rangi
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: AppColors.red, // Tema error rangi
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

