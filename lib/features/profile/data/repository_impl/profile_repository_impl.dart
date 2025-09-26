import 'package:housell/core/either/either.dart';
import 'package:housell/core/error/failure.dart';
import 'package:housell/features/profile/data/datasource/profile_datasource.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/domain/repository/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository{

  final ProfileDataSource _profileDataSource;

  ProfileRepositoryImpl({required ProfileDataSource profileDataSource}) : _profileDataSource = profileDataSource;

  @override
  Future<Either<Failure, ProfileModel>> profile() async {
    try {
      final result = await _profileDataSource.profile();
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));

    }
  }

  @override
  Future<Either<Failure, ProfileModel>> patchProfile(String id, ProfileModel profileModel) async {
    try {
      final result = await _profileDataSource.patchProfile(id, profileModel);
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }
}