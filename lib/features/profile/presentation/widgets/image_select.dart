import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class ProfileAvatar extends StatefulWidget {
  final String? imageUrl; // Backenddan keladigan rasm URL
  final void Function(File?)? onImageSelected; // Tanlangan rasmni parentga qaytaradi

  const ProfileAvatar({
    Key? key,
    this.imageUrl,
    this.onImageSelected,
  }) : super(key: key);

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _imageFile = file;
      });

      // File-ni parentga yuboramiz, lekin backendga darrov jo‘natmaymiz
      widget.onImageSelected?.call(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;

    if (_imageFile != null) {
      imageProvider = FileImage(_imageFile!); // Tanlangan yangi rasm
    } else if (widget.imageUrl != null && widget.imageUrl!.isNotEmpty) {
      imageProvider = NetworkImage(widget.imageUrl!); // Backenddan kelgan rasm
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage: imageProvider,
          child: imageProvider == null
              ? Icon(Icons.person, size: 60, color: Colors.grey[600])
              : null,
        ),
        SizedBox(height: 8),
        AppText(
          onTap: _pickImage,
          text: "Set New Photo",
          fontWeight: 400,
          fontSize: 16,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
