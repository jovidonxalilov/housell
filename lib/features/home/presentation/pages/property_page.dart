import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.id});

  final String id;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (context) => HomeBloc(
        getIt<HomeGetHousesUsecase>(),
        getIt<HomeGetHousesIdUsecase>(),
      )..add(HomeGetHousesIdEvent(id: widget.id)),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final property = state.propertyModel;
            if (state.mainStatus == MainStatus.loading) {
              return Center(child: CircularProgressIndicator());
            }
            if (state.mainStatus == MainStatus.succes) {
              return Stack(
                children: [
                  /// Rasmlar vertical scroll
                  ListView.builder(
                    padding: EdgeInsets.only(bottom: screenHeight * 0.3),
                    itemCount: property!.datum!.photos.length,
                    // ✅ to‘g‘ri bo‘ladi
                    itemBuilder: (context, index) {
                      return Image.network(
                        property.datum!.photos[index].photo,
                        // endi xatolik chiqmaydi
                        fit: BoxFit.cover,
                      );
                    },
                  ),

                  /// AppBar (rasm ustida ko‘rinadi)
                  Positioned(
                    top: -20, // Status bar ostidan joy
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
                          color: Colors.white,
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
                            // Drag handle - har doim tepada ko'rinadi
                            const Padding(
                              padding: EdgeInsets.only(top: 12, bottom: 8),
                              child: Center(
                                child: Icon(
                                  Icons.drag_handle,
                                  color: Colors.grey,
                                ),
                              ),
                            ),

                            // Scrollable content
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
                                          text: property.datum!.currency,
                                          fontSize: 24,
                                          fontWeight: 700,
                                        ),
                                        AppText(
                                          text: property.datum!.price
                                              .toString(),
                                          fontSize: 24,
                                          fontWeight: 700,
                                        ),
                                        AppText(
                                          text:
                                              "/ ${property.datum!.rentalFrequency.toDisplayText()}",
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
                                          text:
                                              "${property.datum!.numberOfRooms} Ben",
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
                                              "${property.datum!.numberOfBathrooms} Baths",
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
                                          text: "${property.datum!.area} m2",
                                          fontSize: 14,
                                          fontWeight: 400,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 12.h),
                                    AppText(
                                      text: property.datum!.title,
                                      fontSize: 16,
                                      fontWeight: 500,
                                    ),
                                    SizedBox(height: 24.h),
                                    Row(
                                      children: [
                                        ContainerW(
                                          radius: 8,
                                          width: 155.w,
                                          height: 36.h,
                                          color: AppColors.base.withOpacity(
                                            0.2,
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AppImage(path: AppAssets.play),
                                              AppText(
                                                text: "See Video",
                                                fontSize: 14,
                                                fontWeight: 500,
                                                color: AppColors.base,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 16.w),
                                        ContainerW(
                                          radius: 8,
                                          width: 155.w,
                                          height: 36.h,
                                          color: AppColors.base.withOpacity(
                                            0.2,
                                          ),
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
                                                color: AppColors.base,
                                              ),
                                            ],
                                          ),
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
                                      color: AppColors.base.withOpacity(0.2),
                                      radius: 16,
                                      child: AppText(
                                        text: property.datum!.description,
                                        fontSize: 16,
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
                                            property.datum!.buildingType,
                                          ),
                                          _propertyInformation(
                                            "Furnishing Status",
                                            property.datum!.furnishing,
                                          ),
                                          _propertyInformation(
                                            "Purpose",
                                            property.datum!.typeOfSale,
                                          ),
                                          _propertyInformation(
                                            "Rental Period",
                                            property.datum!.rentalFrequency,
                                          ),
                                          _propertyInformation(
                                            "Total Rooms",
                                            "${property.datum!.numberOfRooms} Rooms",
                                          ),
                                          _propertyInformation(
                                            "Floor",
                                            "${property.datum!.floor}nd Floor",
                                          ),
                                          _propertyInformation(
                                            "Total Floors",
                                            "${property.datum!.totalFloors} Floors",
                                          ),
                                        ],
                                      ).paddingAll(16),
                                    ),
                                    SizedBox(height: 24.h,),
                                    ...property.datum!.locatedNear.map((location) =>
                                        ContainerW(
                                          margin: EdgeInsets.only(bottom: 8.h),
                                          radius: 8,
                                          color: AppColors.white,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 16,
                                                color: AppColors.textMuted,
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: AppText(
                                                  text: location,
                                                  fontSize: 14,
                                                  fontWeight: 400,
                                                ),
                                              ),
                                            ],
                                          ).paddingAll(12),
                                        ),
                                    ).toList(),
                                    // SizedBox(height: 50),
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
              return Center(child: AppText(text: "Maulomot kelmadi"));
            }
            return AppText(text: "Malumot mavjud emas");
          },
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
}
