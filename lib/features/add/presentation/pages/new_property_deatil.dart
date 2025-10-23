import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:housell/config/theme/app_colors.dart';
import 'package:housell/core/constants/app_assets.dart';
import 'package:housell/core/extensions/widget_extension.dart';
import 'package:housell/core/widgets/app_image.dart';
import 'package:housell/core/widgets/app_text.dart';
import 'package:housell/core/widgets/w__container.dart';
import 'package:housell/core/widgets/w_text_form.dart';
import 'package:housell/core/widgets/w_validator.dart';

// class PropertyFormScreen extends StatefulWidget {
//   final TextEditingController propertyTitleController;
//   final TextEditingController descriptionController;
//   final TextEditingController numberOfRoomsController;
//   final TextEditingController numberOfBathroomsController;
//   final TextEditingController areaController;
//   final TextEditingController floorController;
//   final TextEditingController totalFloorsController;
//   final TextEditingController locationController;
//   final TextEditingController priceController;
//
//   const PropertyFormScreen({
//     super.key,
//     required this.priceController,
//     required this.numberOfRoomsController,
//     required this.propertyTitleController,
//     required this.descriptionController,
//     required this.numberOfBathroomsController,
//     required this.areaController,
//     required this.floorController,
//     required this.totalFloorsController,
//     required this.locationController,
//   });
//
//   @override
//   State<PropertyFormScreen> createState() => _PropertyFormScreenState();
// }
//
// class _PropertyFormScreenState extends State<PropertyFormScreen> {
//   // Text Controllers
//
//   // 🔥 State variables with ValueNotifier
//   final ValueNotifier<int> selectedStudio = ValueNotifier<int>(0);
//   final ValueNotifier<int> selectedBathrooms = ValueNotifier<int>(1);
//   final ValueNotifier<String> selectedFurnishingStatus = ValueNotifier<String>(
//     "Furnished",
//   );
//   final ValueNotifier<String> selectedRentalFrequency = ValueNotifier<String>(
//     "Yearly",
//   );
//   final ValueNotifier<String> selectedCurrency = ValueNotifier<String>("USD");
//   final ValueNotifier<List<String>> selectedAmenities =
//       ValueNotifier<List<String>>([]);
//
//   // Amenities list
//   final List<Map<String, dynamic>> amenitiesList = [
//     {"name": "Hospital, clinic", "selected": false},
//     {"name": "Entertainment facilities", "selected": false},
//     {"name": "Kindergarten", "selected": false},
//     {"name": "Restaurant, facilities", "selected": false},
//     {"name": "Resort, farmhouse", "selected": false},
//     {"name": "Shops, shopping mall", "selected": false},
//     {"name": "Supermarket, shops", "selected": false},
//     {"name": "Park, green area", "selected": false},
//     {"name": "School", "selected": false},
//     {"name": "Playground", "selected": false},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         // Number of rooms
//         _buildSectionTitle("Title", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.propertyTitleController,
//           richText: true,
//           hintText: "Enter Property Title",
//           keyboardType: TextInputType.text,
//           validator: (value) {
//             return SimpleValidators.validateText(value, minLength: 10);
//           },
//         ),
//         SizedBox(height: 20.h),
//         _buildSectionTitle("Description", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.descriptionController,
//           richText: true,
//           validator: (value) {
//             return SimpleValidators.validateText(value, minLength: 50);
//           },
//           hintText: "Enter Property Description",
//           maxLines: 3,
//           keyboardType: TextInputType.text,
//         ),
//         SizedBox(height: 20.h),
//         _buildSectionTitle("Number of rooms", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.numberOfRoomsController,
//           richText: true,
//           hintText: "Enter number of rooms",
//           keyboardType: TextInputType.number,
//           // validator: (value) {
//           //   return SimpleValidators.validateText(value, minLength: 10);
//           // },
//         ),
//         SizedBox(height: 8.h),
//         ValueListenableBuilder<int>(
//           valueListenable: selectedStudio,
//           builder: (context, value, _) {
//             return _buildNumberSelector(
//               controller: widgets.numberOfRoomsController,
//               selectedValue: value,
//               maxValue: 5,
//               onChanged: (v) => selectedStudio.value = v,
//             );
//           },
//         ),
//         SizedBox(height: 20.h),
//
//         // Number of bathrooms
//         _buildSectionTitle("Number of bathrooms", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.numberOfBathroomsController,
//           hintText: "Enter number of bathrooms",
//           validator: (value) {
//             return SimpleValidators.numberInRange(value, min: 1, max: 15);
//           },
//           keyboardType: TextInputType.number,
//         ),
//         SizedBox(height: 8.h),
//         ValueListenableBuilder<int>(
//           valueListenable: selectedBathrooms,
//           builder: (context, value, _) {
//             return _buildNumberSelector(
//               showStudio: false,
//               controller: widgets.numberOfBathroomsController,
//               selectedValue: value,
//               maxValue: 3,
//               onChanged: (v) => selectedBathrooms.value = v,
//             );
//           },
//         ),
//         SizedBox(height: 20.h),
//
//         // Area
//         _buildSectionTitle("Area m²", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.areaController,
//           hintText: "e.g. 150 m²",
//           keyboardType: TextInputType.number,
//         ),
//         SizedBox(height: 20.h),
//
//         // Floor
//         _buildSectionTitle("Floor", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.floorController,
//           hintText: "e.g. 5",
//           keyboardType: TextInputType.number,
//         ),
//         SizedBox(height: 20.h),
//
//         // Total floors
//         _buildSectionTitle("Enter total residential floors", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.totalFloorsController,
//           hintText: "e.g., 4",
//           keyboardType: TextInputType.number,
//         ),
//         SizedBox(height: 20.h),
//
//         // Furnishing Status
//         _buildSectionTitle("Furnishing Status", isRequired: true),
//         SizedBox(height: 8.h),
//         ValueListenableBuilder<String>(
//           valueListenable: selectedFurnishingStatus,
//           builder: (context, value, _) {
//             return buildSelectableContainerGroup(
//               options: ["Furnished", "Unfurnished"],
//               selectedValues: value,
//               onChanged: (v) => selectedFurnishingStatus.value = v,
//             );
//           },
//         ),
//         SizedBox(height: 20.h),
//
//         // Location
//         _buildSectionTitle("Location", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.floorController,
//           hintText: "e.g., Downtown Manhattan, NYC",
//           keyboardType: TextInputType.number,
//           richText: true,
//         ),
//         SizedBox(height: 20.h),
//
//         // Located nearby
//         _buildSectionTitle("Located nearby"),
//         SizedBox(height: 12.h),
//         ValueListenableBuilder<List<String>>(
//           valueListenable: selectedAmenities,
//           builder: (context, value, _) {
//             return _buildAmenitiesGrid(value);
//           },
//         ),
//         SizedBox(height: 20.h),
//
//         // Rental Frequency
//         _buildSectionTitle("Rental Frequency", isRequired: true),
//         SizedBox(height: 8.h),
//         ValueListenableBuilder<String>(
//           valueListenable: selectedRentalFrequency,
//           builder: (context, value, _) {
//             return buildSelectableContainerGroup(
//               options: ["Yearly", "Monthly", "Weekly", "Daily"],
//               selectedValues: value,
//               onChanged: (v) => selectedRentalFrequency.value = v,
//               // isHorizontal: true,
//             );
//           },
//         ),
//         SizedBox(height: 20.h),
//
//         // Currency
//         _buildSectionTitle("Currency"),
//         SizedBox(height: 8.h),
//         ValueListenableBuilder<String>(
//           valueListenable: selectedCurrency,
//           builder: (context, value, _) {
//             return buildSelectableContainerGroup(
//               options: ["USD", "UZS"],
//               selectedValues: value,
//               isExpanded: false,
//               onChanged: (v) => selectedCurrency.value = v,
//             );
//           },
//         ),
//         SizedBox(height: 20.h),
//
//         // Price
//         _buildSectionTitle("Price", isRequired: true),
//         SizedBox(height: 8.h),
//         _buildTextField(
//           controller: widgets.priceController,
//           hintText: "2 300",
//           suffixWidget: ContainerW(
//             width: 104.w,
//             height: 36.h,
//             radius: 8,
//             color: AppColors.base.withOpacity(0.2),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 AppImage(path: AppAssets.flash),
//                 AppText(text: "Price Ai", fontSize: 14, fontWeight: 500),
//               ],
//             ),
//           ).paddingOnly(top: 4, right: 4, bottom: 4),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildAmenitiesGrid(List<String> currentSelected) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//         childAspectRatio: 3.5,
//         crossAxisSpacing: 8.w,
//         mainAxisSpacing: 8.h,
//       ),
//       itemCount: amenitiesList.length,
//       itemBuilder: (context, index) {
//         final amenity = amenitiesList[index];
//         final isSelected = currentSelected.contains(amenity["name"]);
//         return GestureDetector(
//           onTap: () {
//             if (isSelected) {
//               currentSelected.remove(amenity["name"]);
//             } else {
//               currentSelected.add(amenity["name"]);
//             }
//             selectedAmenities.value = List.from(currentSelected);
//           },
//           child: Row(
//             children: [
//               Container(
//                 width: 24.w,
//                 height: 24.h,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(4),
//                   // shape: BoxShape,
//                   color: isSelected ? AppColors.base : AppColors.white,
//                   border: Border.all(
//                     color: isSelected ? AppColors.base : AppColors.skyBase,
//                   ),
//                 ),
//                 child: isSelected
//                     ? const AppImage(path: AppAssets.check, size: 15)
//                     : null,
//               ),
//               SizedBox(width: 8.w),
//               Expanded(
//                 child: AppText(
//                   text: amenity["name"],
//                   maxLines: 3,
//                   fontWeight: 400,
//                   fontSize: 16,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ),
//             ],
//           ),
//           // child: Container(
//           //   padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
//           //   decoration: BoxDecoration(
//           //     color: isSelected ? Colors.purple.withOpacity(0.1) : Colors.white,
//           //     borderRadius: BorderRadius.circular(8),
//           //     border: Border.all(
//           //       color: isSelected ? Colors.purple : Colors.grey[300]!,
//           //     ),
//           //   ),
//           //   child: Row(
//           //     children: [
//           //       Container(
//           //         width: 16.w,
//           //         height: 16.h,
//           //         decoration: BoxDecoration(
//           //           shape: BoxShape.circle,
//           //           color: isSelected ? Colors.purple : Colors.white,
//           //           border: Border.all(
//           //             color: isSelected ? Colors.purple : Colors.grey[400]!,
//           //           ),
//           //         ),
//           //         child: isSelected
//           //             ? const Icon(Icons.check, color: Colors.white, size: 12)
//           //             : null,
//           //       ),
//           //       SizedBox(width: 8.w),
//           //       Expanded(
//           //         child: Text(
//           //           amenity["name"],
//           //           style: TextStyle(
//           //             fontSize: 12,
//           //             color: isSelected ? Colors.purple : Colors.black,
//           //           ),
//           //           overflow: TextOverflow.ellipsis,
//           //         ),
//           //       ),
//           //     ],
//           //   ),
//           // ),
//         );
//       },
//     );
//   }
//
//   Widget _buildSectionTitle(String title, {String? subtitle, bool isRequired = false}) {
//     return Row(
//       children: [
//         AppText(
//           text: title,
//           fontSize: 16,
//           fontWeight: 600,
//           color: AppColors.textC,
//         ),
//         if (isRequired)
//           Text(
//             ' *',
//             style: TextStyle(color: Colors.red, fontSize: 16),
//           ),
//       ],
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     int maxLines = 1,
//     TextInputType? keyboardType,
//     bool richText = false,
//     Widget? suffixWidget,
//     String? Function(String?)? validator,
//   }) {
//     return WTextField(
//       suffixIconWidget: suffixWidget,
//       controller: controller,
//       maxLines: maxLines,
//       validator: validator,
//       keyboardType: keyboardType,
//       hintText: hintText,
//       richText: richText,
//       hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
//       borderRadius: 12,
//       // filled: true,
//       fillColor: AppColors.bg,
//       borderColor: AppColors.bgLight,
//       contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//     );
//   }
//
//   Widget _buildNumberSelector({
//     required int selectedValue,
//     required int maxValue,
//     required Function(int) onChanged,
//     required TextEditingController controller,
//     bool showStudio = true,
//   }) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         children: List.generate(showStudio ? maxValue + 1 : maxValue, (index) {
//           final value = showStudio ? index : index + 1;
//           final label = (showStudio && index == 0)
//               ? "Studio"
//               : value.toString();
//
//           return GestureDetector(
//             onTap: () {
//               onChanged(value);
//               controller.text = label;
//             },
//             child: Container(
//               height: 36,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: AppColors.bgLight),
//                 color: selectedValue == value
//                     ? AppColors.base.withOpacity(0.2)
//                     : AppColors.white,
//               ),
//               margin: const EdgeInsets.only(right: 8),
//               child: Center(
//                 child: AppText(
//                   text: label,
//                   fontWeight: 400,
//                   fontSize: 14,
//                   color: selectedValue == value
//                       ? AppColors.base
//                       : AppColors.black,
//                 ),
//               ).paddingOnly(top: 8, left: 16, right: 16, bottom: 8),
//             ),
//           );
//         }),
//       ),
//     );
//   }
//
//   Widget buildSelectableContainerGroup({
//     required List<String> options,
//     required String selectedValues,
//     required Function(String) onChanged,
//     bool isExpanded = true,
//   }) {
//     if (isExpanded) {
//       return SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: options.map((option) {
//             final isSelected = selectedValues.contains(option);
//             return GestureDetector(
//               onTap: () => onChanged(option),
//               child: Container(
//                 margin: EdgeInsets.only(right: 8.w),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? AppColors.base.withOpacity(0.2)
//                       : AppColors.white,
//                   borderRadius: BorderRadius.circular(8),
//                   border: Border.all(color: AppColors.bgLight),
//                 ),
//                 // radius: 8,
//                 child: Center(
//                   child: AppText(
//                     text: option,
//                     fontSize: 14,
//                     fontWeight: 400,
//                     color: isSelected ? AppColors.base : AppColors.black,
//                   ),
//                 ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8),
//               ),
//             );
//           }).toList(),
//         ),
//       );
//     }
//     return Row(
//       children: options.map((option) {
//         final isSelected = selectedValues.contains(option);
//         return Expanded(
//           child: GestureDetector(
//             onTap: () => onChanged(option),
//             child: Container(
//               margin: EdgeInsets.only(right: 8.w),
//               decoration: BoxDecoration(
//                 color: isSelected
//                     ? AppColors.base.withOpacity(0.2)
//                     : AppColors.white,
//                 borderRadius: BorderRadius.circular(8),
//                 border: Border.all(color: AppColors.bgLight),
//               ),
//               // radius: 8,
//               child: Center(
//                 child: AppText(
//                   text: option,
//                   fontSize: 14,
//                   fontWeight: 400,
//                   color: isSelected ? AppColors.base : AppColors.black,
//                 ),
//               ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   void _submitForm() {
//     // Form validation va submit logic
//     // print("Property Title: ${propertyTitleController.text}");
//     // print("Description: ${descriptionController.text}");
//     // print("Number of Rooms: ${numberOfRoomsController.text}");
//     // print("Studio: $selectedStudio");
//     // print("Number of Bathrooms: ${numberOfBathroomsController.text}");
//     // print("Selected Bathrooms: $selectedBathrooms");
//     // print("Area: ${areaController.text}");
//     // print("Floor: ${floorController.text}");
//     // print("Total Floors: ${totalFloorsController.text}");
//     // print("Furnishing Status: $selectedFurnishingStatus");
//     // print("Location: ${locationController.text}");
//     // print("Rental Frequency: $selectedRentalFrequency");
//     // print("Currency: $selectedCurrency");
//     // print("Price: ${priceController.text}");
//     // print("Selected Amenities: $selectedAmenities");
//
//     // Success message
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Property submitted successfully!"),
//         backgroundColor: Colors.green,
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     widgets.propertyTitleController.dispose();
//     widgets.descriptionController.dispose();
//     widgets.numberOfRoomsController.dispose();
//     widgets.numberOfBathroomsController.dispose();
//     widgets.areaController.dispose();
//     widgets.floorController.dispose();
//     widgets.totalFloorsController.dispose();
//     widgets.locationController.dispose();
//     widgets.priceController.dispose();
//     super.dispose();
//   }
// }



