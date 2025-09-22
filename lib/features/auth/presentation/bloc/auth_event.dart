import 'dart:ui';

import 'package:housell/features/auth/data/model/auth_model.dart';
import 'package:housell/features/auth/domain/entities/reset_password.dart';

import '../../domain/entities/login.dart';
import '../../domain/entities/otp.dart';

sealed class AuthEvent {}

class AuthLoginEvent extends AuthEvent {
  final LoginModel authLogin;
  final Function(String) onSuccess;
  final VoidCallback onFailure;

  AuthLoginEvent({
    required this.authLogin,
    required this.onSuccess,
    required this.onFailure,
  });

}
class AuthSignUpEvent extends AuthEvent {
  final SignUpModel signUp;
  final Function(String accessToken) onSuccess;
  final Function() onFailure;
  final Function() onLoginFailure;

  AuthSignUpEvent({
    required this.signUp,
    required this.onSuccess,
    required this.onFailure,
    required this.onLoginFailure,
  });
}

class AuthSendOtpEvent extends AuthEvent {
  final String phoneNumber;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  AuthSendOtpEvent({
    required this.phoneNumber,
    required this.onSuccess,
    required this.onFailure,
  });
}

class AuthVerifyOtpEvent extends AuthEvent {
  final VerifyOtpModel verifyOtpModel;
  final Function(String) onSuccess;
  final VoidCallback onFailure;

  AuthVerifyOtpEvent({
    required this.verifyOtpModel,
    required this.onSuccess,
    required this.onFailure,
  });
}

class AuthAutoLoginAfterSignUpEvent extends AuthEvent {
  final String phone;
  final String password;
  final Function(String accessToken) onSuccess;
  final Function() onFailure;

  AuthAutoLoginAfterSignUpEvent({
    required this.phone,
    required this.password,
    required this.onSuccess,
    required this.onFailure,
  });
}

class AuthResetSendOtpEvent extends AuthEvent {
  final String phoneNumber;
  final VoidCallback onSuccess;
  final VoidCallback onFailure;

  AuthResetSendOtpEvent({
    required this.phoneNumber,
    required this.onSuccess,
    required this.onFailure,
  });
}

class AuthResetVerifyOtpEvent extends AuthEvent {
  final VerifyOtpModel verifyOtpModel;
  final Function(String) onSuccess;
  final VoidCallback onFailure;

  AuthResetVerifyOtpEvent({
    required this.verifyOtpModel,
    required this.onSuccess,
    required this.onFailure,
  });
}

class AuthResetPasswordEvent extends AuthEvent {
  final ResetPassword newPassword;
  final Function(String) onSuccess;
  final VoidCallback onFailure;

  AuthResetPasswordEvent({
    required this.newPassword,
    required this.onSuccess,
    required this.onFailure,
  });
}