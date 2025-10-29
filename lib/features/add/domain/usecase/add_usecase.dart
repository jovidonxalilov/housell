import 'package:housell/features/add/domain/repository/add_repository.dart';
import 'package:housell/features/home/data/model/property_model.dart';
import 'package:housell/features/profile/data/model/profile_model.dart';

import '../../../../core/either/either.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/model/maker_model.dart';
import '../../data/model/url_photos_model.dart';

class AddHouseUsecase extends UseCase<PropertyModel, Datum> {
  final AddRepository addRepository;

  AddHouseUsecase(this.addRepository);

  @override
  Future<Either<Failure, PropertyModel>> call(Datum propertyModel) {
    return addRepository.addHouses(propertyModel);
  }

}

class AddPhotosUrlUsecase extends UseCase<PhotosUrl, Photos> {
  final AddRepository addRepository;

  AddPhotosUrlUsecase(this.addRepository);

  @override
  Future<Either<Failure, PhotosUrl>> call(Photos photos) {
    return addRepository.urlPhotos(photos);
  }
}

class GetMaklersUsecase extends UseCase<MaklerModel, NoParams> {
  final AddRepository addRepository;

  GetMaklersUsecase(this.addRepository);

  @override
  Future<Either<Failure, MaklerModel>> call(NoParams noParams) {
    return addRepository.getMaklers();
  }
}