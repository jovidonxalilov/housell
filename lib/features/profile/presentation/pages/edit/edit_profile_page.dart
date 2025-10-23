import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/domain/entities/path_profile.dart';
import 'package:housell/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:housell/features/profile/presentation/bloc/profile_event.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';
import 'package:housell/features/profile/presentation/widgets/image_select.dart';

import '../../../../../core/dp/dp_injection.dart';
import '../../../domain/usecase/profile_usecase.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.id});

  final String id;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? file;
  ProfileBloc? _profileBloc;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();

  bool _isDataLoaded = false;

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  void _loadProfileData(ProfileModel profile) {
    if (!_isDataLoaded) {
      try {
        print('🔍 DEBUG: profile name = ${profile.name}');
        print('🔍 DEBUG: profile surname = ${profile.surname}');
        print('🔍 DEBUG: profile phone = ${profile.phone}');
        print('🔍 DEBUG: profile email = ${profile.email}');
        print('🔍 DEBUG: profile image = ${profile.image}');

        nameController.text = profile.name ?? '';
        surnameController.text = profile.surname ?? '';
        _isDataLoaded = true;
        print('✅ DEBUG: Ma\'lumotlar yuklandi');
      } catch (e) {
        print('❌ DEBUG: _loadProfileData xatolik: $e');
      }
    }
  }

  void _updateProfileWithImage(String name, String surname, String? imageUrl) {
    print('🔄 DEBUG: Profil yangilanmoqda...');
    print('🖼️ DEBUG: Image URL: $imageUrl');

    final profileModel = ProfileModel(
      name: name.isNotEmpty ? name : "",
      surname: surname.isNotEmpty ? surname : "",
      image: imageUrl ?? null, // Server dan kelgan URL yoki bo'sh string
    );

    print('🔍 DEBUG: ProfileModel yaratildi: ${profileModel.toString()}');

    _profileBloc!.add(
      ProfilePatchEvent(
        patchParams: ProfilePatchParams(
          id: widget.id,
          profileModel: profileModel,
        ),
        onFailure: () {
          print('❌ DEBUG: Profile yangilashda xatolik');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Ma'lumotlarni saqlashda xatolik")),
            );
          }
        },
        onSuccess: () {
          print('✅ DEBUG: Profile muvaffaqiyatli yangilandi');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Ma'lumotlar muvaffaqiyatli saqlandi")),
            );
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        _profileBloc = ProfileBloc(
          getIt<ProfileGetUsecase>(),
          getIt<ProfilePatchUsecase>(),
          getIt<ProfilePhotoUrlUsecase>(),
          getIt<ProfileNewPhoneOtpUsecase>(),
          getIt<ProfileNewPhoneVerifyOtpUsecase>(),
            getIt<ProfileNewPasswordUsecase>(),
            getIt<ProfileGetMyHousesUsecase>()
        )..add(ProfileGetMeEvent());
        return _profileBloc!;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        appBar: WCustomAppBar(
          backgroundColor: AppColors.backgroundP,
          title: AppText(
            text: "Edit profile",
            fontSize: 18,
            fontWeight: 400,
            color: AppColors.blackT,
          ),
          leading: AppText(
            onTap: () {
              context.pop();
            },
            text: "Cancel",
            fontSize: 18,
            fontWeight: 400,
            color: AppColors.primary,
          ),
          showLeadingAutomatically: true,
          actions: [
            AppText(
              onTap: () {
                try {
                  print('🔍 DEBUG: Done tugmasi bosildi');

                  // Validatsiya
                  if (nameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Ism kiritilishi shart")),
                    );
                    return;
                  }

                  final name = nameController.text.trim();
                  final surname = surnameController.text.trim();

                  print('🔍 DEBUG: name = $name');
                  print('🔍 DEBUG: surname = $surname');
                  print('🔍 DEBUG: file path = ${file?.path}');
                  print('🔍 DEBUG: widgets.id = ${widget.id}');

                  // Agar rasm tanlangan bo'lsa, avval rasmni yuklash
                  if (file != null) {
                    print('📤 DEBUG: Rasm yuklanmoqda...');

                    _profileBloc!.add(
                      ProfilePhotoUrlEvent(
                        photos: file!, // File obyekti
                        onSuccess: () {
                          print(
                            '✅ DEBUG: Rasm yuklandi, endi profil yangilanmoqda...',
                          );

                          // Rasm URL ni olish
                          final uploadedImageUrl =
                              _profileBloc!.state.uploadedPhotos?.secureUrl;
                          print(
                            '🔗 DEBUG: Yuklangan rasm URL: $uploadedImageUrl',
                          );

                          // Profil ma'lumotlarini yangilash
                          _updateProfileWithImage(
                            name,
                            surname,
                            uploadedImageUrl ?? _profileBloc!.state.profileModel!.image,
                          );
                          Duration(seconds: 3);
                          context.pop();
                        },
                        onFailure: () {
                          print('❌ DEBUG: Rasm yuklanmadi');
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Rasm yuklanmadi!")),
                            );
                          }
                        },
                      ),
                    );
                  } else {
                    // Rasm yo'q bo'lsa, to'g'ridan-to'g'ri profil yangilash
                    print(
                      '📝 DEBUG: Rasm yo\'q, faqat profil yangilanmoqda...',
                    );
                    _updateProfileWithImage(name, surname, null);
                    context.pop();
                  }
                } catch (e, stackTrace) {
                  print('❌ DEBUG: Done tugmasida xatolik: $e');
                  print('❌ DEBUG: StackTrace: $stackTrace');
                }
              },
              text: "Done",
              fontSize: 18,
              fontWeight: 400,
              color: AppColors.primary,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              try {
                print('🔍 DEBUG: BlocBuilder state = ${state.mainStatus}');

                if (state.mainStatus == MainStatus.loading) {
                  print('🔍 DEBUG: Loading holati');
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state.mainStatus == MainStatus.succes) {
                  print('🔍 DEBUG: Success holati');

                  final profile = state.profileModel;
                  if (profile == null) {
                    print('❌ DEBUG: profile null!');
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Center(
                        child: AppText(text: "Profile ma'lumoti null"),
                      ),
                    );
                  }

                  print('🔍 DEBUG: Profile topildi: ${profile.name}');
                  _loadProfileData(profile);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 24.h),
                      ProfileAvatar(
                        imageUrl: profile.image,
                        onImageSelected: (selectedFile) {
                          print(
                            '🔍 DEBUG: Yangi rasm tanlandi: ${selectedFile?.path}',
                          );
                          setState(() {
                            file = selectedFile;
                          });
                        },
                      ),

                      SizedBox(height: 20.h),

                      _buildTextField(
                        controller: nameController,
                        label: "Ism",
                        text: profile.name,
                        isFirst: true,
                      ),
                      SizedBox(height: 12.h),
                      _buildTextField(
                        controller: surnameController,
                        label: "Familiya",
                        text: profile.surname,
                      ),
                      SizedBox(height: 30.h),

                      _buildSettingsRow(
                        onTap: (){
                          context.push('/edit_phone_page/${profile.id}', extra: {
                            "phone": profile.phone.toString()
                          });
                        },
                        icon: AppAssets.sim,
                        title: "Number",
                        des: profile.phone ?? "qo'shilmagan",
                        isFirst: true,
                      ),
                      _buildSettingsRow(
                        icon: AppAssets.sim,
                        title: "Email",
                        des: profile.email ?? "qo'shilmagan",
                      ),
                      _buildSettingsRow(
                        onTap: () {
                          context.push('/new_password/${profile.id}');
                        },
                        icon: AppAssets.unlock,
                        title: "Password",
                        des: "••••••••",
                        isLast: true,
                      ),
                      SizedBox(height: 50.h),
                    ],
                  );
                }

                if (state.mainStatus == MainStatus.failure) {
                  print('❌ DEBUG: Failure holati');
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppText(text: "Ma'lumot topilmadi"),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              _profileBloc!.add(ProfileGetMeEvent());
                            },
                            child: Text("Qayta urinish"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                print('❌ DEBUG: Noma\'lum holat');
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(
                    child: AppText(text: "Iltimos qayta urinib ko'ring"),
                  ),
                );
              } catch (e, stackTrace) {
                print('❌ DEBUG: BlocBuilder da xatolik: $e');
                print('❌ DEBUG: StackTrace: $stackTrace');
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Center(child: AppText(text: "Xatolik: $e")),
                );
              }
            },
          ),
        ).paddingOnly(left: 24, right: 24),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? text,
    bool isFirst = false,
  }) {
    try {
      return WTextField(
        controller: controller,
        hintText: label,
        borderColor: AppColors.lightSky,
        fillColor: AppColors.white,
        borderRadius: 8,
        text: text,
        autoPrefix998: false,
      );
    } catch (e) {
      print('❌ DEBUG: _buildTextField xatolik: $e');
      return Container(
        height: 50,
        child: Center(child: Text('TextField xatolik: $e')),
      );
    }
  }

  Widget _buildSettingsRow({
    required String icon,
    required String title,
    required String des,
    VoidCallback? onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    try {
      return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            SizedBox(height: 6.h),
            Row(
              children: [
                AppImage(path: icon, size: 20),
                SizedBox(width: 12.w),
                Expanded(
                  child: AppText(text: title, fontSize: 16, fontWeight: 400),
                ),
                AppText(
                  text: des,
                  fontWeight: 400,
                  fontSize: 16,
                  color: AppColors.textMuted,
                  textAlign: TextAlign.end,
                ),
                SizedBox(width: 8.w),
                AppImage(path: AppAssets.chevronRight, size: 20),
              ],
            ),
            SizedBox(height: 8.h),
            if (!isLast) Divider(color: AppColors.bg, thickness: 1.5),
          ],
        ),
      );
    } catch (e) {
      print('❌ DEBUG: _buildSettingsRow xatolik: $e');
      return Container(
        height: 50,
        child: Center(child: Text('SettingsRow xatolik: $e')),
      );
    }
  }
}