// Controllers class

class PropertyFormControllers {
  // Text controllers
  final TextEditingController propertyTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController numberOfRoomsController = TextEditingController();
  final TextEditingController numberOfBathroomsController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController floorController = TextEditingController();
  final TextEditingController totalFloorsController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Value controllers with default values
  final ValueNotifier<int> selectedStudio = ValueNotifier<int>(0); // Default: Studio
  final ValueNotifier<int> selectedBathrooms = ValueNotifier<int>(1); // Default: 1 bathroom
  final ValueNotifier<String> selectedFurnishingStatus = ValueNotifier<String>("Furnished"); // Default: Furnished
  final ValueNotifier<String> selectedRentalFrequency = ValueNotifier<String>("Yearly"); // Default: Yearly
  final ValueNotifier<String> selectedCurrency = ValueNotifier<String>("USD"); // Default: USD
  final ValueNotifier<List<String>> selectedAmenities = ValueNotifier<List<String>>([]); // Default: empty

  // Images list - ValueNotifier sifatida o'zgartirildi
  final ValueNotifier<List<File>> selectedImages = ValueNotifier<List<File>>([]);

  // Validation callback - optional
  final Function(bool isValid)? onValidationChanged;

  // Constructor
  PropertyFormControllers({this.onValidationChanged});

