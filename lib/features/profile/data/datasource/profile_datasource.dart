import 'package:housell/core/constants/api_urls.dart';
import 'package:housell/core/dio/dio_client.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../../../core/error/failure.dart';

abstract class ProfileDataSource {

  Future<ProfileModel> profile();

  Future<ProfileModel> patchProfile(String id, ProfileModel profileModel);

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
}