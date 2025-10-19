import 'package:housell/core/constants/api_urls.dart';
import 'package:housell/core/dio/dio_client.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../../../core/error/failure.dart';

abstract class HomeDatasourse {
  Future<PropertyModel> getHouses();
  Future<Datum> getHousesId(String id);
  Future<ProfileModel> getProfile(String id);

  factory HomeDatasourse(DioClient dioClient) =>
      HomeDataSourceImpl(dioClient: dioClient);

}

class HomeDataSourceImpl implements HomeDatasourse {
  final DioClient _dioClient;

  HomeDataSourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<PropertyModel> getHouses() async {
    try {
      final mainModel = await _dioClient.get(ApiUrls.getHouses);

      print("API javob turi: ${mainModel.result.runtimeType}");
      print("API javob: ${mainModel.result}");

      if (mainModel.ok && mainModel.result != null) {
        // Bu yerda o'zgartirish - to'g'ridan-to'g'ri Map beradi
        return PropertyModel.fromJson(mainModel.result);
      }

      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    } catch(e) {
      print("uy malumotlarini olishda xatolik: $e");
      throw Exception("uy malumotlarini olishda xatolik: $e");
    }
  }

  @override
  Future<Datum> getHousesId(String id) async {
    try {
      final mainModel = await _dioClient.get("${ApiUrls.getHouses}/$id");

      print("API javob turi: ${mainModel.result.runtimeType}");
      print("API javob: ${mainModel.result}");

      if (mainModel.ok && mainModel.result != null) {
        // Bu yerda o'zgartirish - to'g'ridan-to'g'ri Map beradi
        return Datum.fromMap(mainModel.result);
      }

      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    } catch(e) {
      print("uy malumotlarini olishda xatolik: $e");
      throw Exception("uy malumotlarini olishda xatolik: $e");
    }
  }
  @override 
  Future<ProfileModel> getProfile(String id) async {
    try {
      final mainModel = await _dioClient.get("${ApiUrls.users}/$id");
      if (mainModel.ok && mainModel.result != null) {
        return ProfileModel.fromMap(mainModel.result);
      }
      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    } catch (e) {
      print("profile malumotlarini olishda xatolik: $e");
      throw Exception("profile malumotlarini olishda xatolik: $e");
    }
  }
}