  // Get all form data as Map
  Map<String, dynamic> getFormData() {
    return {
      'propertyTitle': propertyTitleController.text,
      'description': descriptionController.text,
      'numberOfRooms': numberOfRoomsController.text,
      'numberOfBathrooms': numberOfBathroomsController.text,
      'area': areaController.text,
      'floor': floorController.text.isEmpty ? null : floorController.text,
      'totalFloors': totalFloorsController.text.isEmpty ? null : totalFloorsController.text,
      'location': locationController.text,
      'price': priceController.text,
      'selectedStudio': selectedStudio.value,
      'selectedBathrooms': selectedBathrooms.value,
      'furnishingStatus': selectedFurnishingStatus.value,
      'rentalFrequency': selectedRentalFrequency.value,
      'currency': selectedCurrency.value,
      'amenities': selectedAmenities.value,
      'selectedImages': selectedImages.value,
    };
  }
  //
  // // Rasm qo'shish
  void addImage(File image) {
    List<File> currentImages = List.from(selectedImages.value);
    currentImages.add(image);
    selectedImages.value = currentImages;
    _validateForm();
  }
  //
  // // Rasm o'chirish
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.value.length) {
      List<File> currentImages = List.from(selectedImages.value);
      currentImages.removeAt(index);
      selectedImages.value = currentImages;
      _validateForm();
    }
  }

  // Barcha rasmlarni o'chirish
  void clearImages() {
    selectedImages.value = [];
    _validateForm();
  }
  //
  // // Form validatsiya
  void _validateForm() {
    if (onValidationChanged != null) {
      bool isValid = _isFormValid();
      onValidationChanged!(isValid);
    }
  }

  // Form to'liq to'ldirilganligini tekshirish
  bool _isFormValid() {
    return propertyTitleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        numberOfRoomsController.text.isNotEmpty &&
        areaController.text.isNotEmpty &&
        locationController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedImages.value.isNotEmpty; // Kamida bitta rasm bo'lishi kerak
  }

  // Manual validation trigger
  // void validateForm() {
  //   _validateForm();
  // }

  // Reset all values to defaults
  void reset() {
    // Clear text controllers
    propertyTitleController.clear();
    descriptionController.clear();
    numberOfRoomsController.clear();
    numberOfBathroomsController.clear();
    areaController.clear();
    floorController.clear();
    totalFloorsController.clear();
    locationController.clear();
    priceController.clear();

    // Reset to default values
    selectedStudio.value = 0;
    selectedBathrooms.value = 1;
    selectedFurnishingStatus.value = "Furnished";
    selectedRentalFrequency.value = "Yearly";
    selectedCurrency.value = "USD";
    selectedAmenities.value = [];
    selectedImages.value = []; // Rasmlarni ham tozalash

    // Validatsiyani yangilash
    _validateForm();
  }

  // Dispose all controllers
  void dispose() {
    // Text controllers
    propertyTitleController.dispose();
    descriptionController.dispose();
    numberOfRoomsController.dispose();
    numberOfBathroomsController.dispose();
    areaController.dispose();
    floorController.dispose();
    totalFloorsController.dispose();
    locationController.dispose();
    priceController.dispose();

    // Value notifiers
    selectedStudio.dispose();
    selectedBathrooms.dispose();
    selectedFurnishingStatus.dispose();
    selectedRentalFrequency.dispose();
    selectedCurrency.dispose();
    selectedAmenities.dispose();
    selectedImages.dispose();
  }
}
class PropertyFormScreen extends StatefulWidget {
  final PropertyFormControllers controllers;
  final VoidCallback? onChanged;
  final Function(bool isValid)? onValidationChanged;

