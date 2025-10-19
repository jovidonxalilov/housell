import 'package:housell/core/either/either.dart';
import 'package:housell/core/error/failure.dart';
import 'package:housell/features/profile/data/datasource/profile_datasource.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/domain/repository/profile_repository.dart';

import '../../../add/data/model/url_photos_model.dart';
import '../../../auth/data/model/otp_model.dart';
import '../../../home/data/model/property_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileDataSource _profileDataSource;

  ProfileRepositoryImpl({required ProfileDataSource profileDataSource})
    : _profileDataSource = profileDataSource;

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
  Future<Either<Failure, ProfileModel>> patchProfile(
    String id,
    ProfileModel profileModel,
  ) async {
    try {
      final result = await _profileDataSource.patchProfile(id, profileModel);
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PhotosUrl>> urlPhotos(Photos photos) async {
    try {
      final result = await _profileDataSource.urlPhotos(photos);
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> sentOtp(
    String phoneNumber,
    String id,
  ) async {
    try {
      final result = await _profileDataSource.sentOtp(phoneNumber, id);
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String id,
  }) async {
    try {
      final result = await _profileDataSource.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
        id: id,
      );
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> newPassword({
    required String oldPassword,
    required String newPassword,
    String? id,
  }) async {
    try {
      final result = await _profileDataSource.newPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        id: id!,
      );
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PropertyModel>> getHousesMy() async {
    try {
      final result = await _profileDataSource.getHousesMy();
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }
}
