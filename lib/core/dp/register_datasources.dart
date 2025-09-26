import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:housell/features/add/data/datasource/add_datasource.dart';
import 'package:housell/features/home/data/datasource/home_datasource.dart';
import 'package:housell/features/profile/data/datasource/profile_datasource.dart';

import '../../features/auth/data/datasource/auth_datasource.dart';
import '../dio/dio_client.dart';

Future<void> registerDataSources(GetIt getIt) async {
  getIt
    ..registerSingleton<DioClient>(DioClient())
    ..registerLazySingleton<AuthDatasource>(
      () => AuthDatasource(getIt<DioClient>()),
    ) ..registerLazySingleton<HomeDatasourse>(
        () => HomeDatasourse(getIt<DioClient>()),
  )..registerLazySingleton<AddHouseDatasource>(
        () => AddHouseDatasource(getIt<DioClient>()),
  )..registerLazySingleton<ProfileDataSource>(
        () => ProfileDataSource(getIt<DioClient>()),
  );
  log("Register Datasource Complate For GetIT");
}
