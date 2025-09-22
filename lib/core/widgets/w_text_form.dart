import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/phone_formatter.dart';
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
  final String? prefixIconOnePath; // masalan: current location icon
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
  final Color? fillColor;
  final Color? borderColor;
  final Color? cursorColor;
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
    this.fillColor = AppColors.white,
    this.borderColor,
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

  // bool _showClear = false;
  // bool _isPrefixTapped = false;

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
      // Faqat raqam tekshiruvi
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
    final borderColor = widget.hasError
        ? Theme.of(context).colorScheme.error
        : isFocused
        ? (widget.borderColor ?? AppColors.bg)
        : AppColors.bg;
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
              color: AppColors.black,
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
          cursorColor: widget.cursorColor ?? AppColors.black,
          textAlign: widget.textAlign,
          style:
              widget.textStyle ??
              TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          validator:
              widget.validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return widget.errorText;
                }
                return null;
              },
          inputFormatters: widget.inputFormatters,
          decoration: InputDecoration(
            filled: true,
            fillColor: widget.fillColor,
            contentPadding:
                widget.contentPadding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            hint: Align(
              alignment: widget.hintTextAlign,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: widget.hintText,
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    ?widget.richText
                        ? TextSpan(
                            text: ' *',
                            style: TextStyle(
                              color: AppColors.red,
                              fontSize: 16,
                            ),
                          )
                        : null,
                  ],
                ),
              ),
            ),
            hintStyle:
                widget.hintStyle ??
                TextStyle(
                  color: AppColors.textGrey,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
            prefixIcon: widget.prefixImage != null
                ? AppImage(
                    size: 20,
                    path: widget.prefixImage!,
                    onTap: () {},
                    color: AppColors.grey300,
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
                        color: AppColors.grey300,
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
                                  ),
                                ],
                              )
                            : null)),
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: AppColors.divider, width: 2),
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
                color: Theme.of(context).colorScheme.error,
                width: 1.2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget? _buildSuffixIcon() {
  //   if (widget.hasClearButton && _showClear) {
  //     return IconButton(
  //       icon: const Icon(Icons.clear, size: 20),
  //       onPressed: () {
  //         widget.controller?.clear();
  //         setState(() => _showClear = false);
  //         widget.onClearTap?.call();
  //       },
  //     );
  //   }
  //   return widget.suffixIcon;
  // }

  // Widget? _buildPrefixIcon() {
  //   if (widget.prefixIconOnePath != null && widget.prefixIconTwoPath != null) {
  //     return IconButton(
  //       onPressed: () {
  //         setState(() {
  //           _isPrefixTapped = !_isPrefixTapped;
  //         });
  //       },
  //       icon: SvgPicture.asset(
  //         _isPrefixTapped
  //             ? widget.prefixIconTwoPath!
  //             : widget.prefixIconOnePath!,
  //         key: ValueKey(_isPrefixTapped),
  //         color: AppColors.grey100,
  //       ),
  //     );
  //   }
  //   return widget.prefixIcon;
  // }
}
