import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/domain/entities/new_phone.dart';
import 'package:housell/features/profile/domain/entities/path_profile.dart';

import '../../../auth/domain/entities/otp.dart';
import '../../../auth/domain/entities/reset_password.dart';

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

class ProfilePhotoUrlEvent extends ProfileEvent {
  final File photos;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  ProfilePhotoUrlEvent({
    required this.photos,
    required this.onSuccess,
    required this.onFailure,
  });
}

class ProfileNewPhoneOtpEvent extends ProfileEvent {
  final NewPhoneE newPhoneE;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  ProfileNewPhoneOtpEvent({
    required this.newPhoneE,
    required this.onSuccess,
    required this.onFailure,
  });
}

class ProfileNewPhoneVerifyOtpEvent extends ProfileEvent {
  final VerifyOtpModel verifyOtpModel;
  final Function(String) onSuccess;
  final VoidCallback onFailure;

  ProfileNewPhoneVerifyOtpEvent({
    required this.verifyOtpModel,
    required this.onSuccess,
    required this.onFailure,
  });
}

class ProfileNewPasswordEvent extends ProfileEvent {
  final ResetPassword newPassword;
  final Function(String) onSuccess;
  final VoidCallback onFailure;

  ProfileNewPasswordEvent({
    required this.newPassword,
    required this.onSuccess,
    required this.onFailure,
  });
}
