import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/dp/dp_injection.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/home/domain/usecase/home_usecase.dart';
import 'package:housell/features/home/presentation/bloc/home_bloc.dart';
import 'package:housell/features/home/presentation/bloc/home_event.dart';
import 'package:housell/features/home/presentation/bloc/home_state.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../../../config/router/routes.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id, required this.userId});

  final String id;
  final String userId;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) =>
      HomeBloc(
        getIt<HomeGetHousesUsecase>(),
        getIt<HomeGetHousesIdUsecase>(),
        getIt<ProfileGetInformationUsecase>(),
      )
        ..add(HomeGetHousesIdEvent(id: widget.id))
        ..add(ProfileGetInformationEvent(id: widget.userId)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final property = state.datum;
            final user = state.profileModel;

            if (state.mainStatus == MainStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state.mainStatus == MainStatus.succes && property != null) {
              return Stack(
                children: [
                  /// Rasmlar vertical scroll
                  ListView.builder(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.3),
                    itemCount: property.photos.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          context.push(
                            Routes.imageViewer,
                            extra: {
                              'photos': property.photos,
                              'initialIndex': index,
                            },
                          );
                        },
                        child: Image.network(
                          property.photos[index].photo,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 300,
                              color: Colors.grey[300],
                              child: Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  /// AppBar (rasm ustida ko'rinadi)
                  Positioned(
                    top: -20,
                    left: 0,
                    right: 0,
                    child: WCustomAppBar(
                      backgroundColor: Colors.transparent,
                      leading: ContainerW(
                        width: 40,
                        height: 40,
                        color: AppColors.white,
                        child: Center(
                          child: AppImage(path: AppAssets.chevronLeft),
                        ),
                      ),
                      showLeadingAutomatically: false,
                      actions: [
                        ContainerW(
                          width: 40,
                          height: 40,
                          color: AppColors.white,
                          child: Center(
                            child: AppImage(path: AppAssets.share02),
                          ),
                        ),
                        SizedBox(width: 12.h),
                        ContainerW(
                          width: 40,
                          height: 40,
                          color: AppColors.white,
                          child: Center(
                            child: AppImage(path: AppAssets.hearth),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Bottom sheet
                  DraggableScrollableSheet(
                    initialChildSize: 0.3,
                    minChildSize: 0.3,
                    maxChildSize: (screenHeight - 88) / screenHeight,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.backgroundP,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, -2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 8),
                              child: Center(
                                child: Icon(
                                  Icons.drag_handle,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                            Expanded(
                              child: SingleChildScrollView(
                                controller: scrollController,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      spacing: 8.sp,
                                      children: [
                                        AppText(
                                          text: property.currency,
                                          fontSize: 24,
                                          fontWeight: 700,
                                        ),
                                        AppText(
                                          text: property.price.toString(),
                                          fontSize: 24,
                                          fontWeight: 700,
                                        ),
                                        AppText(
                                          text:
                                          "/ ${property.rentalFrequency.toDisplayText()}",
                                          color: AppColors.textMuted,
                                          fontWeight: 400,
                                          fontSize: 16,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        AppImage(
                                          path: AppAssets.bedroom,
                                          size: 16,
                                          color: AppColors.textMuted,
                                        ),
                                        SizedBox(width: 8.w),
                                        AppText(
                                          text: "${property.numberOfRooms} Ben",
                                          fontSize: 14,
                                          fontWeight: 400,
                                        ),
                                        SizedBox(width: 24.w),
                                        AppImage(
                                          path: AppAssets.bedroom,
                                          size: 16,
                                          color: AppColors.textMuted,
                                        ),
                                        SizedBox(width: 8.w),
                                        AppText(
                                          text:
                                          "${property.numberOfBathrooms} Baths",
                                          fontSize: 14,
                                          fontWeight: 400,
                                        ),
                                        SizedBox(width: 24.w),
                                        AppImage(
                                          path: AppAssets.bedroom,
                                          size: 16,
                                          color: AppColors.textMuted,
                                        ),
                                        SizedBox(width: 8.w),
                                        AppText(
                                          text: "${property.area} m2",
                                          fontSize: 14,
                                          fontWeight: 400,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    AppText(
                                      text: property.title,
                                      fontSize: 16,
                                      fontWeight: 500,
                                    ),
                                    SizedBox(height: 24.h),
                                    Row(
                                      children: [
                                        ContainerW(
                                          radius: 8,
                                          // width: 155.w,
                                          height: 36.h,
                                          color: AppColors.primary.withOpacity(0.2),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              AppImage(
                                                path: AppAssets.play,
                                                color: AppColors.primary,
                                              ),
                                              AppText(
                                                text: "See Video",
                                                fontSize: 14,
                                                fontWeight: 500,
                                                color: AppColors.primary,
                                              ),
                                            ],
                                          ).paddingOnly(left: 31, right: 31),
                                        ),
                                        SizedBox(width: 16.w),
                                        ContainerW(
                                          radius: 8,
                                          // width: 155.w,
                                          height: 36.h,
                                          color: AppColors.primary.withOpacity(0.2),
                                          child: Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              AppText(
                                                text: "3d Tour",
                                                fontSize: 14,
                                                fontWeight: 500,
                                                color: AppColors.primary,
                                              ),
                                            ],
                                          ).paddingOnly(left: 51, right: 51),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 24.h),
                                    AppText(
                                      text: "About This Property",
                                      fontSize: 20,
                                      fontWeight: 700,
                                    ),
                                    SizedBox(height: 16.h),
                                    ContainerW(
                                      color: AppColors.primary.withOpacity(0.2),
                                      radius: 16,
                                      child: AppText(
                                        text: property.description,
                                        fontSize: 16,
                                        maxLines: 20,
                                        fontWeight: 400,
                                      ).paddingAll(17),
                                    ),
                                    SizedBox(height: 24.h),
                                    AppText(
                                      text: "Property Information",
                                      fontSize: 20,
                                      fontWeight: 700,
                                    ),
                                    SizedBox(height: 16.h),
                                    ContainerW(
                                      radius: 12,
                                      color: AppColors.white,
                                      child: Column(
                                        children: [
                                          _propertyInformation(
                                            "Property Type",
                                            property.buildingType,
                                          ),
                                          _propertyInformation(
                                            "Furnishing Status",
                                            property.furnishing,
                                          ),
                                          _propertyInformation(
                                            "Purpose",
                                            property.typeOfSale,
                                          ),
                                          _propertyInformation(
                                            "Rental Period",
                                            property.rentalFrequency,
                                          ),
                                          _propertyInformation(
                                            "Total Rooms",
                                            "${property.numberOfRooms} Rooms",
                                          ),
                                          _propertyInformation(
                                            "Floor",
                                            "${property.floor}nd Floor",
                                          ),
                                          _propertyInformation(
                                            "Total Floors",
                                            "${property.totalFloors} Floors",
                                          ),
                                        ],
                                      ).paddingAll(16),
                                    ),
                                    SizedBox(height: 24.h),
                                    ...property.locatedNear.map(
                                          (location) => _buildLocationItem(location),
                                    ),
                                    SizedBox(height: 24.h),

                                    // ✅ ASOSIY TUZATISH: Null check ni xavfsiz qiling
                                    if (property.user != null)
                                      property.user!.role == "CUSTOMER"
                                          ? _userProfileCard(property.user!)
                                          : (user != null
                                          ? _maklerProfileCard(user)
                                          : SizedBox.shrink())
                                    else
                                      SizedBox.shrink(),

                                    SizedBox(height: 24.h),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              );
            }

            if (state.mainStatus == MainStatus.failure) {
              return Center(child: AppText(text: "Malumot kelmadi"));
            }

            return Center(child: AppText(text: "Malumot mavjud emas"));
          },
        ),
        bottomNavigationBar: ContainerW(
          width: double.infinity.w,
          height: 62.h,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
          border: Border(top: BorderSide(color: AppColors.divider)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ContainerW(
                // width: 157.w,
                height: 44.h,
                radius: 8,
                borderColor: Colors.transparent,
                color: AppColors.backgroundMessageL,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(path: AppAssets.message),
                    SizedBox(width: 4.w),
                    AppText(text: "Message", fontSize: 16, fontWeight: 600),
                  ],
                ).paddingOnly(left: 31, right: 31),
              ),
              Spacer(),
              ContainerW(
                // width: 157.w,
                height: 44.h,
                radius: 8,
                color: AppColors.greenLighter,
                borderColor: Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(path: AppAssets.phone),
                    SizedBox(width: 4.w),
                    AppText(text: "Call", fontSize: 16, fontWeight: 600),
                  ],
                ).paddingOnly(left: 51, right: 51),
              ),
            ],
          ).paddingOnly(left: 24, right: 24, top: 12, bottom: 7),
        ),
      ),
    );
  }

  Widget _buildLocationItem(String location) {
    return ContainerW(
      width: double.infinity,
      height: 74.h,
      margin: EdgeInsets.only(bottom: 8.h),
      radius: 8,
      color: AppColors.white,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            ContainerW(
              width: 40.w,
              height: 40.h,
              color: AppColors.primary.withOpacity(0.1), // ✅ Icon uchun background
              child: Center(
                child: AppImage(
                  path: location.toLocatedNearSvg(),
                  size: 24, // ✅ Icon size
                  color: AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: AppText(
                text: location,
                fontSize: 14,
                fontWeight: 400,
                maxLines: 2,
                // ✅ Agar text uzun bo'lsa
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _propertyInformation(String type, String des) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: AppText(
                text: type,
                fontSize: 14,
                fontWeight: 400,
                color: AppColors.textMuted,
              ),
            ),
            AppText(text: des, fontSize: 14, fontWeight: 600),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(),
      ],
    );
  }

  Widget _maklerProfileCard(ProfileModel userModel) {
    return ContainerW(
      // padding: const EdgeInsets.all(20),
      // decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
      // ),
      child: Column(
        children: [
          // Profile section
          Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[100],
                ),
                child: ClipOval(
                  child: Image.network(
                    userModel.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.blue[300],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Name and role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: '${userModel.surname} ${userModel.name}',
                      fontWeight: 700,
                      fontSize: 18,
                    ),
                    SizedBox(height: 4),
                    const Text(
                      'Licensed Real Estate Broker',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    // Rating
                    Row(
                      children:  [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        SizedBox(width: 4),
                        Text(
                          userModel.rating.toString() ?? "2",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          '(127 reviews)',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Stats
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '150+',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF00BFA5),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Properties Listed',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Container(width: 1, height: 40, color: Colors.grey[300]),
              Expanded(
                child: Column(
                  children: [
                    const Text(
                      '95%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2196F3),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Success Rate',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black87,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: const Text(
                'View Agent Profile',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Verified badge
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Verified By Broker',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Authenticity guaranteed',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF558B2F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Dates
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Verified on:',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Text(
                    '27th August, 2025',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Listed on:',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Text(
                    '29th July, 2025',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ).paddingAll(16),
    );
  }

  Widget _userProfileCard(User userModel) {
    return ContainerW(
      width: double.infinity,
      // padding: const EdgeInsets.all(20),
      // decoration: BoxDecoration(
      color: Colors.white,
      radius: 16,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 20,
          offset: Offset(0, 4),
        ),
      ],
      // ),
      child: Column(
        children: [
          // Profile section
          Row(
            children: [
              // Avatar
              Container(
                width: 64.w,
                height: 64.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[100],
                ),
                child: ClipOval(
                  child: Image.network(
                    userModel.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        size: 32,
                        color: Colors.blue[300],
                      );
                    },
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Name and role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: "${userModel.name} ${userModel.surname}",
                      fontSize: 18,
                      fontWeight: 700,
                      color: AppColors.lightIcon,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    AppText(
                      text: 'Owner of the Property',
                      fontWeight: 400,
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ContainerW(
            color: AppColors.white,
            borderColor: AppColors.lightSky,
            radius: 8,
            child: Center(
              child: AppText(
                text: "View Owner Profile",
                fontWeight: 600,
                fontSize: 16,
              ),
            ).paddingOnly(top: 6, bottom: 6),
          ),
          // Button
          // ElevatedButton(
          //   onPressed: () {},
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.white,
          //     foregroundColor: Colors.black87,
          //     elevation: 0,
          //     padding: const EdgeInsets.symmetric(vertical: 12),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(8),
          //       side: BorderSide(color: Colors.grey[300]!),
          //     ),
          //   ),
          //   child: const Text(
          //     'View Owner Profile',
          //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          //   ),
          // ),
        ],
      ).paddingAll(16),
    );
  }
}

