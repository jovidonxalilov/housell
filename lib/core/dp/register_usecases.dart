import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:housell/features/add/domain/repository/add_repository.dart';
import 'package:housell/features/add/domain/usecase/add_usecase.dart';
import 'package:housell/features/home/domain/repository/home_repository.dart';
import 'package:housell/features/home/domain/usecase/home_usecase.dart';
import 'package:housell/features/profile/domain/repository/profile_repository.dart';
import 'package:housell/features/profile/domain/usecase/profile_usecase.dart';

import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecase/usecase.dart';

Future<void> registerUseCases(GetIt getIt) async {
  getIt
    ..registerLazySingleton<AuthLoginUsecase>(
      () => AuthLoginUsecase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<AuthSentOtpUsecase>(
      () => AuthSentOtpUsecase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<AuthVerifyOtpUsecase>(
      () => AuthVerifyOtpUsecase(getIt<AuthRepository>()),
    )
    ..registerLazySingleton<AuthSignUpUsecase>(
      () => AuthSignUpUsecase(getIt<AuthRepository>()),
    ) ..registerLazySingleton<AuthResetSendOtpUsecase>(
        () => AuthResetSendOtpUsecase(getIt<AuthRepository>()),
  ) ..registerLazySingleton<AuthResetVerifyOtpUsecase>(
        () => AuthResetVerifyOtpUsecase(getIt<AuthRepository>()),
  ) ..registerLazySingleton<AuthResetPasswordUsecase>(
        () => AuthResetPasswordUsecase(getIt<AuthRepository>()),
  ) ..registerLazySingleton<HomeGetHousesUsecase>(
        () => HomeGetHousesUsecase(getIt<HomeRepository>()),
  ) ..registerLazySingleton<AddHouseUsecase>(
        () => AddHouseUsecase(getIt<AddRepository>()),
  )..registerLazySingleton<AddPhotosUrlUsecase>(
        () => AddPhotosUrlUsecase(getIt<AddRepository>()),
  )..registerLazySingleton<ProfileGetUsecase>(
        () => ProfileGetUsecase(getIt<ProfileRepository>()),
  )..registerLazySingleton<ProfilePatchUsecase>(
        () => ProfilePatchUsecase(getIt<ProfileRepository>()),
  )..registerLazySingleton<HomeGetHousesIdUsecase>(
        () => HomeGetHousesIdUsecase(getIt<HomeRepository>()),
  );
  log("Register UseCase Complare For GetIT");
}
