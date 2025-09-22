import 'package:housell/core/either/either.dart';
import 'package:housell/core/usecase/usecase.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/home/domain/repository/home_repository.dart';

import '../../../../core/error/failure.dart';

class HomeGetHousesUsecase extends UseCase<PropertyModel, NoParams> {
  final HomeRepository homeRepository;

  HomeGetHousesUsecase(this.homeRepository);

  @override
  Future<Either<Failure, PropertyModel>> call(NoParams param) {
    return homeRepository.getHouses();
  }
}
