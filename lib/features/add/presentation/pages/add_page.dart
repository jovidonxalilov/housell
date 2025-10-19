import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:housell/config/router/routes.dart';
import 'package:image_picker/image_picker.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_custom_app_bar.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/features/add/presentation/bloc/add_bloc.dart';
import 'package:housell/features/add/presentation/bloc/add_event.dart';
import 'package:housell/features/add/presentation/bloc/add_state.dart';
import 'package:housell/features/add/presentation/pages/new_property_deatil.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../../core/widgets/w_validator.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final PropertyFormControllers propertyControllers = PropertyFormControllers();
  final ValueNotifier<bool> _isValidNotifier = ValueNotifier<bool>(false);
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  String? _serverError;
  int? selectPriceIndex;
  int? selectPropertyTypeIndex;

  int currentIndex = 0;

  final List<String> tabTitles = ['Step 1', 'Step 2', 'Step 3', 'Step 4'];

  // Amenities list for property form
  final List<Map<String, dynamic>> amenitiesList = [
    {"name": "Hospital, clinic", "selected": false},
    {"name": "Entertainment facilities", "selected": false},
    {"name": "Kindergarten", "selected": false},
    {"name": "Restaurant, cafe", "selected": false},
    {"name": "Resort/ Dormitory", "selected": false},
    {"name": "Bus Stops/Metro Stations", "selected": false},
    {"name": "Supermarket, shops", "selected": false},
    {"name": "Park, green area", "selected": false},
    {"name": "School", "selected": false},
    {"name": "Playground", "selected": false},
  ];

  @override
  void initState() {
    super.initState();
    _addListeners();
    _updateValidation();
  }

  void _addListeners() {
    final c = propertyControllers;

    // Text controllers
    c.propertyTitleController.addListener(_onFieldChanged);
    c.descriptionController.addListener(_onFieldChanged);
    c.numberOfRoomsController.addListener(_onFieldChanged);
    c.numberOfBathroomsController.addListener(_onFieldChanged);
    c.areaController.addListener(_onFieldChanged);
    c.floorController.addListener(_onFieldChanged);
    c.totalFloorsController.addListener(_onFieldChanged);
    c.locationController.addListener(_onFieldChanged);
    c.priceController.addListener(_onFieldChanged);

    // Value notifiers
    c.selectedStudio.addListener(_onFieldChanged);
    c.selectedBathrooms.addListener(_onFieldChanged);
    c.selectedFurnishingStatus.addListener(_onFieldChanged);
    c.selectedRentalFrequency.addListener(_onFieldChanged);
    c.selectedCurrency.addListener(_onFieldChanged);
    c.selectedAmenities.addListener(_onFieldChanged);
    c.selectedImages.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    _updateValidation();
  }

  void _updateValidation() {
    bool isValid = false;

    switch (currentIndex) {
      case 0:
        isValid = selectPriceIndex != null;
        break;
      case 1:
        isValid = selectPropertyTypeIndex != null;
        break;
      case 2:
        isValid = _isPropertyFormValid();
        break;
      case 3:
        isValid = true; // Review step is always valid
        break;
    }

    _isValidNotifier.value = isValid;
  }

  bool _isPropertyFormValid() {
    final c = propertyControllers;
    return c.propertyTitleController.text.isNotEmpty &&
        c.descriptionController.text.isNotEmpty &&
        c.numberOfRoomsController.text.isNotEmpty &&
        c.numberOfBathroomsController.text.isNotEmpty &&
        c.areaController.text.isNotEmpty &&
        c.locationController.text.isNotEmpty &&
        c.priceController.text.isNotEmpty &&
        c.selectedImages.value.length >= 3;
  }

  @override
  void dispose() {
    _removeListeners();
    _isValidNotifier.dispose();
    propertyControllers.dispose();
    super.dispose();
  }

  void _removeListeners() {
    final c = propertyControllers;

    // Text controllers
    c.propertyTitleController.removeListener(_onFieldChanged);
    c.descriptionController.removeListener(_onFieldChanged);
    c.numberOfRoomsController.removeListener(_onFieldChanged);
    c.numberOfBathroomsController.removeListener(_onFieldChanged);
    c.areaController.removeListener(_onFieldChanged);
    c.floorController.removeListener(_onFieldChanged);
    c.totalFloorsController.removeListener(_onFieldChanged);
    c.locationController.removeListener(_onFieldChanged);
    c.priceController.removeListener(_onFieldChanged);

    // Value notifiers
    c.selectedStudio.removeListener(_onFieldChanged);
    c.selectedBathrooms.removeListener(_onFieldChanged);
    c.selectedFurnishingStatus.removeListener(_onFieldChanged);
    c.selectedRentalFrequency.removeListener(_onFieldChanged);
    c.selectedCurrency.removeListener(_onFieldChanged);
    c.selectedAmenities.removeListener(_onFieldChanged);
    c.selectedImages.removeListener(_onFieldChanged);
  }

  void goToNext() {
    if (currentIndex < tabTitles.length - 1) {
      setState(() {
        currentIndex++;
      });
      _updateValidation();
    }
  }

  void goToPrevious() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _updateValidation();
    }
  }

  void goToTab(int index) {
    setState(() {
      currentIndex = index;
    });
    _updateValidation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundP,
      appBar: WCustomAppBar(
        title: AppText(text: "Add Listing", fontWeight: 700, fontSize: 32),
        centerTitle: false,
      ),
      body: SafeArea(
        child: BlocBuilder<AddHouseBloc, AddHouseState>(
          builder: (context, state) {
            return Column(
              children: [
                // Tab headers
                Container(
                  decoration: BoxDecoration(),
                  child: Row(
                    children: tabTitles.asMap().entries.map((entry) {
                      int index = entry.key;
                      String title = entry.value;
                      bool isActive = currentIndex == index;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => goToTab(index),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(color: AppColors.grey200),
                                bottom: BorderSide(
                                  color: (isActive || index < currentIndex)
                                      ? AppColors.base
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                            child: AppText(
                              text: title,
                              textAlign: TextAlign.center,
                              fontSize: 16,
                              fontWeight: 400,
                              color: (isActive || index < currentIndex)
                                  ? AppColors.base
                                  : AppColors.light,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onChanged: () {
                        if (_serverError != null) {
                          setState(() => _serverError = null);
                        }
                        _updateValidation();
                      },
                      child: _buildContent(),
                    ),
                  ),
                ),

                // Bottom navigation buttons
                ContainerW(
                  color: AppColors.white,
                  radius: 0,
                  height: 75.h,
                  child: Row(
                    children: [
                      if (currentIndex > 0) ...[
                        ContainerW(
                          onTap: goToPrevious,
                          width: 100,
                          height: 51,
                          radius: 8,
                          color: AppColors.grey200,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AppText(
                                text: "Back",
                                fontWeight: 600,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                      Expanded(
                        child: ValueListenableBuilder<bool>(
                          valueListenable: _isValidNotifier,
                          builder: (context, isValid, child) {
                            return currentIndex < tabTitles.length - 1
                                ? WContainer(
                                    isValidNotifier: _isValidNotifier,
                                    onTap: isValid ? goToNext : null,
                                    radius: 8,
                                    width: double.infinity,
                                    height: 51,
                                    color: isValid
                                        ? AppColors.base
                                        : AppColors.grey200,
                                    text: "Next",
                                    // textColor: isValid ? AppColors.white : AppColors.textLight,
                                  )
                                : ContainerW(
                                    onTap:
                                        isValid &&
                                            state.mainStatus !=
                                                MainStatus.loading
                                        ? _submitForm
                                        : null,
                                    radius: 8,
                                    width: double.infinity,
                                    height: 51,
                                    color: isValid
                                        ? AppColors.base
                                        : AppColors.grey200,
                                    child:
                                        state.mainStatus == MainStatus.loading
                                        ? const Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : AppText(
                                            text: "Create Listing",
                                            fontWeight: 600,
                                            fontSize: 16,
                                            color: AppColors.white,
                                          ),
                                  );
                          },
                        ),
                      ),
                    ],
                  ).paddingOnly(top: 12, left: 24, right: 24, bottom: 12),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent() {
    switch (currentIndex) {
      case 0:
        return _buildStep1();
      case 1:
        return _buildStep2();
      case 2:
        return _buildStep3();
      case 3:
        return _buildStep4();
      default:
        return Container();
    }
  }

  final List<String> priceType = ['For Rent', 'For Purchase'];
  final List<String> priceDescription = [
    'Monthly rental property',
    'Property for purchase',
  ];
  final List<String> priceIcon = [AppAssets.housee, AppAssets.tag];

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'What type of listing is this?',
          fontSize: 20,
          fontWeight: 700,
        ),
        SizedBox(height: 24.h),
        GridView.builder(
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
                setState(() {
                  selectPriceIndex = index;
                });
                _updateValidation();
              },
              child: ContainerW(
                color: selectPriceIndex == index
                    ? AppColors.base.withOpacity(0.2)
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
                          ? AppColors.base
                          : AppColors.base,
                    ),
                    SizedBox(height: 12.h),
                    AppText(
                      color: selectPriceIndex == index
                          ? AppColors.base
                          : AppColors.blackT,
                      text: priceType[index],
                      fontWeight: 700,
                      fontSize: 18,
                    ),
                    AppText(
                      color: selectPriceIndex == index
                          ? AppColors.base
                          : AppColors.textLight,
                      text: priceDescription[index],
                      fontWeight: 400,
                      fontSize: 14,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    ).paddingOnly(left: 24, right: 24, top: 48, bottom: 24);
  }

  final List<String> propertyType = [
    'Villa',
    'Appartment',
    'Pent-house',
    'Land',
  ];
  final List<String> propertyIcon = [
    AppAssets.villa,
    AppAssets.apartment,
    AppAssets.pentHouse,
    AppAssets.land,
  ];

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: 'What type of property is this?',
          fontSize: 20,
          fontWeight: 700,
        ),
        SizedBox(height: 24.h),
        Container(
          height: 300,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 24.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.5,
            ),
            itemCount: propertyType.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectPropertyTypeIndex = index;
                  });
                  _updateValidation();
                },
                child: ContainerW(
                  color: selectPropertyTypeIndex == index
                      ? AppColors.base.withOpacity(0.2)
                      : AppColors.white,
                  border: Border.all(
                    color: selectPropertyTypeIndex == index
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
                        path: propertyIcon[index],
                        color: selectPropertyTypeIndex == index
                            ? AppColors.base
                            : AppColors.blackT,
                      ),
                      SizedBox(height: 8.h),
                      AppText(
                        color: selectPropertyTypeIndex == index
                            ? AppColors.base
                            : AppColors.blackT,
                        text: propertyType[index],
                        fontWeight: 400,
                        fontSize: 14,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ).paddingOnly(left: 24, right: 24, top: 48, bottom: 24);
  }

  // Integrated Property Form as Step 3
  Widget _buildStep3() {
    final c = propertyControllers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Images section
        AppText(
          text: "Add Photos",
          color: AppColors.black,
          fontWeight: 700,
          fontSize: 20,
        ),
        SizedBox(height: 8.h),
        AppText(
          text: "Add at least 3 photos of your property",
          color: AppColors.light,
          fontWeight: 400,
          fontSize: 16,
        ),
        SizedBox(height: 24.h),
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            color: AppColors.base,
            strokeWidth: 2,
            dashPattern: [6, 4],
            padding: EdgeInsets.all(2),
          ),
          child: ContainerW(
            width: double.infinity.w,
            height: 225.h,
            radius: 16,
            color: AppColors.base.withOpacity(0.2),
            onTap: _pickMultipleImages,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage(path: AppAssets.camera),
                SizedBox(height: 12.h),
                AppText(
                  text: "Add Photos",
                  color: AppColors.base,
                  fontWeight: 600,
                  fontSize: 18,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),

        // Selected images grid
        ValueListenableBuilder<List<File>>(
          valueListenable: c.selectedImages,
          builder: (context, selectedImages, child) {
            if (selectedImages.isEmpty) return const SizedBox.shrink();
            return Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: selectedImages.length,
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            selectedImages[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: ContainerW(
                            color: AppColors.base,
                            width: 32.w,
                            height: 32.h,
                            radius: 16,
                            child: Center(
                              child: AppImage(
                                path: AppAssets.close,
                                onTap: () => _removeImage(index),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),

        SizedBox(height: 32.h),

        // Property Title - REQUIRED
        _buildSectionTitle("Title", isRequired: true),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.propertyTitleController,
          richText: true,
          hintText: "Enter Property Title",
          keyboardType: TextInputType.text,
          validator: (value) {
            return SimpleValidators.validateText(value, minLength: 10);
          },
        ),
        SizedBox(height: 20.h),

        // Description - REQUIRED
        _buildSectionTitle("Description", isRequired: true),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.descriptionController,
          richText: true,
          validator: (value) {
            return SimpleValidators.validateText(value, minLength: 20);
          },
          hintText: "Enter Property Description",
          maxLines: 3,
          keyboardType: TextInputType.text,
        ),
        SizedBox(height: 20.h),

        // Number of rooms - REQUIRED
        _buildSectionTitle("Number of rooms", isRequired: true),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.numberOfRoomsController,
          richText: true,
          hintText: "Enter number of rooms",
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 8.h),
        ValueListenableBuilder<int>(
          valueListenable: c.selectedStudio,
          builder: (context, value, _) {
            return _buildNumberSelector(
              controller: c.numberOfRoomsController,
              selectedValue: value,
              maxValue: 5,
              onChanged: (v) {
                c.selectedStudio.value = v;
                _onFieldChanged();
              },
            );
          },
        ),
        SizedBox(height: 20.h),

        // Number of bathrooms - REQUIRED
        _buildSectionTitle("Number of bathrooms", isRequired: true),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.numberOfBathroomsController,
          hintText: "Enter number of bathrooms",
          validator: (value) {
            return SimpleValidators.numberInRange(value, min: 1, max: 15);
          },
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 8.h),
        ValueListenableBuilder<int>(
          valueListenable: c.selectedBathrooms,
          builder: (context, value, _) {
            return _buildNumberSelector(
              showStudio: false,
              controller: c.numberOfBathroomsController,
              selectedValue: value,
              maxValue: 3,
              onChanged: (v) {
                c.selectedBathrooms.value = v;
                _onFieldChanged();
              },
            );
          },
        ),
        SizedBox(height: 20.h),

        // Area - REQUIRED
        _buildSectionTitle("Area m²", isRequired: true),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.areaController,
          validator: (value) {
            return SimpleValidators.notEmptyIfFilled(
              value,
              errorText: "Uy maydonini kiriting",
            );
          },
          hintText: "e.g. 150 m²",
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20.h),

        // Floor - OPTIONAL
        _buildSectionTitle("Floor", isRequired: false),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.floorController,
          hintText: "e.g. 5",
          validator: (value) {
            return SimpleValidators.notEmptyIfFilled(
              value,
              errorText: "Uy qavatini kiriting",
            );
          },
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20.h),

        // Total floors - OPTIONAL
        _buildSectionTitle("Enter total residential floors", isRequired: false),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.totalFloorsController,
          validator: (value) {
            return SimpleValidators.notEmptyIfFilled(
              value,
              errorText: "Umumiy turar joy qavatlarini kiriting",
            );
          },
          hintText: "e.g., 4",
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 20.h),

        // Furnishing Status - REQUIRED
        _buildSectionTitle("Furnishing Status", isRequired: true),
        SizedBox(height: 8.h),
        FormField<String>(
          validator: (value) {
            if (c.selectedFurnishingStatus.value.isEmpty) {
              return "Iltimos, bittasini tanlang";
            }
            return null;
          },
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: c.selectedFurnishingStatus,
                  builder: (context, value, _) {
                    return buildSelectableContainerGroup(
                      options: ["Furnished", "Unfurnished"],
                      selectedValues: value,
                      onChanged: (v) {
                        c.selectedFurnishingStatus.value = v;
                        _onFieldChanged();
                        field.didChange(v);
                      },
                    );
                  },
                ),
                if (field.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 8),
                    child: Text(
                      field.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
        SizedBox(height: 20.h),

        // Location - REQUIRED
        _buildSectionTitle("Location", isRequired: true),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.locationController,
          hintText: "e.g., Downtown Manhattan, NYC",
          keyboardType: TextInputType.text,
          richText: true,
          validator: (value) {
            return SimpleValidators.validateText(
              value,
              errorText: "Uy manzilini kiriting kamida 5 ta harf",
              minLength: 5,
            );
          },
        ),
        SizedBox(height: 20.h),

        // Yadex map
        SizedBox(
          width: double.infinity.w,
          height: 200.h,
          child: Stack(children: [YandexMap()]),
        ),
        SizedBox(height: 20.h),

        // Located nearby - OPTIONAL
        _buildSectionTitle("Located nearby"),
        SizedBox(height: 12.h),
        ValueListenableBuilder<List<String>>(
          valueListenable: c.selectedAmenities,
          builder: (context, value, _) {
            return _buildAmenitiesGrid(value);
          },
        ),
        SizedBox(height: 20.h),

        // Rental Frequency - REQUIRED
        _buildSectionTitle("Rental Frequency", isRequired: true),
        SizedBox(height: 8.h),
        FormField<String>(
          validator: (value) {
            if (c.selectedRentalFrequency.value.isEmpty) {
              return "Iltimos, bittasini tanlang";
            }
            return null;
          },
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder<String>(
                  valueListenable: c.selectedRentalFrequency,
                  builder: (context, value, _) {
                    return buildSelectableContainerGroup(
                      options: ["Yearly", "Monthly", "Weekly", "Daily"],
                      selectedValues: value,
                      onChanged: (v) {
                        c.selectedRentalFrequency.value = v;
                        _onFieldChanged();
                        field.didChange(v);
                      },
                    );
                  },
                ),
                if (field.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 8),
                    child: Text(
                      field.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        ),
        SizedBox(height: 20.h),

        // Currency - OPTIONAL (has default)
        _buildSectionTitle("Currency"),
        SizedBox(height: 8.h),
        ValueListenableBuilder<String>(
          valueListenable: c.selectedCurrency,
          builder: (context, value, _) {
            return buildSelectableContainerGroup(
              options: ["USD", "UZS"],
              selectedValues: value,
              isExpanded: false,
              onChanged: (v) {
                c.selectedCurrency.value = v;
                _onFieldChanged();
              },
            );
          },
        ),
        SizedBox(height: 20.h),

        // Price - REQUIRED
        _buildSectionTitle("Price", isRequired: true),
        SizedBox(height: 8.h),
        _buildTextField(
          controller: c.priceController,
          hintText: "2 300",
          keyboardType: TextInputType.number,
          validator: (value) {
            return SimpleValidators.notEmptyIfFilled(
              value,
              errorText: "Uy narxini kiriting",
            );
          },
          suffixWidget: ContainerW(
            width: 104.w,
            onTap: _priceAI,
            height: 36.h,
            radius: 8,
            color: AppColors.base.withOpacity(0.2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage(path: AppAssets.flash),
                AppText(text: "Price Ai", fontSize: 14, fontWeight: 500),
              ],
            ),
          ).paddingOnly(top: 4, right: 4, bottom: 4),
        ),
      ],
    ).paddingOnly(left: 24, right: 24, top: 32);
  }

  Widget _buildStep4() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(text: 'Review Your Listing', fontSize: 20, fontWeight: 700),
        SizedBox(height: 24.h),

        _buildReviewSection(
          'Listing Type',
          selectPriceIndex != null
              ? priceType[selectPriceIndex!]
              : 'Not selected',
        ),

        _buildReviewSection(
          'Property Type',
          selectPropertyTypeIndex != null
              ? propertyType[selectPropertyTypeIndex!]
              : 'Not selected',
        ),

        _buildReviewSection(
          'Images',
          '${propertyControllers.selectedImages.value.length} images selected',
        ),

        if (propertyControllers.propertyTitleController.text.isNotEmpty)
          _buildReviewSection(
            'Property Title',
            propertyControllers.propertyTitleController.text,
          ),

        if (propertyControllers.descriptionController.text.isNotEmpty)
          _buildReviewSection(
            'Description',
            propertyControllers.descriptionController.text,
          ),

        if (propertyControllers.numberOfRoomsController.text.isNotEmpty)
          _buildReviewSection(
            'Number of Rooms',
            propertyControllers.numberOfRoomsController.text,
          ),

        if (propertyControllers.areaController.text.isNotEmpty)
          _buildReviewSection(
            'Area',
            '${propertyControllers.areaController.text} sq.m',
          ),

        if (propertyControllers.locationController.text.isNotEmpty)
          _buildReviewSection(
            'Location',
            propertyControllers.locationController.text,
          ),

        if (propertyControllers.priceController.text.isNotEmpty)
          _buildReviewSection(
            'Price',
            '\$${propertyControllers.priceController.text}',
          ),

        _buildReviewSection(
          'Furnishing Status',
          propertyControllers.selectedFurnishingStatus.value,
        ),
        _buildReviewSection(
          'Rental Frequency',
          propertyControllers.selectedRentalFrequency.value,
        ),

        SizedBox(height: 24.h),

        if (_serverError != null) ...[
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: Colors.red),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _serverError!,
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ],
    ).paddingOnly(left: 24, right: 24, top: 48, bottom: 24);
  }

  // Helper methods for property form
  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();

      if (images != null && images.isNotEmpty) {
        for (XFile image in images) {
          propertyControllers.addImage(File(image.path));
        }
        _showSuccessMessage(images.length);
      }
    } catch (e) {
      _showErrorMessage('Rasmlarni yuklashda xatolik yuz berdi');
      print('Xatolik: $e');
    }
  }

  void _removeImage(int index) {
    propertyControllers.removeImage(index);
    _updateValidation();
  }

  void _showSuccessMessage(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count ta rasm qo\'shildi'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title, {
    String? subtitle,
    bool isRequired = false,
  }) {
    return Row(
      children: [
        AppText(
          text: title,
          fontSize: 16,
          fontWeight: 600,
          color: AppColors.textC,
        ),
        if (isRequired)
          Text(' *', style: TextStyle(color: Colors.red, fontSize: 16)),
      ],
    );
  }

  Widget buildSelectableContainerGroup({
    required List<String> options,
    required String selectedValues,
    required Function(String) onChanged,
    bool isExpanded = true,
  }) {
    if (isExpanded) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((option) {
            final isSelected = selectedValues.contains(option);
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.base.withOpacity(0.2)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.bgLight),
                ),
                child: Center(
                  child: AppText(
                    text: option,
                    fontSize: 14,
                    fontWeight: 400,
                    color: isSelected ? AppColors.base : AppColors.black,
                  ),
                ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8),
              ),
            );
          }).toList(),
        ),
      );
    }
    return Row(
      children: options.map((option) {
        final isSelected = selectedValues.contains(option);
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.base.withOpacity(0.2)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.bgLight),
              ),
              child: Center(
                child: AppText(
                  text: option,
                  fontSize: 14,
                  fontWeight: 400,
                  color: isSelected ? AppColors.base : AppColors.black,
                ),
              ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    TextInputType? keyboardType,
    bool richText = false,
    Widget? suffixWidget,
    String? Function(String?)? validator,
  }) {
    return WTextField(
      suffixIconWidget: suffixWidget,
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      keyboardType: keyboardType,
      hintText: hintText,
      richText: richText,
      hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
      borderRadius: 12,
      fillColor: AppColors.bg,
      borderColor: AppColors.bgLight,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }

  Widget _buildNumberSelector({
    required int selectedValue,
    required int maxValue,
    required Function(int) onChanged,
    required TextEditingController controller,
    bool showStudio = true,
  }) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(showStudio ? maxValue + 1 : maxValue, (index) {
          final value = showStudio ? index : index + 1;
          final label = (showStudio && index == 0)
              ? "Studio"
              : value.toString();

          return GestureDetector(
            onTap: () {
              onChanged(value);
              controller.text = label;
            },
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.bgLight),
                color: selectedValue == value
                    ? AppColors.base.withOpacity(0.2)
                    : AppColors.white,
              ),
              margin: const EdgeInsets.only(right: 8),
              child: Center(
                child: AppText(
                  text: label,
                  fontWeight: 400,
                  fontSize: 14,
                  color: selectedValue == value
                      ? AppColors.base
                      : AppColors.black,
                ),
              ).paddingOnly(top: 8, left: 16, right: 16, bottom: 8),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSelectableContainerGroup({
    required List<String> options,
    required String selectedValue,
    required Function(String) onChanged,
    bool isExpanded = true,
  }) {
    // o'chirish kerak menimcha
    if (isExpanded) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.base.withOpacity(0.2)
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.bgLight),
                ),
                child: Center(
                  child: AppText(
                    text: option,
                    fontSize: 14,
                    fontWeight: 400,
                    color: isSelected ? AppColors.base : AppColors.black,
                  ),
                ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8),
              ),
            );
          }).toList(),
        ),
      );
    }
    return Row(
      children: options.map((option) {
        final isSelected = selectedValue == option;
        return Expanded(
          child: GestureDetector(
            onTap: () => onChanged(option),
            child: Container(
              margin: EdgeInsets.only(right: 8.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.base.withOpacity(0.2)
                    : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.bgLight),
              ),
              child: Center(
                child: AppText(
                  text: option,
                  fontSize: 14,
                  fontWeight: 400,
                  color: isSelected ? AppColors.base : AppColors.black,
                ),
              ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAmenitiesGrid(List<String> currentSelected) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3.5,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 8.h,
      ),
      itemCount: amenitiesList.length,
      itemBuilder: (context, index) {
        final amenity = amenitiesList[index];
        final isSelected = currentSelected.contains(amenity["name"]);
        return GestureDetector(
          onTap: () {
            List<String> newSelected = List.from(currentSelected);
            if (isSelected) {
              newSelected.remove(amenity["name"]);
            } else {
              newSelected.add(amenity["name"]);
            }
            propertyControllers.selectedAmenities.value = newSelected;
            _onFieldChanged();
          },
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected ? AppColors.base : AppColors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.base : AppColors.skyBase,
                  ),
                ),
                child: isSelected
                    ? const AppImage(path: AppAssets.check, size: 15)
                    : null,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: AppText(
                  text: amenity["name"],
                  maxLines: 3,
                  fontWeight: 400,
                  fontSize: 16,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviewSection(String title, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey96,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: AppText(
              text: title,
              fontSize: 14,
              fontWeight: 600,
              color: AppColors.textLight,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: AppText(
              text: value,
              fontSize: 14,
              fontWeight: 400,
              color: AppColors.textLight,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _priceAI() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("AI Price suggestion coming soon!"),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _submitForm() {
    print("=== AddHouseEvent Debug Boshlandi ===");
    print("selectPriceIndex: $selectPriceIndex");
    print("selectPropertyTypeIndex: $selectPropertyTypeIndex");

    if (selectPriceIndex == null) {
      print("❌ selectPriceIndex null!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Iltimos, listing turini tanlang"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectPropertyTypeIndex == null) {
      print("❌ selectPropertyTypeIndex null!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Iltimos, property turini tanlang"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (propertyControllers.selectedImages.value.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Iltimos, kamida bitta rasm tanlang"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      print("🏠 Rasmlar yuklanmoqda...");

      // PROPERTY TYPE ni to'g'ri formatga o'tkazish
      String correctBuildingType;
      switch (propertyType[selectPropertyTypeIndex!]) {
        case 'Villa':
          correctBuildingType = 'VILLA';
          break;
        case 'Appartment':
          correctBuildingType = 'APARTMENT';
          break;
        case 'Pent-house':
          correctBuildingType = 'PENTHOUSE';
          break;
        case 'Land':
          correctBuildingType = 'LAND';
          break;
        default:
          correctBuildingType = 'APARTMENT';
      }

      // FURNISHING ni to'g'ri formatga o'tkazish
      String correctFurnishing = propertyControllers
          .selectedFurnishingStatus
          .value
          .toUpperCase();

      // RENTAL FREQUENCY ni to'g'ri formatga o'tkazish
      String correctRentalFrequency = propertyControllers
          .selectedRentalFrequency
          .value
          .toUpperCase();

      // First upload images, then create the house listing
      context.read<AddHouseBloc>().add(
        AddPhotosUrlEvent(
          photos: propertyControllers.selectedImages.value,
          onSuccess: () {
            print("🎉 Rasmlar muvaffaqiyatli yuklandi");

            final uploaded = context.read<AddHouseBloc>().state.uploadedPhotos;
            print(
              "📋 Yuklangan rasmlar: ${uploaded.map((e) => e.secureUrl).toList()}",
            );

            // Create Photos objects with URLs
            final photosList = uploaded
                .map((photoUrl) => Photo(photo: photoUrl.secureUrl))
                .toList();

            final datum = Datum(
              typeOfSale: selectPriceIndex == 0 ? 'RENT' : 'PURCHASE',
              buildingType: correctBuildingType,
              title: propertyControllers.propertyTitleController.text,
              description: propertyControllers.descriptionController.text,
              numberOfRooms: propertyControllers.numberOfRoomsController.text,
              numberOfBathrooms: int.parse(
                propertyControllers.numberOfBathroomsController.text.isEmpty
                    ? "1"
                    : propertyControllers.numberOfBathroomsController.text,
              ),
              area: int.parse(
                propertyControllers.areaController.text.isEmpty
                    ? "1"
                    : propertyControllers.areaController.text,
              ),
              floor: int.parse(
                propertyControllers.floorController.text.isEmpty
                    ? "1"
                    : propertyControllers.floorController.text,
              ),
              totalFloors: int.parse(
                propertyControllers.totalFloorsController.text.isEmpty
                    ? "1"
                    : propertyControllers.totalFloorsController.text,
              ),
              furnishing: correctFurnishing,
              latitude: 123456,
              longitude: 123456,
              location: propertyControllers.locationController.text,
              locatedNear: propertyControllers.selectedAmenities.value,
              isVip: true,
              youtubeLink: null,
              isVerified: false,
              rentalFrequency: correctRentalFrequency,
              currency: propertyControllers.selectedCurrency.value,
              price: int.parse(
                propertyControllers.priceController.text.isEmpty
                    ? "0"
                    : propertyControllers.priceController.text,
              ),
              photos: photosList, // Use the photos with URLs
            );

            print("📤 Uy ma'lumotlari jo'natilmoqda...");
            print("📋 Photos count: ${photosList.length}");

            context.read<AddHouseBloc>().add(
              AddHouseEvent(
                propertyModel: datum,
                onSuccess: () {
                  if (!mounted)
                    return; // widgets hali ekranda bo‘lmasa chiqib ketadi
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Uy muvaffaqiyatli qo‘shildi!'),
                    ),
                  );
                  context.push(Routes.home);
                  // Navigator.of(context).pop(); // faqat mounted bo‘lsa ishlaydi
                },
                onFailure: () {
                  print("💥 FAILURE CALLBACK!");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Xatolik yuz berdi!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
            );
          },
          onFailure: () {
            print("💥 Rasmlar yuklanmadi!");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Rasmlarni yuklashda xatolik yuz berdi"),
                backgroundColor: Colors.red,
              ),
            );
          },
        ),
      );
    } catch (e) {
      print("💥 Umumiy xatolik: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Ma'lumotlarni tayyorlashda xatolik: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
