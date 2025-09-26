import 'package:housell/core/either/either.dart';
import 'package:housell/core/usecase/usecase.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/domain/entities/path_profile.dart';
import 'package:housell/features/profile/domain/repository/profile_repository.dart';

import '../../../../core/error/failure.dart';

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