import 'package:housell/features/auth/data/model/auth_model.dart';
import 'package:housell/features/auth/data/model/otp_model.dart';
import 'package:housell/features/auth/domain/repository/auth_repository.dart';

import '../../../../core/either/either.dart';
import '../../../../core/error/failure.dart';
import '../datasource/auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _authDatasource;

  AuthRepositoryImpl({required AuthDatasource authDatasource})
      : _authDatasource = authDatasource;

  @override
  Future<Either<Failure, AuthModel>> login({
    required String login,
    required String password,
  }) async {
    try {
      final result = await _authDatasource.login(
        login: login,
        password: password,
      );
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> sentOtp(String phoneNumber) async {
    try {
      final result = await _authDatasource.sentOtp(phoneNumber);
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> sendResetOtp(String phoneNumber) async {
    try {
      final result = await _authDatasource.sendResetOtp(phoneNumber);
      return Right(result);
    } catch (e){
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> verifyOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final result = await _authDatasource.verifyOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> resetPassword({
    required String phoneNumber,
    required String newPassword,
  }) async {
    try {
      final result = await _authDatasource.resetPassword(
        phoneNumber: phoneNumber,
        newPassword: newPassword,
      );
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, OtpModel>> verifyResetOtp({
    required String phoneNumber,
    required String otpReset,
  }) async {
    try {
      final result = await _authDatasource.verifyResetOtp(
        phoneNumber: phoneNumber,
        otpReset: otpReset,
      );
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SignUpResponseModel>> signUp({required SignUpModel signUp}) async {
    try {
      final result = await _authDatasource.signUp(signUp: signUp);
      return Right(result);
    } catch (e) {
      return Left(ValidationFailure(e.toString()));
    }
  }
}