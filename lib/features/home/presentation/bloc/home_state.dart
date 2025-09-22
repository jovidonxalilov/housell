import 'package:housell/core/constants/app_status.dart';
import 'package:housell/features/home/data/model/property_model.dart';

class HomeState {
  final PropertyModel? propertyModel;
  final MainStatus mainStatus;
  final MiniStatus miniStatus;
  final String errorMessage;

  HomeState({
    required this.miniStatus,
    required this.mainStatus,
    required this.propertyModel,
    required this.errorMessage,
  });

  factory HomeState.initial() {
    return HomeState(
      miniStatus: MiniStatus.loading,
      mainStatus: MainStatus.initial,
      propertyModel: null,
      errorMessage: ''
    );
  }

  HomeState copyWith({
    MainStatus? mainStatus,
    MiniStatus? miniStatus,
    PropertyModel? propertyModel,
    String? errorMessage
  }) {
    return HomeState(
      miniStatus: miniStatus ?? this.miniStatus,
      mainStatus: mainStatus ?? this.mainStatus,
      propertyModel: propertyModel ?? this.propertyModel,
      errorMessage: errorMessage ??  this.errorMessage
    );
  }
}
