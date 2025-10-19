import 'package:housell/core/either/either.dart';
import 'package:housell/core/error/failure.dart';
import 'package:housell/features/profile/data/datasource/profile_datasource.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';
import 'package:housell/features/profile/data/repository_impl/profile_repository_impl.dart';

import '../../../add/data/model/url_photos_model.dart';
import '../../../auth/data/model/otp_model.dart';
import '../../../home/data/model/property_model.dart';

abstract class ProfileRepository {
   Future<Either<Failure, ProfileModel>> profile();

   Future<Either<Failure, ProfileModel>> patchProfile(String id, ProfileModel profileModel);

   Future<Either<Failure, PhotosUrl>> urlPhotos(Photos photos);
   Future<Either<Failure, OtpModel>> sentOtp(String phoneNumber, String id);
   Future<Either<Failure, OtpModel>> verifyOtp({
      required String phoneNumber,
      required String otp,
      required String id
   });

   Future<Either<Failure, OtpModel>> newPassword({
      required String oldPassword,
      required String newPassword,
      String? id
   });

   Future<Either<Failure, PropertyModel>> getHousesMy();




   factory ProfileRepository(ProfileDataSource profileDataSource) =>
       ProfileRepositoryImpl(profileDataSource: profileDataSource);
}