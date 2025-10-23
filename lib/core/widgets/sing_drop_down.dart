import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_colors.dart';
import '../constants/app_assets.dart';
import 'app_image.dart';

class SingleFieldDropdown extends StatefulWidget {
  final Color? borderColor;
  final double borderRadius;
  final bool hasError;
  final ValueNotifier<String?> controller;
  final String hintText;
  final String? initialValue;
  final bool richText;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final List<String> options;

  const SingleFieldDropdown({

    this.initialValue,
    this.borderRadius = 8,
    this.borderColor,
    this.onChanged,
    this.validator,
    this.hasError = false,
    required this.hintText,
    this.richText = false,
    required this.options,
    required this.controller,
  });

  @override
  State<SingleFieldDropdown> createState() => _SingleFieldDropdownState();
}

class _SingleFieldDropdownState extends State<SingleFieldDropdown> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;
    final borderColor = widget.hasError
        ? Theme.of(context).colorScheme.error
        : isFocused
        ? (widget.borderColor ?? AppColors.primary)
        : AppColors.divider;

    return ValueListenableBuilder<String?>(
      valueListenable: widget.controller,
      builder: (context, selectedValue, child) {
        return DropdownButtonFormField<String>(
          value: selectedValue,
          focusNode: _focusNode,
          dropdownColor: AppColors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(color: borderColor, width: 1.4),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.2,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.4,
              ),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: AppColors.textGrey,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          icon: AppImage(path: AppAssets.chevronBottom),
          onChanged: (value) {
            widget.controller.value = value; // Controller ga qiymat berish
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          items: widget.options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: Text(
                option,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.darkest,
                ),
              ),
            );
          }).toList(),
          validator: widget.validator,
        );
      },
    );
  }
}
// Widget class ham kerak bo'ladi
// class SingleFieldDropdown extends StatefulWidget {
//   final String hintText;
//   final List<String> options;
//   final String? initialValue;
//   final Function(String?)? onChanged;
//   final String? Function(String?)? validator;
//   final bool hasError;
//   final Color? borderColor;
//   final double borderRadius;
//
//   const SingleFieldDropdown({
//     Key? key,
//     required this.hintText,
//     required this.options,
//     this.initialValue,
//     this.onChanged,
//     this.validator,
//     this.hasError = false,
//     this.borderColor,
//     this.borderRadius = 8.0,
//   }) : super(key: key);
//
//   @override
//   _SingleFieldDropdownState createState() => _SingleFieldDropdownState();
// }

// Ishlatish misoli
// class ExampleUsage extends StatelessWidget {
//   final List<String> countries = ['Uzbekistan', 'Kazakhstan', 'Kyrgyzstan', 'Tajikistan'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           children: [
//             SizedBox(height: 100),
//             SingleFieldDropdown(
//               hintText: "Select country",
//               options: countries,
//               initialValue: null, // Yoki 'Uzbekistan'
//               onChanged: (value) {
//                 print('Selected: $value');
//               },
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please select a country';
//                 }
//                 return null;
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class CustomDropdown extends StatefulWidget {
  final double height;
  final double? width;
  final Color? borderColor;
  final double borderRadius;
  final bool hasError;
  final ValueNotifier<String?> controller;
  final String hintText;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final List<String> options;

  const CustomDropdown({
    Key? key,
    this.height = 30,
    this.width,
    this.borderRadius = 8,
    this.borderColor,
    this.onChanged,
    this.validator,
    this.hasError = false,
    required this.hintText,
    required this.options,
    required this.controller,
  }) : super(key: key);

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  final FocusNode _focusNode = FocusNode();
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _closeDropdown();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isOpen) {
      _closeDropdown();
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;

    if (!mounted) return; // State yo‘q bo‘lsa, hech narsa qilmang

    // Agar hozir build/animation fazasida bo‘lsak, keyingi freymda bajaramiz
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() => _isOpen = false);
      }
    });
  }


  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: widget.width ?? size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, widget.height + 2),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: Colors.white,
            child: Container(
              constraints: BoxConstraints(
                maxHeight: 200,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: widget.options.length,
                itemBuilder: (context, index) {
                  final option = widget.options[index];
                  final isSelected = widget.controller.value == option;
                  return InkWell(
                    onTap: () {
                      widget.controller.value = option;
                      if (widget.onChanged != null) {
                        widget.onChanged!(option);
                      }
                      _closeDropdown();
                      _focusNode.unfocus();
                    },
                    child: Container(
                      height: 40,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus || _isOpen;
    final borderColor = widget.hasError
        ? Theme.of(context).colorScheme.error
        : isFocused
        ? (widget.borderColor ?? Colors.blue)
        : Colors.grey.shade400;

    return CompositedTransformTarget(
      link: _layerLink,
      child: Container(
        color: AppColors.bg,
        height: widget.height,
        width: widget.width,
        child: ValueListenableBuilder<String?>(
          valueListenable: widget.controller,
          builder: (context, selectedValue, child) {
            return GestureDetector(
              onTap: _toggleDropdown,
              child: Focus(
                focusNode: _focusNode,
                child: Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(
                      color: borderColor,
                      width: isFocused ? 1.4 : 1.0,
                    ),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedValue ?? widget.hintText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: selectedValue != null
                                ? Colors.black87
                                : Colors.grey.shade600,
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _isOpen ? 0.5 : 0,
                        duration: Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey.shade600,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
