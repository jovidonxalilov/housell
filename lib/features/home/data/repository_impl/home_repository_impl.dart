import 'package:housell/core/either/either.dart';
import 'package:housell/features/home/data/datasource/home_datasource.dart';
import 'package:housell/features/home/domain/repository/home_repository.dart';

import '../../../../core/error/failure.dart';
import '../../../profile/data/model/profile_model.dart';
import '../model/property_model.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeDatasourse _homeDatasourse;

  HomeRepositoryImpl({required HomeDatasourse homeDataSource}) : _homeDatasourse = homeDataSource;

  @override
  Future<Either<Failure, PropertyModel>> getHouses() async {
    try {
      final result = await _homeDatasourse.getHouses();
      return Right(result);
    } catch (e){
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Datum>> getHousesId(String id) async {
    try {
      final result = await _homeDatasourse.getHousesId(id);
      return Right(result);
    } catch (e){
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> getProfile(String id) async {
    try {
      final result = await _homeDatasourse.getProfile(id);
      return Right(result);

    } catch (e) {
      return Left(ValidationFailure(e.toString()));

    }
  }
}


