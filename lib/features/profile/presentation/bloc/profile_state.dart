import 'package:housell/core/constants/app_status.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../../add/data/model/url_photos_model.dart';
import '../../../auth/data/model/otp_model.dart';
import '../../../home/data/model/property_model.dart';

class ProfileState {
  final ProfileModel? profileModel;
  final PhotosUrl? uploadedPhotos; // 🔥 ko‘p rasm uchun
  final PropertyModel? propertyModel;

  final OtpModel? otpModel;
  final String? phoneNumber;

  final MainStatus mainStatus;
  final MiniStatus miniStatus;
  final String? errorMessage;

  ProfileState({
    required this.profileModel,
    required this.propertyModel,
    required this.uploadedPhotos,
    required this.miniStatus,
    required this.mainStatus,
    required this.errorMessage,
    required this.otpModel,
    required this.phoneNumber,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profileModel: null,
      uploadedPhotos: null,
      miniStatus: MiniStatus.loading,
      mainStatus: MainStatus.initial,
      errorMessage: null,
      otpModel: null,
      phoneNumber: null,
      propertyModel: null,
    );
  }

  ProfileState copyWith({
    ProfileModel? profileModel,
    PhotosUrl? uploadedPhotos, // 🔥 ko‘p rasm uchun
    MainStatus? mainStatus,
    MiniStatus? miniStatus,
    String? errorMessage,
    PropertyModel? propertyModel,
    OtpModel? otpModel,
    String? phoneNumber,
  }) {
    return ProfileState(
      profileModel: profileModel ?? this.profileModel,
      uploadedPhotos: uploadedPhotos ?? this.uploadedPhotos,
      miniStatus: miniStatus ?? this.miniStatus,
      mainStatus: mainStatus ?? this.mainStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      otpModel: otpModel ?? this.otpModel,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      propertyModel: propertyModel ?? this.propertyModel,
    );
  }
}
