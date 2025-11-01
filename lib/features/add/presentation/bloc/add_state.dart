import 'package:housell/features/add/data/model/url_photos_model.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../../../core/constants/app_status.dart';
import '../../data/model/maker_model.dart';

class AddHouseState {
  final PropertyModel? propertyModel;
  final PhotosUrl? photosUrl; // agar faqat bitta rasm ishlatsang kerak bo‘ladi
  final MaklerModel? maklerModel;
  final Maklers? makler;
  final List<PhotosUrl> uploadedPhotos; // 🔥 ko‘p rasm uchun
  final MainStatus mainStatus;
  final MiniStatus miniStatus;
  final String errorMessage;

  AddHouseState({
    required this.miniStatus,
    required this.mainStatus,
    required this.photosUrl,
    required this.propertyModel,
    required this.errorMessage,
    required this.uploadedPhotos,
    required this.maklerModel,
    required this.makler
  });

  factory AddHouseState.initial() {
    return AddHouseState(
      miniStatus: MiniStatus.loading,
      mainStatus: MainStatus.initial,
      photosUrl: null,
      propertyModel: null,
      errorMessage: "",
      uploadedPhotos: [], // bosh ro‘yxat,
      maklerModel: null,
      makler: null
    );
  }

  AddHouseState copyWith({
    PropertyModel? propertyModel,
    PhotosUrl? photosUrl,
    List<PhotosUrl>? uploadedPhotos,
    MaklerModel? maklerModel,
    Maklers? makler,
    MainStatus? mainStatus,
    MiniStatus? miniStatus,
    String? errorMessage,
  }) {
    return AddHouseState(
      miniStatus: miniStatus ?? this.miniStatus,
      mainStatus: mainStatus ?? this.mainStatus,
      photosUrl: photosUrl ?? this.photosUrl,
      propertyModel: propertyModel ?? this.propertyModel,
      errorMessage: errorMessage ?? this.errorMessage,
      uploadedPhotos: uploadedPhotos ?? this.uploadedPhotos,
      maklerModel: maklerModel ?? this.maklerModel,
      makler: makler ?? this.makler
    );
  }
}

