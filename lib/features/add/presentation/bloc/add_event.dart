import 'dart:io';
import 'dart:ui';

import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

sealed class AddEvent {}

class AddHouseEvent extends AddEvent {
  final Datum propertyModel;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  AddHouseEvent({
    required this.propertyModel,
    required this.onSuccess,
    required this.onFailure,
  });
}

class AddPhotosUrlEvent extends AddEvent {
  final List<File> photos;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  AddPhotosUrlEvent({
    required this.photos,
    required this.onSuccess,
    required this.onFailure,
  });
}

class AddGetMaklersEvent extends AddEvent {

  AddGetMaklersEvent();
}
