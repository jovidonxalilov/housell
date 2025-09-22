import 'dart:math' as math;

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'dart:io';

import 'package:housell/core/widgets/w__container.dart';

class ImagePickerWidget extends StatefulWidget {
  // Tashqaridan callback orqali rasmlarni olish uchun
  final Function(List<File>)? onImagesSelected;

  // Validatsiya callback - rasmlar soni yetarlimi
  final Function(bool isValid)? onValidationChanged;

  const ImagePickerWidget({
    Key? key,
    this.onImagesSelected,
    this.onValidationChanged,
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ValueNotifier<List<File>> selectedImagesNotifier =
      ValueNotifier<List<File>>([]);
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Boshlang'ich validatsiya
    _checkValidation();
  }

  @override
  void dispose() {
    selectedImagesNotifier.dispose();
    super.dispose();
  }

  // Validatsiya tekshirish
  void _checkValidation() {
    bool isValid = selectedImagesNotifier.value.length >= 3;
    widget.onValidationChanged?.call(isValid);
  }

  Future<void> _pickMultipleImages() async {
    try {
      // To‘g‘ridan-to‘g‘ri galereyadan ko‘p rasm tanlash
      final List<XFile>? images = await _picker.pickMultiImage();

      if (images != null && images.isNotEmpty) {
        List<File> currentImages = List.from(selectedImagesNotifier.value);
        for (XFile image in images) {
          currentImages.add(File(image.path));
        }
        selectedImagesNotifier.value = currentImages;

        // Callback orqali tashqariga rasmlarni jo'natish
        widget.onImagesSelected?.call(currentImages);

        // Validatsiya tekshirish
        _checkValidation();

        // Muvaffaqiyatli xabar
        _showSuccessMessage(images.length);
      }
    } catch (e) {
      _showErrorMessage('Rasmlarni yuklashda xatolik yuz berdi');
      print('Xatolik: $e');
    }
  }

  // Rasmni o'chirish
  void _removeImage(int index) {
    List<File> currentImages = List.from(selectedImagesNotifier.value);
    currentImages.removeAt(index);
    selectedImagesNotifier.value = currentImages;

    // Callback orqali yangilangan ro'yxatni jo'natish
    widget.onImagesSelected?.call(currentImages);

    // Validatsiya tekshirish
    _checkValidation();
  }

  // Barcha rasmlarni o'chirish
  // void _clearAllImages() {
  //   selectedImagesNotifier.value = [];
  //
  //   // Callback orqali bo'sh ro'yxatni jo'natish
  //   widget.onImagesSelected?.call([]);
  //
  //   // Validatsiya tekshirish
  //   _checkValidation();
  // }

  // Muvaffaqiyat xabari
  void _showSuccessMessage(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count ta rasm qo\'shildi'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Xatolik xabari
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            text: "Add Photos",
            color: AppColors.black,
            fontWeight: 700,
            fontSize: 20,
          ),
          SizedBox(height: 8.h),
          AppText(
            text: "Add at least one photo of your property",
            color: AppColors.light,
            fontWeight: 400,
            fontSize: 16,
          ),
          SizedBox(height: 24.h),
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              radius: Radius.circular(16),
              color: AppColors.base,
              strokeWidth: 2,
              dashPattern: [6, 4],
              padding: EdgeInsets.all(2),
            ),
            child: ContainerW(
              width: double.infinity.w,
              height: 225.h,
              radius: 16,
              color: AppColors.base.withOpacity(0.2),
              onTap: _pickMultipleImages,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppImage(path: AppAssets.camera),
                  SizedBox(height: 12.h),
                  AppText(
                    text: "Add Photos",
                    color: AppColors.base,
                    fontWeight: 600,
                    fontSize: 18,
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 16),
          // ValueListenableBuilder<List<File>>(
          //   valueListenable: selectedImagesNotifier,
          //   builder: (context, selectedImages, child) {
          //     final int remainingImages = math.max(
          //       0,
          //       3 - selectedImages.length,
          //     );
          //     final bool isValid = selectedImages.length >= 3;
          //
          //     return Column(
          //       children: [
          //         // Status matn va clear tugmasi
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Expanded(
          //               child: Text(
          //                 selectedImages.isEmpty
          //                     ? 'Hali rasm tanlanmagan'
          //                     : isValid
          //                     ? '${selectedImages.length} rasm tanlangan ✓'
          //                     : '${selectedImages.length}/3 rasm - yana $remainingImages ta kerak',
          //                 style: TextStyle(
          //                   fontSize: 14,
          //                   color: isValid ? Colors.green : Colors.orange,
          //                   fontWeight: FontWeight.w500,
          //                 ),
          //               ),
          //             ),
          //             if (selectedImages.isNotEmpty)
          //               TextButton.icon(
          //                 onPressed: _clearAllImages,
          //                 icon: const Icon(Icons.clear_all, size: 16),
          //                 label: const Text('Tozalash'),
          //                 style: TextButton.styleFrom(
          //                   foregroundColor: Colors.red,
          //                 ),
          //               ),
          //           ],
          //         ),

          //         // Validatsiya ko'rsatkichi
          //         if (selectedImages.isNotEmpty && !isValid)
          //           Container(
          //             margin: const EdgeInsets.only(top: 8),
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: 12,
          //               vertical: 8,
          //             ),
          //             decoration: BoxDecoration(
          //               color: Colors.orange.withOpacity(0.1),
          //               borderRadius: BorderRadius.circular(8),
          //               border: Border.all(
          //                 color: Colors.orange.withOpacity(0.3),
          //               ),
          //             ),
          //             child: Row(
          //               children: [
          //                 Icon(
          //                   Icons.warning_amber,
          //                   color: Colors.orange,
          //                   size: 20,
          //                 ),
          //                 const SizedBox(width: 8),
          //                 Expanded(
          //                   child: Text(
          //                     'Davom etish uchun kamida 3 ta rasm tanlang',
          //                     style: TextStyle(
          //                       fontSize: 13,
          //                       color: Colors.orange.shade700,
          //                     ),
          //                   ),
          //                 ),
          //               ],
          //             ),
          //           ),
          //       ],
          //     );
          //   },
          // ),
          SizedBox(height: 24.h),

          // ValueListenableBuilder bilan tanlangan rasmlar grid
          ValueListenableBuilder<List<File>>(
            valueListenable: selectedImagesNotifier,
            builder: (context, selectedImages, child) {
              if (selectedImages.isEmpty) return const SizedBox.shrink();
              return Container(
                constraints: const BoxConstraints(maxHeight: 400),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              selectedImages[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -8,
                            right: -8,
                            child: ContainerW(
                              color: AppColors.base,
                              width: 32.w,
                              height: 32.h,
                              radius: 16,
                              child: Center(
                                child: AppImage(
                                  path: AppAssets.close,
                                  onTap: () => _removeImage(index),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Rasmlarni olish uchun getter method
  List<File> getSelectedImages() {
    return selectedImagesNotifier.value;
  }

  // Validatsiya tekshirish uchun getter
  bool isValid() {
    return selectedImagesNotifier.value.length >= 3;
  }
}

//
// // Bu widget'ni qanday ishlatish kerakligini ko'rsatuvchi misol
// class ParentWidget extends StatefulWidget {
//   @override
//   _ParentWidgetState createState() => _ParentWidgetState();
// }
//
// class _ParentWidgetState extends State<ParentWidget> {
//   final ValueNotifier<List<File>> selectedImagesNotifier = ValueNotifier<List<File>>([]);
//
//   @override
//   void dispose() {
//     selectedImagesNotifier.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Image Picker')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ImagePickerWidget(
//               onImagesSelected: (List<File> images) {
//                 selectedImagesNotifier.value = images; // Rasmlarni saqlaymiz
//                 print('Tanlangan rasmlar soni: ${images.length}');
//               },
//             ),
//             // ValueListenableBuilder bilan tugma
//             ValueListenableBuilder<List<File>>(
//               valueListenable: selectedImagesNotifier,
//               builder: (context, selectedImages, child) {
//                 if (selectedImages.isEmpty) return const SizedBox.shrink();
//
//                 return Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       // Bu yerda selectedImages ro'yxatini ishlatishingiz mumkin
//                       print('Rasmlar jo\'natilmoqda: ${selectedImages.length} ta rasm');
//                       // Masalan, serverga yuborish yoki boshqa ishlar
//                     },
//                     child: Text('Rasmlarni yuborish (${selectedImages.length})'),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
