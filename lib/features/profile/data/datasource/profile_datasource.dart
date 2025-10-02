import 'package:dio/dio.dart';
import 'package:housell/core/constants/api_urls.dart';
import 'package:housell/core/dio/dio_client.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../../../core/error/failure.dart';
import '../../../add/data/model/url_photos_model.dart';
import '../../../auth/data/model/otp_model.dart';
import '../../../home/data/model/property_model.dart';

abstract class ProfileDataSource {

  Future<ProfileModel> profile();
  Future<OtpModel> sentOtp(String phoneNumber, String id);
  Future<OtpModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String id
  });

  Future<ProfileModel> patchProfile(String id, ProfileModel profileModel);
  Future<PhotosUrl> urlPhotos(Photos photos);
  Future<OtpModel> newPassword({
    required String oldPassword,
    required String newPassword,
    required String id
  });

  factory ProfileDataSource(DioClient dioClient) =>
      ProfileDataSourceImpl(dioClient: dioClient);

}

class ProfileDataSourceImpl implements ProfileDataSource {

  final DioClient _dioClient;
  ProfileDataSourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<ProfileModel> profile() async {
    try {
      final mainModel = await _dioClient.get(ApiUrls.profile,);
      if (mainModel.ok && mainModel.result != null) {
        return ProfileModel.fromMap(mainModel.result);
      }
      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    }catch (e) {
      print("Profile malumotlarini olib kelishda xatolik: $e");
      throw Exception("Profile malumotlarini olib kelishda xatolik: $e");

    }
  }

    @override
    Future<ProfileModel> patchProfile(String id, ProfileModel profileModel) async {
      try {
        final mainModel = await _dioClient.patch( "${ApiUrls.patchProfile}/$id", data: profileModel.toMap(),);
        if (mainModel.ok && mainModel.result != null) {
          return ProfileModel.fromMap(mainModel.result);
        }
        throw ApiException(
          "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
        );
      } catch (e) {
        print("Profile malumotlarini yangilashda xatolik: $e");
        throw Exception("Profile malumotlarini yangilashda xatolik: $e");
      }
    }

  @override
  Future<PhotosUrl> urlPhotos(Photos photos) async {
    try {
      print("📤 Rasm yuklanmoqda: ${photos.file.path}");

      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          photos.file.path,
          filename: photos.file.path.split('/').last,
        ),
      });

      final mainModel = await _dioClient.post(
        ApiUrls.urlImage,
        data: formData,
      );

      print("📥 Upload javobi: ${mainModel.result}");

      if (mainModel.ok && mainModel.result != null) {
        return PhotosUrl.fromJson(mainModel.result);
      }
      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    } catch (e) {
      print("💥 Rasm yuklashda xatolik: $e");
      throw Exception("Rasm yuklashda xatolik: $e");
    }
  }

  @override
  Future<OtpModel> sentOtp(String phoneNumber, String id) async {
    try {
      print("🌐 API ga so'rov jo'natilmoqda: $phoneNumber");

      final mainModel = await _dioClient.post(
        "${ApiUrls.users}/$id/phone/send-otp",
        data: {"newPhone": phoneNumber},
      );

      print("📨 API javobi:");
      print("  - ok: ${mainModel.ok}");
      print("  - result: ${mainModel.result}");
      print("  - statusCode: ${mainModel.status}"); // Buni ham qo'shing

      if (mainModel.ok && mainModel.result != null) {
        final otpModel = OtpModel.fromJson(mainModel.result);
        print("✅ OtpModel yaratildi: $otpModel");
        return otpModel;
      }

      // Bu yerda aniqroq xatolik
      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    } catch (e) {
      print("💥 sentOtp xatoligi: $e");
      throw Exception("OTP jo'natishda xatolik: $e");
    }
  }

  @override
  Future<OtpModel> verifyOtp({
    required String phoneNumber,
    required String otp,
    required String id
  }) async {
    try {
      final mainModel = await _dioClient.patch(
        "${ApiUrls.users}/$id/phone/confirm",
        data: {"newPhone": phoneNumber, "otp": otp},
      );
      if (mainModel.ok && mainModel.result != null) {
        return OtpModel.fromJson(mainModel.result);
      }
      throw "Otp jonatishda xatolik boldi !";
    } catch (e) {
      throw "Otp jonatishda xatolik boldi !\nError: $e";
    }
  }

  @override
  Future<OtpModel> newPassword({ required String oldPassword,
    required String newPassword, required String id}) async {
    try {
      final mainModel = await _dioClient.patch("${ApiUrls.users}/$id/password",
          data: {"oldPassword": oldPassword, "newPassword": newPassword});
      if (mainModel.ok && mainModel.result != null) {
        return OtpModel.fromJson(mainModel.result);
      }
      throw "Password xato!";
    } catch (e) {
      throw "Parolni qo'yishda xatolik yuz berdi$e";
    }
  }
}