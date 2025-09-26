import 'package:housell/core/either/either.dart';
import 'package:housell/core/error/failure.dart';
import 'package:housell/features/profile/data/datasource/profile_datasource.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/data/repository_impl/profile_repository_impl.dart';

abstract class ProfileRepository {
   Future<Either<Failure, ProfileModel>> profile();

   Future<Either<Failure, ProfileModel>> patchProfile(String id, ProfileModel profileModel);

   factory ProfileRepository(ProfileDataSource profileDataSource) =>
       ProfileRepositoryImpl(profileDataSource: profileDataSource);
}