import 'dart:developer';
import 'package:get_it/get_it.dart';
import 'package:housell/features/add/data/datasource/add_datasource.dart';
import 'package:housell/features/add/domain/repository/add_repository.dart';
import 'package:housell/features/home/data/datasource/home_datasource.dart';
import 'package:housell/features/home/domain/repository/home_repository.dart';
import 'package:housell/features/message/data/data_source/message_datasource.dart';
import 'package:housell/features/message/domain/repository/repository.dart';
import 'package:housell/features/profile/data/datasource/profile_datasource.dart';
import 'package:housell/features/profile/domain/repository/profile_repository.dart';

import '../../features/auth/data/datasource/auth_datasource.dart';
import '../../features/auth/domain/repository/auth_repository.dart';

Future<void> registerRepositories(GetIt getIt) async {
  getIt
    ..registerLazySingleton(() => AuthRepository(getIt<AuthDatasource>()))
    ..registerLazySingleton(() => HomeRepository(getIt<HomeDatasourse>()))
    ..registerLazySingleton(() => AddRepository(getIt<AddHouseDatasource>()))
    ..registerLazySingleton(() => ProfileRepository(getIt<ProfileDataSource>()))
    ..registerLazySingleton(() => MessageRepository(getIt<MessageDatasource>()));
  log("Register Repositories Complate For GetIT");
}
