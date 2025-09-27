import 'dart:ui';

import 'package:housell/features/home/data/model/property_model.dart';

sealed class HomeEvent {}

class HomeGetHousesLoading extends HomeEvent {
  final PropertyModel? propertyModel;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  HomeGetHousesLoading({
    required this.propertyModel,
    required this.onFailure,
    required this.onSuccess,
  });
}

class HomeGetHousesIdEvent extends HomeEvent {
  final String id;

  HomeGetHousesIdEvent({ required this.id});
}
