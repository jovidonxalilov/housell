import 'package:housell/core/either/either.dart';
import 'package:housell/core/usecase/usecase.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/home/domain/repository/home_repository.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../../../core/error/failure.dart';

class HomeGetHousesUsecase extends UseCase<PropertyModel, NoParams> {
  final HomeRepository homeRepository;

  HomeGetHousesUsecase(this.homeRepository);

  @override
  Future<Either<Failure, PropertyModel>> call(NoParams param) {
    return homeRepository.getHouses();
  }
}

class HomeGetHousesIdUsecase extends UseCase<Datum, String> {
  final HomeRepository homeRepository;

  HomeGetHousesIdUsecase(this.homeRepository);

  @override
  Future<Either<Failure, Datum>> call(String id) {
    return homeRepository.getHousesId(id);
  }
}

class ProfileGetInformationUsecase extends UseCase<ProfileModel, String> {
  final HomeRepository homeRepository;

  ProfileGetInformationUsecase(this.homeRepository);

  @override
  Future<Either<Failure, ProfileModel>> call(String id) {
    return homeRepository.getProfile(id);
  }
}
