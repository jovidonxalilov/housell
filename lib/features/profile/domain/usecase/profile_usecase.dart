import 'package:housell/core/either/either.dart';
import 'package:housell/core/usecase/usecase.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/domain/entities/new_phone.dart';
import 'package:housell/features/profile/domain/entities/path_profile.dart';
import 'package:housell/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../add/data/model/url_photos_model.dart';
import '../../../auth/data/model/otp_model.dart';
import '../../../auth/domain/entities/otp.dart';
import '../../../auth/domain/entities/reset_password.dart';
import '../../../home/data/model/property_model.dart';

class ProfileGetUsecase extends UseCase<ProfileModel, NoParams> {

  final ProfileRepository profileRepository;
  ProfileGetUsecase(this.profileRepository);

   @override
   Future<Either<Failure, ProfileModel>> call(NoParams param) {
     return profileRepository.profile();
   }
}

class ProfilePatchUsecase extends UseCase<ProfileModel, ProfilePatchParams> {

  final ProfileRepository profileRepository;

  ProfilePatchUsecase(this.profileRepository);

  @override
  Future<Either<Failure, ProfileModel>> call(ProfilePatchParams params) {
    return profileRepository.patchProfile(params.id, params.profileModel);
  }
}


class ProfilePhotoUrlUsecase extends UseCase<PhotosUrl, Photos> {
  final ProfileRepository profileRepository;

  ProfilePhotoUrlUsecase(this.profileRepository);

  @override
  Future<Either<Failure, PhotosUrl>> call(Photos photos) {
    return profileRepository.urlPhotos(photos);
  }
}

class ProfileNewPhoneOtpUsecase extends UseCase<OtpModel, NewPhoneE> {
  final ProfileRepository profileRepository;

  ProfileNewPhoneOtpUsecase(this.profileRepository);

  @override
  Future<Either<Failure, OtpModel>> call(NewPhoneE param) {
    return profileRepository.sentOtp(param.phoneNumber, param.id);
  }
}
class ProfileNewPhoneVerifyOtpUsecase extends UseCase<OtpModel, VerifyOtpModel> {
  final ProfileRepository profileRepository;

  ProfileNewPhoneVerifyOtpUsecase(this.profileRepository);

  @override
  Future<Either<Failure, OtpModel>> call(VerifyOtpModel param) {
    return profileRepository.verifyOtp(
      phoneNumber: param.phoneNumber,
      otp: param.otp,
      id: param.id!
    );
  }
}

class ProfileNewPasswordUsecase extends UseCase<OtpModel, ResetPassword> {
  final ProfileRepository authRepository;

  ProfileNewPasswordUsecase(this.authRepository);

  @override
  Future<Either<Failure, OtpModel>> call(ResetPassword param) {
    return authRepository.newPassword(
        oldPassword: param.phoneNumber,
      newPassword: param.newPassword,
      id: param.id
    );
  }
}