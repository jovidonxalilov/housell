import 'package:housell/core/either/either.dart';
import 'package:housell/features/add/data/datasource/add_datasource.dart';
import 'package:housell/features/add/domain/repository/add_repository.dart';
import 'package:housell/features/home/data/model/property_model.dart';

import '../../../../core/error/failure.dart';
import '../model/url_photos_model.dart';

class AddRepositoryImpl implements AddRepository {
  final AddHouseDatasource _addDatasource;

  AddRepositoryImpl({required AddHouseDatasource addDatasource})
    : _addDatasource = addDatasource;

  @override
  Future<Either<Failure, PropertyModel>> addHouses(Datum propertyModel,
  ) async {
    try {
      final result = await _addDatasource.addHouses(propertyModel);
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, PhotosUrl>> urlPhotos(Photos photos) async {
    try {
      final result = await _addDatasource.urlPhotos(photos);
      return Right(result);
    } catch(e) {
      return Left(ValidationFailure(e.toString()));
    }
  }
}