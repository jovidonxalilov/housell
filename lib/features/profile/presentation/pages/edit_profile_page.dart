import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/domain/entities/path_profile.dart';
import 'package:housell/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:housell/features/profile/presentation/bloc/profile_event.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';
import 'package:housell/features/profile/presentation/widgets/image_select.dart';

import '../../../../core/dp/dp_injection.dart';
import '../../domain/usecase/profile_usecase.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? file;
  final TextEditingController nameController = TextEditingController();


  final TextEditingController surnameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController(
    text: "muhammadali@g...",
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(getIt<ProfileGetUsecase>(), getIt<ProfilePatchUsecase>())
            ..add(ProfileGetMeEvent()),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state.mainStatus == MainStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.mainStatus == MainStatus.succes) {
            final profile = state.profileModel!;
            return Scaffold(
              backgroundColor: AppColors.white,
              appBar: WCustomAppBar(
                title: AppText(
                  text: "Edit profile",
                  fontSize: 18,
                  fontWeight: 400,
                  color: AppColors.blackT,
                ),
                leading: AppText(
                  text: "Cancel",
                  fontSize: 18,
                  fontWeight: 400,
                  color: AppColors.base,
                ),
                actions: [
                  AppText(
                    onTap: () {
                      // context.read<ProfileBloc>()..add(
                      //   ProfilePatchEvent(
                      //     patchParams: ProfilePatchParams(
                      //       id: state.profileModel!.id.toString(),
                      //       profileModel: ProfileModel(
                      //         name: nameController.text,
                      //         surname: surnameController.text,
                      //         phone: phoneController.text,
                      //         image: file.path,
                      //       ),
                      //     ),
                      //     onFailure: () {},
                      //     onSuccess: () {},
                      //   ),
                      // );
                    },
                    text: "Done",
                    fontSize: 18,
                    fontWeight: 400,
                    color: AppColors.base,
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state.mainStatus == MainStatus.loading) {
                      return Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (state.mainStatus == MainStatus.succes) {
                      final profile = state.profileModel!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Profil rasmi bo'limi
                          SizedBox(height: 24.h),
                          ProfileAvatar(
                            imageUrl: state.profileModel?.image,
                            // backenddan kelgan rasm
                            onImageSelected: (selectedFile) {
                              file = selectedFile; // vaqtincha saqlab qo‘yamiz
                            },
                          ),

                          SizedBox(height: 20.h),

                          // Ma'lumotlar bo'limi
                          _buildTextField(
                            controller: nameController,
                            text: profile!.name,
                            label: "Ism",
                            isFirst: true,
                          ),
                          SizedBox(height: 12.h),
                          _buildTextField(
                            controller: surnameController,
                            label: "Familiya",
                            text: profile.surname,
                          ),
                          SizedBox(height: 12.h),
                          _buildTextField(
                            controller: bioController,
                            label: "Bio",
                            placeholder:
                                "Tell us about yourself (up to 100 characters)",
                            isLast: true,
                          ),
                          SizedBox(height: 12.h),
                          AppText(
                            text:
                                "Tell us about yourself (up to 500 characters)",
                            fontSize: 12,
                            fontWeight: 400,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(height: 30),

                          // Sozlamalar bo'limi
                          _buildSettingsRow(
                            icon: AppAssets.language,
                            title: "Languages",
                            isFirst: true,
                          ),
                          _buildSettingsRow(
                            icon: AppAssets.link,
                            title: "Social links",
                          ),
                          _buildSettingsRow(
                            icon: AppAssets.sim,
                            title: "Number",
                            isFirst: true,
                          ),
                          _buildSettingsRow(
                            icon: AppAssets.sim,
                            title: "Email",
                            isFirst: true,
                          ),
                          _buildSettingsRow(
                            icon: AppAssets.unlock,
                            title: "Password",
                            isLast: true,
                          ),
                          SizedBox(height: 50),
                        ],
                      );
                    } else {
                      if (state.mainStatus == MainStatus.failure) {
                        return Scaffold(
                          body: Center(
                            child: AppText(text: "Malumot Topilmadi"),
                          ),
                        );
                      }
                    }
                    return Scaffold(
                      body: Center(
                        child: AppText(text: "Iltimos qayta urinib ko'ring"),
                      ),
                    );
                  },
                ),
              ).paddingOnly(left: 24, right: 24),
            );
          } else {
            if (state.mainStatus == MainStatus.failure) {
              return Center(child: AppText(text: "Malumot Topilmadi"));
            }
          }
          return Center(child: AppText(text: "Iltimos qayta urinib ko'ring"));
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? placeholder,
    String? text,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return WTextField(
      controller: controller,
      hintText: label,
      borderColor: AppColors.bgLight,
      borderRadius: 8,
      text: text,
      autoPrefix998: true,
    );
  }

  Widget _buildSettingsRow({
    required String icon,
    required String title,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Column(
      children: [
        SizedBox(height: 6),
        Row(
          children: [
            AppImage(path: icon, size: 20),
            SizedBox(width: 12),
            Expanded(
              child: AppText(text: title, fontSize: 16, fontWeight: 400),
            ),
            AppImage(path: AppAssets.chevronRight, size: 20),
          ],
        ),
        SizedBox(height: 8.h),
        Divider(color: AppColors.bg, thickness: 1.5),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.only(left: 0),
      height: 0.5,
      color: Colors.grey[300],
    );
  }
}
