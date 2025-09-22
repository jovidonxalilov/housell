part of 'auth_bloc.dart';


class AuthState {

  final OtpModel? otpModel;
  final MainStatus loginStatus;
  final MainStatus otpStatus;
  final String errorMessage;
  final String? phoneNumber;
  final String? otp;

  final bool loginButton;

  AuthState({
    required this.loginButton,
    required this.loginStatus,
    required this.otpStatus,
    required this.otpModel,
    required this.errorMessage,
    required this.phoneNumber,
    required this.otp,
  });

  factory AuthState.initial() => AuthState(
    loginStatus: MainStatus.initial,
    otpStatus: MainStatus.initial,
    errorMessage: '',
    otpModel: null,
    phoneNumber: null,
    otp: null,
    loginButton: false,
  );

  AuthState copyWith({
    bool? loginButton,
    OtpModel? otpModel,
    MainStatus? loginStatus,
    MainStatus? otpStatus,
    String? errorMessage,
    String? phoneNumber,
    String? otp,
  }) {
    return AuthState(
      loginButton: loginButton ?? this.loginButton,
      loginStatus: loginStatus ?? this.loginStatus,
      otpModel: otpModel ?? this.otpModel,
      otpStatus: otpStatus ?? this.otpStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
    );
  }
}
