import 'package:dio/dio.dart';
import 'package:housell/core/constants/api_urls.dart';
import 'package:housell/core/dio/dio_client.dart';
import 'package:housell/features/add/data/model/url_photos_model.dart';
import 'package:housell/features/auth/data/model/auth_model.dart';
import 'package:housell/features/auth/data/model/otp_model.dart';
import 'package:housell/features/home/data/model/property_model.dart';

import '../../../../core/error/failure.dart';

abstract class AddHouseDatasource {
  Future<PropertyModel> addHouses(Datum propertyModel);

  Future<PhotosUrl> urlPhotos(Photos photos);

  factory AddHouseDatasource(DioClient dioClient) =>
      AddDatasourceImpl(dioClient: dioClient);

}

class AddDatasourceImpl implements AddHouseDatasource {
  final DioClient _dioClient;

  AddDatasourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  // 1. Asosiy funksiya - takomillashtirilgan
  Future<PropertyModel> addHouses(Datum propertyModel) async {
    try {
      // Debug uchun jo'natiladigan ma'lumotni log qilish
      print("📤 Jo'natiladigan ma'lumot: ${propertyModel.toJson()}");

      final mainModel = await _dioClient.post(
          ApiUrls.addHouses,
          data: propertyModel.toMap()
      );

      print("📥 Server javobi: ${mainModel.result}");

      if (mainModel.ok && mainModel.result != null) {
        return PropertyModel.fromJson(mainModel.result);
      }

      throw ApiException(
        "API xatoligi: ok=${mainModel.ok}, result=${mainModel.result}",
      );
    } on DioException catch (dioError) {
      print("💥 Dio xatoligi: ${dioError.message}");
      print("💥 Response data: ${dioError.response?.data}");
      throw Exception("Tarmoq xatoligi: ${dioError.message}");
    } catch (e) {
      print("💥 Yangi uy qo'shishda xatolik: $e");
      throw Exception("Yangi uy qo'shishda xatolik: $e");
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
}