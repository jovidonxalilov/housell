import 'package:flutter/cupertino.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/domain/entities/path_profile.dart';

class ProfileEvent {}

class ProfileGetMeEvent extends ProfileEvent {}

class ProfilePatchEvent extends ProfileEvent {
  final ProfilePatchParams patchParams;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  ProfilePatchEvent({
    required this.patchParams,
    required this.onFailure,
    required this.onSuccess,
  });
}
