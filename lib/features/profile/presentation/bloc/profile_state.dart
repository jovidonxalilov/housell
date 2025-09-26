import 'package:housell/core/constants/app_status.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

class ProfileState {
  final ProfileModel? profileModel;
  final MainStatus mainStatus;
  final MiniStatus miniStatus;
  final String? errorMessage;

  ProfileState({
    required this.profileModel,
    required this.miniStatus,
    required this.mainStatus,
    required this.errorMessage,
  });

  factory ProfileState.initial() {
    return ProfileState(
      profileModel: null,
      miniStatus: MiniStatus.loading,
      mainStatus: MainStatus.loading,
      errorMessage: null,
    );
  }

  ProfileState copyWith({
    ProfileModel? profileModel,
    MainStatus? mainStatus,
    MiniStatus? miniStatus,
    String? errorMessage,
  }) {
    return ProfileState(
      profileModel: profileModel ?? this.profileModel,
      miniStatus: miniStatus ?? this.miniStatus,
      mainStatus: mainStatus ?? this.mainStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
