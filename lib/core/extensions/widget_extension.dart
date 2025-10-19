import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:housell/core/constants/app_assets.dart';

extension WidgetPaddingX on Widget {
  Widget paddingAll(double padding) =>
      Padding(padding: EdgeInsets.all(padding), child: this);

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) => Padding(
    padding: EdgeInsets.only(
      top: top.h,
      left: left.w,
      right: right.w,
      bottom: bottom.h,
    ),
    child: this,
  );

  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);
}

extension RentalFrequencyExtension on String {
  String toDisplayText() {
    switch (this.toUpperCase()) {
      case 'MONTHLY':
        return 'month';
      case 'YEARLY':
        return 'year';
      case 'WEEKLY':
        return 'week';
      case 'DAILY':
        return 'day';
      case 'QUARTERLY':
        return 'quarter';
      case 'BIANNUALLY':
        return 'Half Year';
      default:
        return this; // Agar mos kelmasa, asl qiymatni qaytaradi
    }
  }

}
// extension_helper.dart yoki utils faylingizda
extension LocatedNearExtension on String {
  String toLocatedNearSvg() {
    switch (this.toLowerCase()) {
      case "hospital, clinic":
        return AppAssets.hospitalP;
      case "entertainment facilities":
        return AppAssets.entertainmentP;
      case "kindergarten":
        return AppAssets.kindergartenP;
      case "restaurant, cafe":
        return AppAssets.restaurantP;
      case "resort/ dormitory":
        return AppAssets.hotelP;
      case "bus stops/metro stations":
        return AppAssets.busP;
      case "supermarket, shops":
        return AppAssets.shopP;
      case "park, green area":
        return AppAssets.busP; // busP emas, parkP bo'lishi kerak
      case "school":
        return AppAssets.schoolP;
      case "playground":
        return AppAssets.playgroundP;
      default:
        return AppAssets.hospitalP; // default icon
    }
  }
}


extension NullCheckExtension on String? {
  String get orQoshilmagan => this ?? "qo'shilmagan";

  String orDefault([String defaultValue = "qo'shilmagan"]) {
    return this ?? defaultValue;
  }

  String get orEmpty => this ?? "";

  bool get isNullOrEmpty => this == null || this!.isEmpty;
}
