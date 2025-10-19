import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/dp/dp_injection.dart';
import '../../domain/usecase/profile_usecase.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(
        getIt<ProfileGetUsecase>(),
        getIt<ProfilePatchUsecase>(),
        getIt<ProfilePhotoUrlUsecase>(),
        getIt<ProfileNewPhoneOtpUsecase>(),
        getIt<ProfileNewPhoneVerifyOtpUsecase>(),
        getIt<ProfileNewPasswordUsecase>(),
        getIt<ProfileGetMyHousesUsecase>(),
      )..add(ProfileGetMeEvent()),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        appBar: WCustomAppBar(
          backgroundColor: AppColors.backgroundP,
          title: AppText(text: "Profile", fontSize: 18, fontWeight: 400),
          actions: [
            AppImage(
              path: AppAssets.settings,
              onTap: () {
                context.push(Routes.settings);
              },
            ),
          ],
          showLeadingAutomatically: false,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.mainStatus == MainStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state.mainStatus == MainStatus.succes) {
              final profile = state.profileModel;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header with profile info
                    ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child:
                            profile?.image != null && profile!.image!.isNotEmpty
                            ? AppImage(
                                path: profile.image!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey[600],
                              ),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Name and Phone
                    AppText(text: "Jovidon Xalilov"),
                    AppText(
                      text: '${profile!.name} ${profile.surname}',
                      fontWeight: 700,
                      fontSize: 24,
                      color: AppColors.lightIcon,
                    ),
                    SizedBox(height: 12.h),
                    AppText(
                      text: profile.phone.toString(),
                      fontWeight: 400,
                      fontSize: 16,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(height: 12.h),

                    // Edit Profile Button
                    ContainerW(
                      onTap: () {
                        context.push('/edit_profile/${profile.id}');
                      },
                      width: 231.w,
                      height: 42.h,
                      color: AppColors.white,
                      borderColor: AppColors.base,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppImage(path: AppAssets.pencil),
                          SizedBox(width: 8.w),
                          AppText(
                            text: "Edit Profile",
                            fontSize: 14,
                            fontWeight: 600,
                            color: AppColors.base,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),

                    // Status
                    ContainerW(
                      width: double.infinity.h,
                      // height: 148.h,
                      color: AppColors.white,
                      radius: 16,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF141414).withOpacity(0.08),
                          offset: Offset(0, 0),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                        // Ikkinchi shadow (Shadow/Small)
                        BoxShadow(
                          color: const Color(0xFF141414).withOpacity(0.04),
                          // #141414 4%
                          offset: const Offset(0, 1),
                          // X=0, Y=1
                          blurRadius: 1,
                          // Blur = 1
                          spreadRadius: 0, // Spread = 0
                        ),
                      ],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(AppAssets.houses, '3', 'Listed'),
                          _buildStatCard(AppAssets.check, '1', 'Sold'),
                          _buildStatCard(
                            AppAssets.calendar,
                            '2025',
                            'Member Since',
                          ),
                        ],
                      ).paddingAll(20),
                    ),

                    SizedBox(height: 24.h),

                    // Account Balance
                    ContainerW(
                      color: AppColors.base.withOpacity(0.2),
                      radius: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: 'Account Balance',
                                fontSize: 16,
                                fontWeight: 500,
                                // color: AppColors.base,
                              ),
                              SizedBox(height: 4.h),
                              AppText(
                                text: '56.29',
                                fontWeight: 700,
                                fontSize: 24,
                                // color: AppColors.base,
                              ),
                              SizedBox(height: 4.h),
                              AppText(
                                text: 'USD available',
                                fontSize: 16,
                                fontWeight: 400,
                                // color: AppColors.base,
                              ),
                            ],
                          ),
                          ContainerW(
                            width: 48.w,
                            height: 48.h,
                            color: AppColors.lightest,
                            radius: 24,
                            child: Center(
                              child: AppImage(path: AppAssets.koshelok),
                            ),
                          ),
                        ],
                      ).paddingAll(20),
                    ),
                    SizedBox(height: 24.h),

                    // Menu Items
                    ContainerW(
                      color: AppColors.white,
                      radius: 16,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF141414).withOpacity(0.08),
                          offset: Offset(0, 0),
                          blurRadius: 8,
                          spreadRadius: 0,
                        ),
                        // Ikkinchi shadow (Shadow/Small)
                        BoxShadow(
                          color: const Color(0xFF141414).withOpacity(0.04),
                          // #141414 4%
                          offset: const Offset(0, 1),
                          // X=0, Y=1
                          blurRadius: 1,
                          // Blur = 1
                          spreadRadius: 0, // Spread = 0
                        ),
                      ],
                      child: Column(
                        children: [
                          _buildMenuItem(AppAssets.housee, 'My Properties'),
                          _buildMenuItem(AppAssets.hearth, 'Saved Properties'),
                          _buildMenuItem(AppAssets.add, 'Top Up Balance'),
                          _buildMenuItem(AppAssets.paperclip, 'Promocodes'),
                          _buildMenuItem(AppAssets.text, 'Transaction History'),
                          _buildMenuItem(
                            AppAssets.check,
                            'Verification',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ).paddingOnly(top: 50, right: 24, left: 24),
              );
            } else {
              if (state.mainStatus == MainStatus.failure) {
                return Center(child: AppText(text: "maumot kelmadi"));
              }
            }

            return Center(child: AppText(text: "maumot topilmadi"));
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String icon, String value, String label) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: AppColors.base.withOpacity(0.2),
          ),
          child: Center(
            child: AppImage(path: icon, size: 24, color: AppColors.base),
          ),
        ),
        SizedBox(height: 8.h),
        AppText(
          text: value,
          fontWeight: 700,
          fontSize: 20,
          color: AppColors.blackT,
        ),
        SizedBox(height: 8.h),
        AppText(
          text: label,
          fontWeight: 400,
          fontSize: 12,
          color: AppColors.textLight,
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    String icon,
    String title, {
    bool isLast = false,
    VoidCallback? onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: AppColors.bgLight, width: 1)),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            ContainerW(
              width: 40,
              height: 40,
              color: AppColors.base.withOpacity(0.2),
              radius: 24,
              child: Center(
                child: AppImage(path: icon, color: AppColors.base, size: 24),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppText(
                text: title,
                fontWeight: 500,
                fontSize: 16,
                color: AppColors.blackT,
              ),
            ),
            AppImage(path: AppAssets.chevronRight, size: 24),
          ],
        ),
      ),
    );
  }
}
