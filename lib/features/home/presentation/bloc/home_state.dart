import 'package:housell/core/constants/app_status.dart';
import 'package:housell/features/home/data/model/property_model.dart';

import '../../../profile/data/model/profile_model.dart';

class HomeState {
  final PropertyModel? propertyModel;
  final ProfileModel? profileModel;
  final Datum? datum;
  final MainStatus mainStatus;
  final MiniStatus miniStatus;
  final String errorMessage;

  HomeState({
    required this.miniStatus,
    required this.mainStatus,
    required this.propertyModel,
    required this.errorMessage,
    required this.datum,
    required this.profileModel,
  });

  factory HomeState.initial() {
    return HomeState(
      miniStatus: MiniStatus.loading,
      mainStatus: MainStatus.initial,
      propertyModel: null,
      errorMessage: '',
      datum: null,
      profileModel: null,
    );
  }

  HomeState copyWith({
    MainStatus? mainStatus,
    MiniStatus? miniStatus,
    PropertyModel? propertyModel,
    Datum? datum,
    String? errorMessage,
    ProfileModel? profileModel,
  }) {
    return HomeState(
      datum: datum ?? this.datum,
      miniStatus: miniStatus ?? this.miniStatus,
      mainStatus: mainStatus ?? this.mainStatus,
      propertyModel: propertyModel ?? this.propertyModel,
      errorMessage: errorMessage ?? this.errorMessage,
      profileModel: profileModel ?? this.profileModel,
    );
  }
}
