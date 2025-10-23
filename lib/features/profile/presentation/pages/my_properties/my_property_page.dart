import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:housell/features/profile/presentation/bloc/profile_event.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/dp/dp_injection.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../core/widgets/w__container.dart';
import '../../../domain/usecase/profile_usecase.dart';

class MyPropertyPage extends StatefulWidget {
  const MyPropertyPage({Key? key}) : super(key: key);

  @override
  State<MyPropertyPage> createState() => _PropertiesPageState();
}

class _PropertiesPageState extends State<MyPropertyPage> {
  // Sample data for properties
  // final List<Property> properties = [
  //   Property(
  //     id: '1',
  //     title: 'Modern Downtown Apartment',
  //     price: 1800,
  //     bedrooms: 2,
  //     bathrooms: 1,
  //     area: 1200,
  //     imageUrl: 'assets/images/property1.jpg',
  //     isNew: true,
  //   ),
  //   Property(
  //     id: '2',
  //     title: 'Modern Downtown Apartment',
  //     price: 1800,
  //     bedrooms: 2,
  //     bathrooms: 1,
  //     area: 1200,
  //     imageUrl: 'assets/images/property2.jpg',
  //     isNew: true,
  //   ),
  // ];
  // New Badge
  // if (property.isNew)
  // Positioned(
  //   top: 12,
  //   left: 12,
  //   child: Container(
  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: Color(0xFF6C5CE7),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Text(
  //       'NEW',
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: 11,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   ),
  // ),
  // Active Badge
  // Positioned(
  //   top: 12,
  //   right: 12,
  //   child: Container(
  //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //     decoration: BoxDecoration(
  //       color: Color(0xFF00D68F),
  //       borderRadius: BorderRadius.circular(20),
  //     ),
  //     child: Text(
  //       'Active',
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: 11,
  //         fontWeight: FontWeight.w600,
  //       ),
  //     ),
  //   ),
  // ),

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProfileBloc(
            getIt<ProfileGetUsecase>(),
            getIt<ProfilePatchUsecase>(),
            getIt<ProfilePhotoUrlUsecase>(),
            getIt<ProfileNewPhoneOtpUsecase>(),
            getIt<ProfileNewPhoneVerifyOtpUsecase>(),
            getIt<ProfileNewPasswordUsecase>(),
            getIt<ProfileGetMyHousesUsecase>(),
          )..add(
            ProfileGetMyHousesEvent(
              propertyModel: null,
              onFailure: () {},
              onSuccess: () {},
            ),
          ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        appBar: WCustomAppBar(
          title: AppText(
            text: "MyProperties",
            fontWeight: 400,
            fontSize: 18,
            color: AppColors.lightIcon,
          ),
          leading: AppImage(
            path: AppAssets.arrowChevronLeft,
            onTap: () => context.pop(),
            size: 24,
          ),
          showLeadingAutomatically: true,
        ),
        body: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state.mainStatus == MainStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state.mainStatus == MainStatus.succes) {
              final properties = state.propertyModel!;
              return ListView.builder(
                itemCount: properties.data.length,
                itemBuilder: (context, index) {
                  return PropertyCard(
                    property: properties.data[index],
                  ).paddingSymmetric(vertical: 16, horizontal: 24);
                },
              );
            }
            if (state.mainStatus == MainStatus.failure) {
              return Center(child: AppText(text: "Malumot kelmadi"));
            }
            return Center(child: AppText(text: "Malumot topilmadi"));
          },
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Datum property;

  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ContainerW(
      color: Colors.white,
      radius: 8,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AppImage(
                path: property.photos[1].photo,
                height: 200,
                width: double.infinity,
                borderRadius: BorderRadius.circular(8),
              ),
              Positioned(
                top: 12,
                left: 12,
                child: ContainerW(
                  // width: 40.w,
                  radius: 4,
                  color: AppColors.primary,
                  child: AppText(
                    text: 'NEW',
                    fontWeight: 500,
                    fontSize: 12,
                    color: AppColors.white,
                  ).paddingOnly(top: 4, right: 10, left: 10, bottom: 4),
                ),
              ),
              // Active Badge
              Positioned(
                top: 12,
                right: 12,
                child: ContainerW(
                  // width: 40.w,
                  radius: 4,
                  color: AppColors.greenLighter,
                  child: AppText(
                    text: 'Active',
                    fontWeight: 500,
                    fontSize: 12,
                    color: AppColors.white,
                  ).paddingOnly(right: 10, left: 10, top: 4, bottom: 4),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsetsGeometry.only(
              top: 18,
              left: 16,
              right: 16,
              bottom: 18,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: property.title,
                  fontSize: 16,
                  fontWeight: 400,
                  color: AppColors.lightIcon,
                ),
                Row(
                  children: [
                    AppText(
                      text: "${property.price.toString()}",
                      fontSize: 18,
                      fontWeight: 800,
                      color: AppColors.lightIcon,
                    ),
                    AppText(
                      text: "/ ${property.rentalFrequency.toDisplayText()}",
                      fontSize: 14,
                      fontWeight: 500,
                      color: AppColors.lightIcon,
                    ),
                  ],
                ),
                AppText(
                  text: property.location,
                  fontSize: 12,
                  fontWeight: 400,
                  color: AppColors.textMuted,
                ),
                SizedBox(height: 5.h),
                Row(
                  children: [
                    _buildDeatilItem(
                      property.numberOfBathrooms.toString(),
                      AppAssets.bedroom,
                    ),
                    SizedBox(width: 16.w),
                    _buildDeatilItem(property.area.toString(), AppAssets.sqft),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: ContainerW(
                        color: AppColors.bg,
                        radius: 8,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImage(path: AppAssets.pencil),
                            SizedBox(width: 5),
                            AppText(
                              text: "Edit",
                              fontSize: 14,
                              fontWeight: 500,
                              color: AppColors.lightIcon,
                            ),
                          ],
                        ).paddingSymmetric(vertical: 8, horizontal: 16),
                      ),
                    ),
                    SizedBox(width: 12), // Oradagi bo'shliq
                    Expanded(
                      child: ContainerW(
                        color: AppColors.primary.withOpacity(0.2),
                        radius: 8,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppImage(path: AppAssets.star, color: AppColors.primary),
                            SizedBox(width: 5),
                            AppText(
                              text: "VIP",
                              fontSize: 14,
                              fontWeight: 500,
                              color: AppColors.lightIcon,
                            ),
                          ],
                        ).paddingSymmetric(vertical: 8, horizontal: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeatilItem(String text, String icon) {
    return Row(
      children: [
        AppImage(path: icon),
        SizedBox(width: 5.w),
        AppText(
          text: text,
          fontWeight: 400,
          fontSize: 12,
          color: AppColors.primary,
        ),
      ],
    );
  }
}