  const PropertyFormScreen({
    super.key,
    required this.controllers,
    this.onChanged,
    this.onValidationChanged,
  });

  @override
  State<PropertyFormScreen> createState() => _PropertyFormScreenState();
}

class _PropertyFormScreenState extends State<PropertyFormScreen> {
  final List<Map<String, dynamic>> amenitiesList = [
    {"name": "Hospital, clinic", "selected": false},
    {"name": "Entertainment facilities", "selected": false},
    {"name": "Kindergarten", "selected": false},
    {"name": "Restaurant, facilities", "selected": false},
    {"name": "Resort, farmhouse", "selected": false},
    {"name": "Shops, shopping mall", "selected": false},
    {"name": "Supermarket, shops", "selected": false},
    {"name": "Park, green area", "selected": false},
    {"name": "School", "selected": false},
    {"name": "Playground", "selected": false},
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkValidation();
    _addListeners();
  }

  void _addListeners() {
    final c = widget.controllers;

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
    c.selectedImages.addListener(_checkValidation);
  }

  void _onFieldChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!();
    }
    _checkValidation();
  }

  @override
  void dispose() {
    _removeListeners();
    super.dispose();
  }

  void _removeListeners() {
    final c = widget.controllers;

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
    c.selectedImages.removeListener(_checkValidation);
  }

  // Validatsiya tekshirish
  void _checkValidation() {
    bool isValid = widget.controllers.selectedImages.value.length >= 3;
    widget.onValidationChanged?.call(isValid);
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage();

      if (images != null && images.isNotEmpty) {
        for (XFile image in images) {
          widget.controllers.addImage(File(image.path));
        }

        _showSuccessMessage(images.length);
      }
    } catch (e) {
      _showErrorMessage('Rasmlarni yuklashda xatolik yuz berdi');
      print('Xatolik: $e');
    }
  }

  // Rasmni o'chirish
  void _removeImage(int index) {
    widget.controllers.removeImage(index);
  }

  // Muvaffaqiyat xabari
  void _showSuccessMessage(int count) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$count ta rasm qo\'shildi'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Xatolik xabari
  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controllers;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          text: "Add Photos",
          color: AppColors.black,
          fontWeight: 700,
          fontSize: 20,
        ),
        SizedBox(height: 8.h),
        AppText(
          text: "Add at least one photo of your property",
          color: AppColors.light,
          fontWeight: 400,
          fontSize: 16,
        ),
        SizedBox(height: 24.h),
        DottedBorder(
          options: RoundedRectDottedBorderOptions(
            radius: Radius.circular(16),
            color: AppColors.primary,
            strokeWidth: 2,
            dashPattern: [6, 4],
            padding: EdgeInsets.all(2),
          ),
          child: ContainerW(
            width: double.infinity.w,
            height: 225.h,
            radius: 16,
            color: AppColors.primary.withOpacity(0.2),
            onTap: _pickMultipleImages,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppImage(path: AppAssets.camera),
                SizedBox(height: 12.h),
                AppText(
                  text: "Add Photos",
                  color: AppColors.primary,
                  fontWeight: 600,
                  fontSize: 18,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24.h),

        // ValueListenableBuilder bilan tanlangan rasmlar grid
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
                            color: AppColors.primary,
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
              return SimpleValidators.notEmptyIfFilled(value, errorText: "Uy maydonini kiriting");
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
              return SimpleValidators.notEmptyIfFilled(value, errorText: "Uy qavatini kiriting");
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
              return SimpleValidators.notEmptyIfFilled(value, errorText: "Umumiy turar joy qavatlarini kiriting");
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
                return SimpleValidators.validateText(value, errorText: "Uy manzilini kiriting kamida 5 ta harf", minLength: 5);
              }
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
              return SimpleValidators.notEmptyIfFilled(value, errorText: "Uy narxini kiriting");
            },
            suffixWidget: ContainerW(
              width: 104.w,
              onTap: _priceAI,
              height: 36.h,
              radius: 8,
              color: AppColors.primary.withOpacity(0.2),
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
            widget.controllers.selectedAmenities.value = newSelected;
            _onFieldChanged();
          },
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isSelected ? AppColors.primary : AppColors.white,
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.skyBase,
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

  Widget _buildSectionTitle(String title, {bool isRequired = false}) {
    return Row(
      children: [
        AppText(
          text: title,
          fontSize: 16,
          fontWeight: 600,
          color: AppColors.textC,
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
      ],
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
          final label = (showStudio && index == 0) ? "Studio" : value.toString();

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
                    ? AppColors.primary.withOpacity(0.2)
                    : AppColors.white,
              ),
              margin: const EdgeInsets.only(right: 8),
              child: Center(
                child: AppText(
                  text: label,
                  fontWeight: 400,
                  fontSize: 14,
                  color: selectedValue == value ? AppColors.primary : AppColors.black,
                ),
              ).paddingOnly(top: 8, left: 16, right: 16, bottom: 8),
            ),
          );
        }),
      ),
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
                  color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.bgLight),
                ),
                child: Center(
                  child: AppText(
                    text: option,
                    fontSize: 14,
                    fontWeight: 400,
                    color: isSelected ? AppColors.primary : AppColors.black,
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
                color: isSelected ? AppColors.primary.withOpacity(0.2) : AppColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.bgLight),
              ),
              child: Center(
                child: AppText(
                  text: option,
                  fontSize: 14,
                  fontWeight: 400,
                  color: isSelected ? AppColors.primary : AppColors.black,
                ),
              ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8),
            ),
          ),
        );
      }).toList(),
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
}



