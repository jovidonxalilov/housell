import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/w__container.dart';
import '../../../../core/widgets/w_text_form.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key, this.scrollController});
  final ScrollController? scrollController;

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  // State variables
  String selectedTab = 'Rent';
  String selectedCurrency = 'USD';
  String selectedPropertyType = 'Residential';
  String? selectedSubType = 'Apartment';
  String? selectedBedroom = 'Studio';
  String? selectedBath = '1';
  bool verifiedByBroker = false;
  String selectedFurnishing = 'All';
  String selectedFrequency = 'Yearly';

  RangeValues priceRange = const RangeValues(0, 100000);
  RangeValues areaRange = const RangeValues(0, 500);

  List<String> selectedKeywords = [];

  final List<String> keywords = [
    'Hospital, clinic',
    'Entertainment facilities',
    'Kindergarten',
    'Restaurant, cafe',
    'Resort/dormitory',
    'Bus stops/Metro stations',
    'Supermarket, shops',
    'Park, green area',
    'School',
    'Playground',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColors.backgroundP,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header
          // _buildHeader(),
          Divider(
            radius: BorderRadius.circular(2),
            color: AppColors.skyBase,
            height: 48,
            endIndent: 163,
            indent: 163,
            thickness: 5,
          ),
          // Content
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: EdgeInsets.all(16),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBuyRentTabs(),
                    SizedBox(height: 24),
                    _buildLocation(),
                    SizedBox(height: 24),
                    _buildCurrency(),
                    SizedBox(height: 24),
                    _buildPropertyType(),
                    SizedBox(height: 24),
                    _buildVerifiedByBroker(),
                    SizedBox(height: 24),
                    _buildBedrooms(),
                    SizedBox(height: 24),
                    _buildBaths(),
                    SizedBox(height: 24),
                    _buildPriceRange(),
                    SizedBox(height: 24),
                    _buildAreaRange(),
                    SizedBox(height: 24),
                    _buildFurnishingStatus(),
                    SizedBox(height: 24),
                    _buildRentalFrequency(),
                    SizedBox(height: 24),
                    _buildKeywords(),
                    SizedBox(height: 24),
                  ],
                ),
              ],
            ),
          ),

          // Bottom buttons
          _buildBottomButtons(),
        ],
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       border: Border(
  //         bottom: BorderSide(color: AppColors.lightGrey, width: 1),
  //       ),
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         AppText(
  //           text: 'Filters',
  //           fontSize: 18,
  //           fontWeight: 600,
  //           color: AppColors.darkest,
  //         ),
  //         GestureDetector(
  //           onTap: () => Navigator.pop(context),
  //           child: AppImage(
  //             path: AppAssets.close,
  //             size: 24,
  //             color: AppColors.darkest,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildBuyRentTabs() {
    return Row(
      children: [
        Expanded(child: _buildTab('Buy', selectedTab == 'Buy')),
        SizedBox(width: 12),
        Expanded(child: _buildTab('Rent', selectedTab == 'Rent')),
      ],
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => selectedTab = text),
      child: ContainerW(
        height: 48,
        color: isSelected
            ? AppColors.primary.withOpacity(0.2)
            : AppColors.white,
        borderColor: isSelected ? AppColors.primary : AppColors.lightGrey,
        radius: 8,
        border: Border.all(
          color: isSelected ? Colors.transparent : AppColors.bgLight,
          width: 1,
        ),
        child: Center(
          child: AppText(
            text: text,
            fontSize: 16,
            fontWeight: 500,
            color: isSelected ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Location',
          fontSize: 20,
          fontWeight: 700,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        WTextField(
          hintText: 'Search for a locality, area or city',
          prefixImage: AppAssets.search,
          height: 48,
        ),
      ],
    );
  }

  Widget _buildCurrency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Currency',
          fontSize: 20,
          fontWeight: 700,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildCurrencyButton('USD')),
            SizedBox(width: 12),
            Expanded(child: _buildCurrencyButton('UZS')),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyButton(String currency) {
    final isSelected = selectedCurrency == currency;
    return GestureDetector(
      onTap: () => setState(() => selectedCurrency = currency),
      child: ContainerW(
        height: 48,
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.white,
        borderColor: isSelected ? AppColors.primary : AppColors.lightGrey,
        radius: 8,
        border: Border.all(
          color: isSelected ? Colors.transparent : AppColors.bgLight,
          width: 1,
        ),
        child: Center(
          child: AppText(
            text: currency,
            fontSize: 15,
            fontWeight: 500,
            color: isSelected ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Property Type',
          fontSize: 20,
          fontWeight: 700,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildPropertyTypeButton('Residential')),
            SizedBox(width: 12),
            Expanded(child: _buildPropertyTypeButton('Commercial')),
          ],
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSubTypeButton('Apartment', AppAssets.apartment),
            ),
            SizedBox(width: 12),
            Expanded(child: _buildSubTypeButton('Villa', AppAssets.villa)),
            SizedBox(width: 12),
            Expanded(
              child: _buildSubTypeButton('Pent-house', AppAssets.pentHouse),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPropertyTypeButton(String type) {
    final isSelected = selectedPropertyType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedPropertyType = type),
      child: ContainerW(
        height: 48,
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.white,
        borderColor: isSelected ? AppColors.primary : AppColors.bgLight,
        radius: 8,
        border: Border.all(
          color: isSelected ? Colors.transparent : AppColors.bgLight,
          width: 1,
        ),
        child: Center(
          child: AppText(
            text: type,
            fontSize: 15,
            fontWeight: 500,
            color: isSelected ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildSubTypeButton(String type, String iconPath) {
    final isSelected = selectedSubType == type;
    return GestureDetector(
      onTap: () => setState(() => selectedSubType = type),
      child: ContainerW(
        height: 80,
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.white,
        borderColor: isSelected ? AppColors.primary : AppColors.bgLight,
        radius: 8,
        border: Border.all(
          color: isSelected ? Colors.transparent : AppColors.bgLight,
          width: 1,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImage(
              path: iconPath,
              size: 32,
              color: isSelected ? AppColors.primary : AppColors.textDark,
            ),
            SizedBox(height: 8),
            AppText(
              text: type,
              fontSize: 13,
              fontWeight: 400,
              color: isSelected ? AppColors.primary : AppColors.textDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifiedByBroker() {
    return Row(
      children: [
        AppText(
          text: 'Show ',
          fontSize: 16,
          fontWeight: 400,
          color: AppColors.textDark,
        ),
        AppText(
          text: 'Verified by Broker',
          fontSize: 16,
          fontWeight: 500,
          color: AppColors.primary,
        ),
        AppText(
          text: ' properties',
          fontSize: 16,
          fontWeight: 400,
          color: AppColors.textDark,
        ),
        Spacer(),
        Switch(
          value: verifiedByBroker,
          onChanged: (value) => setState(() => verifiedByBroker = value),
          activeColor: AppColors.primary,
        ),
        SizedBox(height: 24.h),
        Divider(height: 1),
      ],
    );
  }

  Widget _buildBedrooms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Bedrooms',
          fontSize: 20,
          fontWeight: 700,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['Studio', '1', '2', '3', '4', '5', '6'].map((bedroom) {
            return _buildChipButton(
              bedroom,
              selectedBedroom == bedroom,
              () => setState(() => selectedBedroom = bedroom),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildBaths() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Baths',
          fontSize: 16,
          fontWeight: 600,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ['1', '2', '3', '4', '5', '6', '7+'].map((bath) {
            return _buildChipButton(
              bath,
              selectedBath == bath,
              () => setState(() => selectedBath = bath),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChipButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ContainerW(
        width: 60,
        height: 40,
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.white,
        borderColor: isSelected ? AppColors.primary : AppColors.bgLight,
        radius: 8,
        border: Border.all(
          color: isSelected ? Colors.transparent : AppColors.bgLight,
          width: 1,
        ),
        child: Center(
          child: AppText(
            text: text,
            fontSize: 14,
            fontWeight: 500,
            color: isSelected ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Price Range',
          fontSize: 20,
          fontWeight: 700,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        RangeSlider(
          values: priceRange,
          min: 0,
          max: 100000,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.lightGrey,
          onChanged: (values) => setState(() => priceRange = values),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  WTextField(
                    controller: TextEditingController(
                      text: priceRange.start.toInt().toString(),
                    ),
                    height: 48,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 4),
                  AppText(
                    text: 'Minimum',
                    fontSize: 14,
                    fontWeight: 400,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: AppText(
                text: 'to',
                fontSize: 16,
                fontWeight: 400,
                color: AppColors.textMuted,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  WTextField(
                    controller: TextEditingController(
                      text: priceRange.end.toInt().toString(),
                    ),
                    height: 48,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 4),
                  AppText(
                    text: 'Minimum',
                    fontSize: 14,
                    fontWeight: 400,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAreaRange() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Area Range',
          fontSize: 20,
          fontWeight: 700,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        RangeSlider(
          values: areaRange,
          min: 0,
          max: 500,
          activeColor: AppColors.primary,
          inactiveColor: AppColors.lightGrey,
          onChanged: (values) => setState(() => areaRange = values),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  WTextField(
                    controller: TextEditingController(
                      text: areaRange.start.toInt().toString(),
                    ),
                    height: 48,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 4),
                  AppText(
                    text: 'Minimum',
                    fontSize: 14,
                    fontWeight: 400,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: AppText(
                text: 'to',
                fontSize: 16,
                fontWeight: 400,
                color: AppColors.textMuted,
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  WTextField(
                    controller: TextEditingController(
                      text: areaRange.end.toInt().toString(),
                    ),
                    height: 48,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 4),
                  AppText(
                    text: 'Minimum',
                    fontSize: 14,
                    fontWeight: 400,
                    color: AppColors.textMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFurnishingStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Furnishing Status',
          fontSize: 20,
          fontWeight: 700,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ['All', 'Furnished', 'Unfurnished'].map((status) {
            return _buildChipButtonnn(
              status,
              selectedFurnishing == status,
              () => setState(() => selectedFurnishing = status),
              width: 110,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildChipButtonnn(
    String text,
    bool isSelected,
    VoidCallback onTap, {
    double? width,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ContainerW(
        width: width ?? 60,
        height: 40,
        color: isSelected
            ? AppColors.primary.withOpacity(0.1)
            : AppColors.white,
        borderColor: isSelected ? AppColors.primary : AppColors.bgLight,
        radius: 8,
        border: Border.all(
          color: isSelected ? Colors.transparent : AppColors.bgLight,
          width: 1,
        ),
        child: Center(
          child: AppText(
            text: text,
            fontSize: 14,
            fontWeight: 500,
            color: isSelected ? AppColors.primary : AppColors.textDark,
          ),
        ),
      ),
    );
  }

  Widget _buildRentalFrequency() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Rental Frequency',
          fontSize: 20,
          fontWeight: 700,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: ['Yearly', 'Monthly', 'Weely', 'Daily'].map((freq) {
            return _buildChipButton(
              freq,
              selectedFrequency == freq,
              () => setState(() => selectedFrequency = freq),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildKeywords() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'Keywords',
          fontSize: 16,
          fontWeight: 600,
          color: AppColors.darkest,
        ),
        SizedBox(height: 12),
        ...keywords.map((keyword) {
          final isSelected = selectedKeywords.contains(keyword);
          return Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedKeywords.add(keyword);
                      } else {
                        selectedKeywords.remove(keyword);
                      }
                    });
                  },
                  activeColor: AppColors.primary,
                  side: BorderSide(color: AppColors.lightGrey, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                SizedBox(width: 8),
                AppText(
                  text: keyword,
                  fontSize: 14,
                  fontWeight: 400,
                  color: AppColors.textDark,
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.lightGrey, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ContainerW(
              height: 48,
              color: AppColors.white,
              borderColor: AppColors.primary,
              radius: 8,
              border: Border.all(color: AppColors.primary, width: 1.5),
              onTap: () {
                // Reset logic
                Navigator.pop(context);
              },
              child: Center(
                child: AppText(
                  text: 'Reset',
                  fontSize: 15,
                  fontWeight: 600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: ContainerW(
              height: 48,
              color: AppColors.primary,
              radius: 8,
              onTap: () {
                // Apply filter logic
                Navigator.pop(context);
              },
              child: Center(
                child: AppText(
                  text: 'Apply',
                  fontSize: 15,
                  fontWeight: 600,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
