import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/widgets/app_image.dart';
import '../../../../../core/widgets/w__container.dart';

class ListingMethodPage extends StatefulWidget {
  const ListingMethodPage({super.key});

  @override
  State<ListingMethodPage> createState() => _ListingMethodPageState();
}

class _ListingMethodPageState extends State<ListingMethodPage> {
  final ValueNotifier<int?> _selectPriceIndexNotifier = ValueNotifier<int?>(null);
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier<bool>(false);

  void _updateValidation() {
    _isValidNotifier.value = _selectPriceIndexNotifier.value != null;
  }

  @override
  void dispose() {
    _selectPriceIndexNotifier.dispose();
    _isValidNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundP,
      appBar: WCustomAppBar(
        backgroundColor: AppColors.backgroundP,
        title: AppText(
          text: "Listing Method",
          fontWeight: 400,
          fontSize: 18,
          color: AppColors.lightIcon,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 48.h),
          AppText(
            text: "Choose Listing Method",
            fontSize: 20,
            fontWeight: 700,
            color: AppColors.lightIcon,
          ),
          SizedBox(height: 24.h),
          _buildStep1(),
        ],
      ).paddingOnly(left: 24, right: 24),
      bottomNavigationBar: ContainerW(
        color: AppColors.backgroundP,
        boxShadow: [
          BoxShadow(
            color: Color(0xFF141414).withOpacity(0.04),
            offset: Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Color(0xFF141414).withOpacity(0.02),
            offset: Offset(0, -1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        width: double.infinity,
        height: 75.h,
        child: Center(
          child: ValueListenableBuilder<bool>(
            valueListenable: _isValidNotifier,
            builder: (context, isValid, child) {
              return GestureDetector(
                onTap: isValid
                    ? () {
                  final selectedIndex = _selectPriceIndexNotifier.value;
                  if (selectedIndex == 0) {
                    context.push(Routes.add);
                  } else if (selectedIndex == 1) {
                    context.push(Routes.brokers);
                  }
                }
                    : null,
                child: WContainer(
                  isValidNotifier: _isValidNotifier,
                  color: isValid ? AppColors.primary : AppColors.lightSky,
                  radius: 8,
                  child: Center(
                    child: AppText(
                      text: "Next",
                      fontSize: 16,
                      fontWeight: 600,
                      color: isValid ? AppColors.white : AppColors.textMuted,
                    ),
                  ),
                ),
              );
            },
          ),
        ).paddingOnly(top: 12, left: 24, right: 24, bottom: 12),
      ),
    );
  }

  final List<String> priceType = ['List It Yourself', 'Work with a Broker'];
  final List<String> priceDescription = [
    'Take full control—manage your listing, photos, pricing, and inquiries directly',
    'Get expert help with pricing, marketing, and negotiations from a professional.',
  ];
  final List<String> priceIcon = [AppAssets.user, AppAssets.userGroup];

  Widget _buildStep1() {
    return ValueListenableBuilder<int?>(
      valueListenable: _selectPriceIndexNotifier,
      builder: (context, selectPriceIndex, child) {
        return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            mainAxisSpacing: 16.0,
            childAspectRatio: 2,
          ),
          itemCount: priceType.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _selectPriceIndexNotifier.value = index;
                _updateValidation();

              },
              child: ContainerW(
                color: selectPriceIndex == index
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.white,
                border: Border.all(
                  color: selectPriceIndex == index
                      ? Colors.transparent
                      : AppColors.grey200,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF141414).withOpacity(0.08),
                    offset: Offset(0, 0),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
                radius: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppImage(
                      path: priceIcon[index],
                      color: selectPriceIndex == index
                          ? AppColors.primary
                          : AppColors.black,
                    ),
                    SizedBox(height: 12.h),
                    AppText(
                      color: selectPriceIndex == index
                          ? AppColors.primary
                          : AppColors.blackT,
                      text: priceType[index],
                      fontWeight: 700,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      fontSize: 18,
                    ),
                    AppText(
                      color: selectPriceIndex == index
                          ? AppColors.primary
                          : AppColors.textLight,
                      text: priceDescription[index],
                      fontWeight: 400,
                      maxLines: 3,
                      textAlign: TextAlign.center,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}