class PropertyFormValidator {
  // Barcha majburiy maydonlarni tekshirish
  static bool isFormValid({
    required String propertyTitle,
    required String description,
    required String numberOfRooms,
    required String numberOfBathrooms,
    required String area,
    required String location,
    required String price,
    required String furnishingStatus,
    required String rentalFrequency,
    // Ixtiyoriy maydonlar
    String? floor,
    String? totalFloors,
  }) {
    // Majburiy maydonlar
    List<bool> requiredFields = [
      // Text maydonlar
      propertyTitle.trim().isNotEmpty && propertyTitle.trim().length >= 10,
      description.trim().isNotEmpty && description.trim().length >= 50,
      location.trim().isNotEmpty,

      // Son maydonlar
      numberOfRooms.isNotEmpty && int.tryParse(numberOfRooms) != null,
      numberOfBathrooms.isNotEmpty && int.tryParse(numberOfBathrooms) != null,
      area.isNotEmpty && double.tryParse(area) != null && double.parse(area) > 0,
      price.isNotEmpty && double.tryParse(price) != null && double.parse(price) > 0,

      // Selector'lar
      furnishingStatus.isNotEmpty,
      rentalFrequency.isNotEmpty,
    ];

    // Ixtiyoriy maydonlar - agar to'ldirilgan bo'lsa, to'g'ri format bo'lishi kerak
    List<bool> optionalFields = [
      floor == null || floor.isEmpty || (int.tryParse(floor) != null && int.parse(floor) > 0),
      totalFloors == null || totalFloors.isEmpty || (int.tryParse(totalFloors) != null && int.parse(totalFloors) > 0),
    ];

    // Mantiqiy tekshiruvlar
    List<bool> logicalValidations = [
      _validateFloorLogic(floor, totalFloors),
    ];

    return requiredFields.every((field) => field) &&
        optionalFields.every((field) => field) &&
        logicalValidations.every((validation) => validation);
  }

  static bool _validateFloorLogic(String? floor, String? totalFloors) {
    if ((floor == null || floor.isEmpty) && (totalFloors == null || totalFloors.isEmpty)) {
      return true; // Ikkalasi ham bo'sh - OK
    }

    if ((floor != null && floor.isNotEmpty) && (totalFloors == null || totalFloors.isEmpty)) {
      return false; // Floor bor, totalFloors yo'q
    }

    if ((floor == null || floor.isEmpty) && (totalFloors != null && totalFloors.isNotEmpty)) {
      return false; // TotalFloors bor, floor yo'q
    }

    // Ikkalasi ham to'ldirilgan
    int? floorNum = int.tryParse(floor ?? '');
    int? totalFloorsNum = int.tryParse(totalFloors ?? '');

    if (floorNum != null && totalFloorsNum != null) {
      return floorNum <= totalFloorsNum && floorNum > 0;
    }

    return false;
  }
}

