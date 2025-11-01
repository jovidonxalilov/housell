import 'package:housell/core/either/either.dart';
import 'package:housell/core/error/failure.dart';
import 'package:housell/features/add/data/datasource/add_datasource.dart';
import 'package:housell/features/add/data/repository_impl/add_repository_impl.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../data/model/maker_model.dart';
import '../../data/model/url_photos_model.dart';

abstract class AddRepository {
  Future<Either<Failure, PropertyModel>> addHouses(Datum propertyModel);
  Future<Either<Failure, PhotosUrl>> urlPhotos(Photos photos);
  Future<Either<Failure, MaklerModel>> getMaklers();
  Future<Either<Failure, Maklers>> getMakler(String id);

  factory AddRepository(AddHouseDatasource aadDatasource) =>
      AddRepositoryImpl(addDatasource: aadDatasource);
}