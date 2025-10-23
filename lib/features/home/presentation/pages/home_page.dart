import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/dp/dp_injection.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/features/home/domain/usecase/home_usecase.dart';
import 'package:housell/features/home/presentation/bloc/home_bloc.dart';

import '../../data/model/property_model.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';
import '../widgets/filter_widget.dart';

class PropertyGridScreen extends StatefulWidget {
  const PropertyGridScreen({super.key});

  @override
  State<PropertyGridScreen> createState() => _PropertyGridScreenState();
}

class _PropertyGridScreenState extends State<PropertyGridScreen> {
  final ValueNotifier<String?> propertyController = ValueNotifier<String?>(
    null,
  );
  ViewMode selectedViewMode = ViewMode.box;

  String _getCurrentViewIcon() {
    switch (selectedViewMode) {
      case ViewMode.list:
        return AppAssets.list;
      case ViewMode.box:
        return AppAssets.grid;
      case ViewMode.gallery:
        return AppAssets.gallery;
    }
  }


  @override
  Widget build(BuildContext context) {
    // final themeProvider = Provider.of<ThemeProvider>(context);
    // final isDark = themeProvider.isDarkMode;
    return BlocProvider(
      create: (context) =>
          HomeBloc(
            getIt<HomeGetHousesUsecase>(),
            getIt<HomeGetHousesIdUsecase>(),
            getIt<ProfileGetInformationUsecase>(),
          )..add(
            HomeGetHousesLoading(
              propertyModel: null,
              onFailure: () {},
              onSuccess: () {},
            ),
          ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundP,
        appBar: WCustomAppBar(
          backgroundColor: AppColors.backgroundP,
          title: AppText(
            text: "Housell",
            fontSize: 32,
            fontWeight: 700,
            color: AppColors.blackT,
          ),
          actions: [AppImage(path: AppAssets.notification)],
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state.mainStatus == MainStatus.loading) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 150.h),
                    Center(child: CircularProgressIndicator()),
                  ],
                );
              }
              if (state.mainStatus == MainStatus.failure) {
                return Center(child: AppText(text: "Malumot kelmadi"));
              }
              // state.propertyModel!.data[3].floor;
              if (state.mainStatus == MainStatus.succes) {
                final property = state.propertyModel!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 12.h),
                        ContainerW(
                          onTap: () {
                            context.push(Routes.search);
                          },
                          boxShadow: [
                            // Birinchi shadow
                            BoxShadow(
                              color: Color(0x14141414).withOpacity(0.08),
                              // #141414 at 8%
                              offset: Offset(0, 0),
                              // X: 0, Y: 0
                              blurRadius: 8,
                              spreadRadius: 0,
                            ),
                            // Ikkinchi shadow
                            BoxShadow(
                              color: Color(0x14141414).withOpacity(0.04),
                              // #141414 at 4%
                              offset: Offset(0, 0),
                              // X: 0, Y: 0
                              blurRadius: 1,
                              spreadRadius: 0,
                            ),
                          ],
                          width: double.infinity,
                          height: 36.h,
                          // borderColor: Colors.transparent,
                          color: AppColors.white,
                          radius: 8,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppImage(path: AppAssets.search),
                              SizedBox(width: 12.w),
                              AppText(
                                text: "Search Properties",
                                fontSize: 14,
                                fontWeight: 400,
                              ),
                            ],
                          ).paddingOnly(left: 8),
                        ).paddingOnly(top: 0, left: 16, right: 16),
                        SizedBox(height: 16.h),
                        Row(
                          children: [
                            Expanded(
                              child: ContainerW(
                                boxShadow: [
                                  // Birinchi shadow
                                  BoxShadow(
                                    color: Color(0x14141414).withOpacity(0.08),
                                    // #141414 at 8%
                                    offset: Offset(0, 0),
                                    // X: 0, Y: 0
                                    blurRadius: 8,
                                    spreadRadius: 0,
                                  ),
                                  // Ikkinchi shadow
                                  BoxShadow(
                                    color: Color(0x14141414).withOpacity(0.04),
                                    // #141414 at 4%
                                    offset: Offset(0, 0),
                                    // X: 0, Y: 0
                                    blurRadius: 1,
                                    spreadRadius: 0,
                                  ),
                                ],
                                // borderColor: Colors.transparent,
                                color: AppColors.white,
                                height: 36.h,
                                radius: 8,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        text: "Property",
                                        fontSize: 16,
                                        fontWeight: 400,
                                      ),
                                    ),
                                    AppImage(path: AppAssets.chevronBottom),
                                  ],
                                ).paddingOnly(left: 16, right: 16),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            ContainerW(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return DraggableScrollableSheet(
                                      initialChildSize: 0.9,
                                      minChildSize: 0.5,
                                      maxChildSize: 0.95,
                                      builder: (_, controller) {
                                        return FilterBottomSheet(scrollController: controller);
                                      },
                                    );
                                  },
                                );
                              },
                              boxShadow: [
                                // Birinchi shadow
                                BoxShadow(
                                  color: Color(0x14141414).withOpacity(0.08),
                                  // #141414 at 8%
                                  offset: Offset(0, 0),
                                  // X: 0, Y: 0
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                ),
                                // Ikkinchi shadow
                                BoxShadow(
                                  color: Color(0x14141414).withOpacity(0.04),
                                  // #141414 at 4%
                                  offset: Offset(0, 0),
                                  // X: 0, Y: 0
                                  blurRadius: 1,
                                  spreadRadius: 0,
                                ),
                              ],
                              color: AppColors.white,
                              radius: 8,
                              width: 40.w,
                              height: 40.h,
                              child: Center(
                                child: AppImage(path: AppAssets.filter),
                              ),
                            ),
                          ],
                        ).paddingOnly(top: 0, left: 16, right: 16),
                        SizedBox(height: 19.h),
                        AppText(
                          text: "VIP Properties",
                          fontWeight: 500,
                          fontSize: 20,
                        ).paddingOnly(top: 0, left: 16, right: 16),
                        SizedBox(height: 15.h),
                        // Row(
                        //   children: [
                        _buildVipPropertyView(
                          property,
                        ).paddingOnly(top: 0, left: 16),
                        //   ],
                        // ),
                        SizedBox(height: 19.h),
                        Row(
                          children: [
                            Expanded(
                              child: AppText(
                                text: "All Properties",
                                fontWeight: 500,
                                fontSize: 20,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (BuildContext context) {
                                    return Container(
                                      width: double.infinity,
                                      height: 270.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.white,
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 8.h),
                                          Divider(
                                            thickness: 4,
                                            indent: 162,
                                            radius: BorderRadius.circular(5),
                                            endIndent: 162,
                                          ),
                                          SizedBox(height: 35.h),
                                          _buildViewModeButton(
                                            ViewMode.list,
                                            AppAssets.list,
                                            'List',
                                          ),
                                          SizedBox(height: 22.h),
                                          _buildViewModeButton(
                                            ViewMode.box,
                                            AppAssets.grid,
                                            'Box',
                                          ),
                                          SizedBox(height: 22.h),
                                          _buildViewModeButton(
                                            ViewMode.gallery,
                                            AppAssets.gallery,
                                            'Gallery',
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: AppImage(path: _getCurrentViewIcon()),
                            ),
                          ],
                        ).paddingOnly(top: 0, left: 16, right: 16),
                      ],
                    ),
                    _buildContent(property),
                  ],
                );
              }
              return AppText(text: "Malumot topilmadi");
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(PropertyModel propertyModel) {
    switch (selectedViewMode) {
      case ViewMode.list:
        return _buildListView(propertyModel);
      case ViewMode.box:
        return _buildGridView(propertyModel);
      case ViewMode.gallery:
        return _buildGalleryView(propertyModel);
    }
  }

  Widget _buildGridView(PropertyModel propertyModel) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.64,
        crossAxisSpacing: 12,
        mainAxisSpacing: 16,
      ),
      itemCount: propertyModel.data.length,
      itemBuilder: (context, index) {
        final property = propertyModel.data[index];
        return GestureDetector(
          onTap: () {
            try {
              if (property.id != null && property.user?.id != null) {
                context.push('/property_detail/${property.id}/${property.user!.id}');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Ma\'lumot to\'liq emas')),
                );
              }
            } catch (e) {
              debugPrint('Navigation xatosi: $e');
            }
          },
          child: _buildPropertyCard(property),
        );
      },
    ).paddingOnly(top: 15, left: 16, right: 16, bottom: 0);
  }

  Widget _buildListView(PropertyModel propertyModel) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: propertyModel.data.length,
      itemBuilder: (context, index) {
        final property = propertyModel.data[index];
        return GestureDetector(
          onTap: () {
            context.push('/property_detail/${property.id}');
          },
          child: _buildListItem(property),
        );
      },
    ).paddingOnly(top: 15, left: 16, right: 16, bottom: 20);
  }

  Widget _buildGalleryView(PropertyModel propertyModel) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.2,
        mainAxisSpacing: 16,
      ),
      itemCount: propertyModel.data.length,
      itemBuilder: (context, index) {
        final property = propertyModel.data[index];
        return GestureDetector(
          onTap: () {
            context.push('/property_detail/${property.id}');
          },
          child: _buildGalleryCard(property),
        );
      },
    ).paddingOnly(top: 15, left: 16, right: 16, bottom: 20);
  }

  Widget _buildVipPropertyView(PropertyModel propertyModel) {
    final vipProperties = propertyModel.data
        .where((property) => property.isVip)
        .toList();
    return SizedBox(
      height: 266.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: vipProperties.length,
        itemBuilder: (context, index) {
          final property = vipProperties[index];
          return GestureDetector(
            onTap: () {
              context.push('/property_detail/${property.id![index]}');
            },
            child: Container(
              width: 250.w,
              margin: EdgeInsets.only(right: 12.w),
              child: _buildVipProperty(property),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyCard(Datum property) {
    return ContainerW(
      radius: 12,
      color: AppColors.white,
      boxShadow: [
        // Birinchi shadow
        BoxShadow(
          color: Color(0x14141414).withOpacity(0.08), // #141414 at 8%
          offset: Offset(0, 0), // X: 0, Y: 0
          blurRadius: 8,
          spreadRadius: 0,
        ),
        // Ikkinchi shadow
        BoxShadow(
          color: Color(0x14141414).withOpacity(0.04), // #141414 at 4%
          offset: Offset(0, 0), // X: 0, Y: 0
          blurRadius: 1,
          spreadRadius: 0,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Container(
                  width: double.infinity.w,
                  height: 123.h,
                  color: Colors.grey[300],
                  child: AppImage(
                    width: 118.w,
                    height: 157,
                    path: property.photos[1].photo,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              if (property.isVip)
                Positioned(
                  top: 8,
                  left: 8,
                  child: ContainerW(
                    width: 40.w,
                    height: 23.h,
                    radius: 4,
                    color: AppColors.primary,
                    child: Center(
                      child: AppText(
                        text: 'VIP',
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: 500,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            // flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(
                          text: property.title.isNotEmpty
                              ? property.title
                              : "No title",
                          fontSize: 16,
                          height: 1.2,
                          fontWeight: 400,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                        ),
                      ),
                      AppImage(path: AppAssets.hearth),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  AppText(
                    text: property.price > 0
                        ? "${property.price} ${property.currency}"
                        : "Price not set",
                    fontWeight: 800,
                    fontSize: 16,
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: AppText(
                          text: property.location.isNotEmpty
                              ? property.location
                              : "Location not specified",
                          fontSize: 12,
                          fontWeight: 400,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          height: 1.2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      AppImage(path: AppAssets.bedroom),
                      SizedBox(width: 8.w),
                      AppText(
                        text: '${property.numberOfBathrooms}',
                        fontWeight: 400,
                        fontSize: 12,
                        // color: AppColors.base,
                      ),
                      SizedBox(width: 16.w),
                      AppImage(path: AppAssets.sqft),
                      SizedBox(width: 8.w),
                      AppText(
                        text: property.numberOfRooms.isNotEmpty
                            ? property.numberOfRooms
                            : "0",
                        fontWeight: 400,
                        fontSize: 12,
                        // color: AppColors.base,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(Datum property) {
    return ContainerW(
      color: AppColors.white,
      // height: 157.h,
      margin: EdgeInsets.only(bottom: 12),
      radius: 12,
      boxShadow: [
        // Birinchi shadow
        BoxShadow(
          color: Color(0x14141414).withOpacity(0.08), // #141414 at 8%
          offset: Offset(0, 0), // X: 0, Y: 0
          blurRadius: 8,
          spreadRadius: 0,
        ),
        // Ikkinchi shadow
        BoxShadow(
          color: Color(0x14141414).withOpacity(0.04), // #141414 at 4%
          offset: Offset(0, 0), // X: 0, Y: 0
          blurRadius: 1,
          spreadRadius: 0,
        ),
      ],
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   color: AppColors.bg,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.07),
      //       blurRadius: 8,
      //       spreadRadius: 0,
      //     ),
      //   ],
      // ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.horizontal(left: Radius.circular(8)),
            child: Stack(
              children: [
                AppImage(
                  width: 118.w,
                  height: 157,
                  path: property.photos[1].photo,
                  fit: BoxFit.cover,
                ),
                // Container(
                //   width: 118.w,
                //   // height: double.infinity.h,
                //   color: Colors.grey[300],
                //   child: Image.network(
                //     // height: double.infinity,
                //     property.photos[1].photo,
                //     fit: BoxFit.cover,
                //     errorBuilder: (context, error, stackTrace) {
                //       return Container(
                //         color: Colors.grey[300],
                //         child: const Icon(Icons.image, color: Colors.grey),
                //       );
                //     },
                //   ),
                // ),
                if (property.isVip)
                  Positioned(
                    top: 5,
                    left: 5,
                    child: ContainerW(
                      width: 40.w,
                      height: 23.h,
                      color: AppColors.primary,
                      radius: 4,
                      child: Center(
                        child: AppText(
                          text: 'VIP',
                          fontSize: 12,
                          fontWeight: 500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText(
                        text: property.title,
                        fontSize: 16,
                        fontWeight: 400,

                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    AppImage(path: AppAssets.hearth, size: 24),
                  ],
                ).paddingOnly(right: 4),
                SizedBox(height: 4.h),
                AppText(
                  text: property.price.toString(),
                  fontSize: 18,
                  fontWeight: 700,
                ),
                SizedBox(height: 4.h),
                AppText(
                  text: property.location,
                  fontSize: 12,
                  fontWeight: 400,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                SizedBox(height: 24.h),
                Row(
                  children: [
                    AppImage(path: AppAssets.bedroom),
                    SizedBox(width: 8.h),
                    AppText(
                      text: property.numberOfBathrooms.toString(),
                      fontSize: 12,
                      fontWeight: 400,
                      // color: AppColors.base,
                    ),
                    SizedBox(width: 16.w),
                    AppImage(path: AppAssets.sqft),
                    SizedBox(width: 8.w),
                    AppText(
                      text: '${property.area.toString()} m²',
                      fontSize: 12,
                      fontWeight: 400,
                      // color: AppColors.base,
                    ),
                  ],
                ),
              ],
            ).paddingAll(12),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryCard(Datum property) {
    return ContainerW(
      color: AppColors.white,
      radius: 12,
      boxShadow: [
        // Birinchi shadow
        BoxShadow(
          color: Color(0x14141414).withOpacity(0.08), // #141414 at 8%
          offset: Offset(0, 0), // X: 0, Y: 0
          blurRadius: 8,
          spreadRadius: 0,
        ),
        // Ikkinchi shadow
        BoxShadow(
          color: Color(0x14141414).withOpacity(0.04), // #141414 at 4%
          offset: Offset(0, 0), // X: 0, Y: 0
          blurRadius: 1,
          spreadRadius: 0,
        ),
      ],
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(12),
      //   color: Colors.white,
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.08),
      //       blurRadius: 8,
      //       spreadRadius: 0,
      //     ),
      //   ],
      // ),
      child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: AppImage(
                    width: double.infinity.w,
                    height: 195.h,
                    path: property.photos[1].photo,
                  ),

                  // Container(
                  //   width: double.infinity,
                  //   height: 196.h,
                  //   color: Colors.grey[300],
                  //   child: Image.network(
                  //     property.photos[1].photo,
                  //     fit: BoxFit.cover,
                  //     errorBuilder: (context, error, stackTrace) {
                  //       return Container(
                  //         color: Colors.grey[300],
                  //         width: double.infinity,
                  //         height: 196.h,
                  //         child: Icon(
                  //           Icons.image,
                  //           color: Colors.grey,
                  //           size: 40,
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ),
                if (property.isVip)
                  Positioned(
                    top: 12,
                    left: 12,
                    child: ContainerW(
                      width: 40.w,
                      height: 23.h,
                      color: AppColors.primary,
                      radius: 4,
                      child: Center(
                        child: AppText(
                          text: 'VIP',
                          fontSize: 12,
                          fontWeight: 500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Details
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppText(
                      text: property.title,
                      fontWeight: 400,
                      fontSize: 16,
                    ),
                  ),
                  AppImage(path: AppAssets.hearth, size: 24),
                ],
              ),
              SizedBox(height: 9.h),
              AppText(
                text: "\$${property.price}",
                fontSize: 16,
                fontWeight: 800,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              AppText(
                text: property.location,
                fontSize: 12,
                fontWeight: 400,
                color: AppColors.textMuted,
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  AppImage(path: AppAssets.bedroom),
                  SizedBox(width: 8.w),
                  AppText(
                    text: property.numberOfBathrooms.toString(),
                    fontWeight: 400,
                    fontSize: 12,
                  ),
                  SizedBox(width: 16.w),
                  AppImage(path: AppAssets.sqft),
                  SizedBox(width: 8.w),
                  AppText(
                    text: property.numberOfRooms.toString(),
                    fontWeight: 400,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ).paddingOnly(top: 18, left: 14, right: 14, bottom: 18),
        ],
      ),
    );
  }

  Widget _buildVipProperty(Datum property) {
    if (property.isVip) {
      return ContainerW(
        width: 180.w,
        color: AppColors.white,
        radius: 12,
        boxShadow: [
          // Birinchi shadow
          BoxShadow(
            color: Color(0x14141414).withOpacity(0.08), // #141414 at 8%
            offset: Offset(0, 0), // X: 0, Y: 0
            blurRadius: 8,
            spreadRadius: 0,
          ),
          // Ikkinchi shadow
          BoxShadow(
            color: Color(0x14141414).withOpacity(0.04), // #141414 at 4%
            offset: Offset(0, 0), // X: 0, Y: 0
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                      bottom: Radius.circular(8),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 140.h,
                      color: Colors.grey[300],
                      child: AppImage(
                        path: property.photos[1].photo,
                        width: double.infinity.w,
                        height: 140.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  if (property.isVip)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: ContainerW(
                        width: 40.w,
                        height: 23.h,
                        color: AppColors.primary,
                        radius: 4,
                        child: Center(
                          child: AppText(
                            text: 'VIP',
                            fontSize: 12,
                            fontWeight: 500,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Details
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText(
                        text: property.title,
                        fontWeight: 400,
                        fontSize: 16,
                      ),
                    ),
                    // AppImage(path: AppAssets.hearth, size: 24),
                  ],
                ),
                SizedBox(height: 9.h),
                AppText(
                  text: "\$${property.price}",
                  fontSize: 18,
                  fontWeight: 800,
                  color: AppColors.primary,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    AppImage(
                      path: AppAssets.map,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: AppText(
                        text: property.location,
                        fontSize: 14,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    AppImage(path: AppAssets.bedroom),
                    SizedBox(width: 8.w),
                    AppText(
                      text: property.numberOfBathrooms.toString(),
                      fontWeight: 400,
                      fontSize: 12,
                    ),
                    SizedBox(width: 16.w),
                    AppImage(path: AppAssets.sqft),
                    SizedBox(width: 8.w),
                    AppText(
                      text: property.numberOfRooms.toString(),
                      fontWeight: 400,
                      fontSize: 12,
                    ),
                  ],
                ),
              ],
            ).paddingOnly(top: 18, left: 14, right: 14, bottom: 18),
          ],
        ),
      );
    }
    return Center(child: AppText(text: "Vip Propertilar topilmadi"));
  }

  Widget _buildViewModeButton(ViewMode mode, String icon, String label) {
    final isSelected = selectedViewMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedViewMode = mode;
        });
        context.pop();
      },
      child: ContainerW(
        width: 155.w,
        height: 40.h,
        color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.bg,
        radius: 12,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImage(
              path: icon,
              color: isSelected ? AppColors.primary : AppColors.black,
            ),
            SizedBox(width: 24.w),
            AppText(
              color: isSelected ? AppColors.primary : AppColors.black,

              text: label,
              fontSize: 20,
              fontWeight: 400,
            ),
          ],
        ).paddingOnly(left: 20),
      ),
    );
  }
}

enum ViewMode { list, box, gallery }
