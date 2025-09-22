import 'package:housell/core/either/either.dart';
import 'package:housell/features/auth/data/model/otp_model.dart';
import 'package:housell/features/auth/domain/entities/reset_password.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../data/model/auth_model.dart';
import '../entities/login.dart';
import '../entities/otp.dart';
import '../repository/auth_repository.dart';

class AuthLoginUsecase extends UseCase<AuthModel, LoginModel> {
  final AuthRepository authRepository;

  AuthLoginUsecase(this.authRepository);

  @override
  Future<Either<Failure, AuthModel>> call(LoginModel param) {
    return authRepository.login(
      login: param.login,
      password: param.password,
    );
  }
}


class AuthSentOtpUsecase extends UseCase<OtpModel, String> {
  final AuthRepository authRepository;

  AuthSentOtpUsecase(this.authRepository);

  @override
  Future<Either<Failure, OtpModel>> call(String phoneNumber) {
    return authRepository.sentOtp(phoneNumber);
  }
}

class AuthVerifyOtpUsecase extends UseCase<OtpModel, VerifyOtpModel> {
  final AuthRepository authRepository;

  AuthVerifyOtpUsecase(this.authRepository);

  @override
  Future<Either<Failure, OtpModel>> call(VerifyOtpModel param) {
    return authRepository.verifyOtp(
      phoneNumber: param.phoneNumber,
      otp: param.otp,
    );
  }
}

class AuthSignUpUsecase extends UseCase<SignUpResponseModel, SignUpModel> {
  final AuthRepository authRepository;

  AuthSignUpUsecase(this.authRepository);

  @override
  Future<Either<Failure, SignUpResponseModel>> call(SignUpModel param) {
    return authRepository.signUp(
      signUp: param
    );
  }
}

class AuthResetSendOtpUsecase extends UseCase<OtpModel, String> {
  final AuthRepository authRepository;

  AuthResetSendOtpUsecase(this.authRepository);

  @override
  Future<Either<Failure, OtpModel>> call(String phoneNumber) {
    return authRepository.sendResetOtp(phoneNumber);
  }
}

class AuthResetVerifyOtpUsecase extends UseCase<OtpModel, VerifyOtpModel> {
  final AuthRepository authRepository;

  AuthResetVerifyOtpUsecase(this.authRepository);

  @override
  Future<Either<Failure, OtpModel>> call(VerifyOtpModel param) {
    return authRepository.verifyResetOtp(
      phoneNumber: param.phoneNumber,
      otpReset: param.otp,
    );
  }
}

class AuthResetPasswordUsecase extends UseCase<OtpModel, ResetPassword> {
  final AuthRepository authRepository;

  AuthResetPasswordUsecase(this.authRepository);

  @override
  Future<Either<Failure, OtpModel>> call(ResetPassword param) {
    return authRepository.resetPassword(
      phoneNumber: param.phoneNumber,
      newPassword: param.newPassword,
    );
  }
}



