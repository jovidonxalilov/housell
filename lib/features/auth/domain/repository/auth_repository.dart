import 'package:housell/core/either/either.dart';
import 'package:housell/core/error/failure.dart';
import 'package:housell/features/auth/data/datasource/auth_datasource.dart';
import 'package:housell/features/auth/data/model/auth_model.dart';
import 'package:housell/features/auth/data/model/otp_model.dart';
import 'package:housell/features/auth/data/repository_impl/auth_repository_impl.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthModel>> login({
    required String login,
    required String password,
  });

  Future<Either<Failure, SignUpResponseModel>> signUp({
    required SignUpModel signUp,
  });

  Future<Either<Failure, OtpModel>> sentOtp(String phoneNumber);

  Future<Either<Failure, OtpModel>> sendResetOtp(String phoneNumber);

  Future<Either<Failure, OtpModel>> verifyOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<Either<Failure, OtpModel>> verifyResetOtp({
    required String phoneNumber,
    required String otpReset,
  });

  Future<Either<Failure, OtpModel>> resetPassword({
    required String phoneNumber,
    required String newPassword,
  });

  factory AuthRepository(AuthDatasource authDataSource) =>
      AuthRepositoryImpl(authDatasource: authDataSource);
}
