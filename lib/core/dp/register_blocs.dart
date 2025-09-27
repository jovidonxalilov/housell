import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:housell/features/add/domain/usecase/add_usecase.dart';
import 'package:housell/features/add/presentation/bloc/add_bloc.dart';
import 'package:housell/features/home/domain/usecase/home_usecase.dart';
import 'package:housell/features/home/presentation/bloc/home_bloc.dart';
import 'package:housell/features/profile/domain/usecase/profile_usecase.dart';
import 'package:housell/features/profile/presentation/bloc/profile_bloc.dart';

import '../../features/auth/domain/usecase/usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';

Future<void> registerBlocs(GetIt getIt) async {
  getIt
    ..registerFactory<AuthBloc>(
      () => AuthBloc(
        getIt<AuthLoginUsecase>(),
        getIt<AuthSentOtpUsecase>(),
        getIt<AuthVerifyOtpUsecase>(),
        getIt<AuthSignUpUsecase>(),
        getIt<AuthResetVerifyOtpUsecase>(),
        getIt<AuthResetPasswordUsecase>(),
        getIt<AuthResetSendOtpUsecase>(),
      ),
    )
    ..registerFactory<HomeBloc>(() => HomeBloc(getIt<HomeGetHousesUsecase>(), getIt<HomeGetHousesIdUsecase>()))
    ..registerFactory<AddHouseBloc>(() => AddHouseBloc(getIt<AddHouseUsecase>(), getIt<AddPhotosUrlUsecase>()))
    ..registerFactory<ProfileBloc>(() => ProfileBloc(getIt<ProfileGetUsecase>(), getIt<ProfilePatchUsecase>()));
  log("Register BLOC Complate For GetIT");
}
