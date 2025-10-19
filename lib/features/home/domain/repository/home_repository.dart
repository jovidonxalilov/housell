import 'package:housell/core/either/either.dart';
import 'package:housell/core/error/failure.dart';
import 'package:housell/features/home/data/datasource/home_datasource.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/home/data/repository_impl/home_repository_impl.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, PropertyModel>> getHouses();
  Future<Either<Failure, Datum>> getHousesId(String id);
  Future<Either<Failure, ProfileModel>> getProfile(String id);

  factory HomeRepository(HomeDatasourse homeDataSource) =>
      HomeRepositoryImpl(homeDataSource: homeDataSource);
}