import 'package:bloc/bloc.dart';
import 'package:housell/features/auth/data/model/otp_model.dart';

import '../../../../config/service/local_service.dart';
import '../../../../core/constants/app_status.dart';
import '../../../../core/dp/dp_injection.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/login.dart';
import '../../domain/usecase/usecase.dart';
import 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthLoginUsecase authLoginUsecase;
  final AuthSentOtpUsecase authSentOtpUsecase;
  final AuthVerifyOtpUsecase authVerifyOtpUsecase;
  final AuthSignUpUsecase authSignUpUsecase;
  final AuthResetSendOtpUsecase authResetSendOtpUsecase;
  final AuthResetVerifyOtpUsecase authResetVerifyOtpUsecase;
  final AuthResetPasswordUsecase authResetPasswordUsecase;

  AuthBloc(
    this.authLoginUsecase,
    this.authSentOtpUsecase,
    this.authVerifyOtpUsecase,
    this.authSignUpUsecase,
    this.authResetVerifyOtpUsecase,
    this.authResetPasswordUsecase,
    this.authResetSendOtpUsecase,
  ) : super(AuthState.initial()) {
    on<AuthLoginEvent>(_login);
    on<AuthSendOtpEvent>(_authSendOtpEvent);
    on<AuthResetSendOtpEvent>(_authResetSendOtpEvent);
    on<AuthVerifyOtpEvent>(_authVerifyOtpEvent);
    on<AuthResetVerifyOtpEvent>(_authResetVerifyOtpEvent);
    on<AuthResetPasswordEvent>(_authResetPassword);
    on<AuthSignUpEvent>(_signUp);
    on<AuthAutoLoginAfterSignUpEvent>(_autoLoginAfterSignUp);
  }

  Future<void> _login(AuthLoginEvent event, Emitter<AuthState> emit) async {
    try {
      print('BLoC: Login event received');
      emit(state.copyWith(loginStatus: MainStatus.loading));

      final either = await authLoginUsecase.call(event.authLogin);
      either.either(
        (failure) {
          print('BLoC: Login failure - ${failure.runtimeType}');

          String errorMessage = 'Login xatoligi';

          if (failure is ValidationFailure) {
            errorMessage = "Ma'lumotlar noto'g'ri formatda";
          } else if (failure is ServerFailure) {
            errorMessage = "Server xatoligi";
          } else if (failure is NetworkFailure) {
            errorMessage = "Internet aloqasi yo'q";
          }

          emit(
            state.copyWith(
              loginStatus: MainStatus.failure,
              errorMessage: errorMessage,
            ),
          );

          event.onFailure.call();
        },
        (success) {
          print('BLoC: Login success');
          print('BLoC: Access token: ${success.accessToken}');

          try {
            // Token saqlash
            getIt<SecureStorageService>().saveToken(success.accessToken);

            emit(
              state.copyWith(loginStatus: MainStatus.succes, errorMessage: ''),
            );

            // Callback chaqirish
            event.onSuccess.call(success.accessToken);
          } catch (e) {
            print('BLoC: Token save error: $e');
            emit(
              state.copyWith(
                loginStatus: MainStatus.failure,
                errorMessage: 'Token saqlashda xatolik',
              ),
            );
            event.onFailure.call();
          }
        },
      );
    } catch (e) {
      print('BLoC: Unexpected error: $e');
      emit(
        state.copyWith(
          loginStatus: MainStatus.failure,
          errorMessage: 'Kutilmagan xatolik: $e',
        ),
      );
      event.onFailure.call();
    }
  }

  Future<void> _signUp(AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(loginStatus: MainStatus.loading));

    final either = await authSignUpUsecase.call(event.signUp);

    either.either(
      (failure) {
        String errorMessage = failure.toString();
        emit(
          state.copyWith(
            loginStatus: MainStatus.failure,
            errorMessage: errorMessage,
          ),
        );
        event.onFailure();
      },
      (success) {
        // Signup muvaffaqiyatli bo'ldi, endi login event'ini chaqirish
        add(
          AuthAutoLoginAfterSignUpEvent(
            phone: event.signUp.phone,
            password: event.signUp.password,
            onSuccess: event.onSuccess,
            onFailure: event.onLoginFailure,
          ),
        );
      },
    );
  }

  Future<void> _autoLoginAfterSignUp(
    AuthAutoLoginAfterSignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loginStatus: MainStatus.loading));

    final loginEither = await authLoginUsecase.call(
      LoginModel(login: event.phone, password: event.password),
    );

    loginEither.either(
      (failure) {
        String errorMessage = failure.toString();
        emit(
          state.copyWith(
            loginStatus: MainStatus.failure,
            errorMessage:
                "Ro'yxatdan o'tish muvaffaqiyatli, lekin avtomatik kirishda xatolik: $errorMessage",
          ),
        );
        event.onFailure();
      },
      (loginSuccess) {
        emit(state.copyWith(loginStatus: MainStatus.succes, errorMessage: ''));
        event.onSuccess(loginSuccess.accessToken);
      },
    );
  }

  _authSendOtpEvent(AuthSendOtpEvent event, emit) async {
    try {
      print("📱 OTP jo'natish boshlandi: ${event.phoneNumber}");
      emit(state.copyWith(otpStatus: MainStatus.loading));

      final either = await authSentOtpUsecase.call(event.phoneNumber);
      print("📡 UseCase javobi: $either");

      either.either(
        (failure) {
          print("❌ Failure holati: $failure");
          emit(
            state.copyWith(
              otpStatus: MainStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
          event.onFailure();
        },
        (success) {
          print("✅ Success holati: $success");
          emit(
            state.copyWith(
              otpStatus: MainStatus.succes,
              phoneNumber: event.phoneNumber,
              errorMessage: '',
              otpModel: success,
            ),
          );
          event.onSuccess();
        },
      );
    } catch (e) {
      print("💥 Exception xatolik: $e");
      emit(
        state.copyWith(
          otpStatus: MainStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      event.onFailure();
    }
  }

  _authResetSendOtpEvent(AuthResetSendOtpEvent event, emit) async {
    try {
      print("📱 OTP jo'natish boshlandi: ${event.phoneNumber}");
      emit(state.copyWith(otpStatus: MainStatus.loading));

      final either = await authResetSendOtpUsecase.call(event.phoneNumber);
      print("📡 UseCase javobi: $either");

      either.either(
        (failure) {
          print("❌ Failure holati: $failure");
          emit(
            state.copyWith(
              otpStatus: MainStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
          event.onFailure();
        },
        (success) {
          print("✅ Success holati: $success");
          emit(
            state.copyWith(
              otpStatus: MainStatus.succes,
              phoneNumber: event.phoneNumber,
              errorMessage: '',
              otpModel: success,
            ),
          );
          event.onSuccess();
        },
      );
    } catch (e) {
      print("💥 Exception xatolik: $e");
      emit(
        state.copyWith(
          otpStatus: MainStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      event.onFailure();
    }
  }

  _authVerifyOtpEvent(AuthVerifyOtpEvent event, emit) async {
    emit(state.copyWith(otpStatus: MainStatus.loading));
    final either = await authVerifyOtpUsecase.call(event.verifyOtpModel);

    either.either(
      (failure) {
        emit(
          state.copyWith(
            loginStatus: MainStatus.failure,
            errorMessage: failure.toString(),
          ),
        );

        event.onFailure();
      },
      (success) {
        emit(state.copyWith(loginStatus: MainStatus.succes, errorMessage: ''));
        event.onSuccess(success.message);
      },
    );
  }

  _authResetVerifyOtpEvent(AuthResetVerifyOtpEvent event, emit) async {
    emit(state.copyWith(otpStatus: MainStatus.loading));
    final either = await authResetVerifyOtpUsecase.call(event.verifyOtpModel);

    either.either(
      (failure) {
        emit(
          state.copyWith(
            loginStatus: MainStatus.failure,
            errorMessage: failure.toString(),
          ),
        );

        event.onFailure();
      },
      (success) {
        emit(state.copyWith(loginStatus: MainStatus.succes, errorMessage: ''));
        event.onSuccess(success.message);
      },
    );
  }

  _authResetPassword(AuthResetPasswordEvent event, emit) async {
    emit(state.copyWith(otpStatus: MainStatus.loading));
    final either = await authResetPasswordUsecase.call(event.newPassword);

    either.either(
      (failure) {
        emit(
          state.copyWith(
            loginStatus: MainStatus.failure,
            errorMessage: failure.toString(),
          ),
        );

        event.onFailure();
      },
      (success) {
        emit(state.copyWith(loginStatus: MainStatus.succes, errorMessage: ''));
        event.onSuccess(success.message);
      },
    );
  }
}
