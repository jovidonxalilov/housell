import 'package:bloc/bloc.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/usecase/usecase.dart';
import 'package:housell/features/profile/domain/usecase/profile_usecase.dart';
import 'package:housell/features/profile/presentation/bloc/profile_event.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';

import '../../../add/data/model/url_photos_model.dart';
import '../../../home/data/model/property_model.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileGetUsecase profileGetUsecase;
  final ProfilePatchUsecase profilePathUsecase;
  final ProfilePhotoUrlUsecase profilePhotoUrlUsecase;
  final ProfileNewPhoneOtpUsecase profileNewPhoneUsecase;
  final ProfileNewPhoneVerifyOtpUsecase profileNewPhoneVerifyOtpUsecase;
  final ProfileNewPasswordUsecase newPasswordUsecase;

  ProfileBloc(
    this.profileGetUsecase,
    this.profilePathUsecase,
    this.profilePhotoUrlUsecase,
    this.profileNewPhoneUsecase,
      this.profileNewPhoneVerifyOtpUsecase,
      this.newPasswordUsecase,
  ) : super(ProfileState.initial()) {
    on<ProfileGetMeEvent>(_profileMe);
    on<ProfilePatchEvent>(_patchProfile);
    on<ProfilePhotoUrlEvent>(_profilePhotoUrl);
    on<ProfileNewPhoneOtpEvent>(_profileNewPhoneSendOtpEvent);
    on<ProfileNewPhoneVerifyOtpEvent>(_profileNewPhoneVerifyOtpEvent);
    on<ProfileNewPasswordEvent>(_profileNewPassword);
  }

  Future<void> _profileMe(
    ProfileGetMeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(mainStatus: MainStatus.loading));
      // Future.delayed(Duration(milliseconds: 500));
      final result = await profileGetUsecase.call(NoParams());
      result.either(
        (failure) {
          emit(
            state.copyWith(
              mainStatus: MainStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
        },
        (success) {
          emit(
            state.copyWith(
              mainStatus: MainStatus.succes,
              profileModel: success,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          mainStatus: MainStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _patchProfile(
    ProfilePatchEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      emit(state.copyWith(mainStatus: MainStatus.loading));
      final result = await profilePathUsecase.call(event.patchParams);
      result.either(
        (failure) {
          emit(
            state.copyWith(
              mainStatus: MainStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
        },
        (success) {
          emit(
            state.copyWith(
              mainStatus: MainStatus.succes,
              profileModel: success,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(
          mainStatus: MainStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _profilePhotoUrl(
    ProfilePhotoUrlEvent event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      print("🔄 Rasm yuklanmoqda: ${event.photos.path}");
      emit(state.copyWith(mainStatus: MainStatus.loading));

      final either = await profilePhotoUrlUsecase.call(
        Photos(file: event.photos),
      );

      either.either(
        (failure) {
          print("❌ Rasm yuklashda xato: $failure");
          emit(
            state.copyWith(
              mainStatus: MainStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
          event.onFailure();
        },
        (success) {
          print("✅ Rasm muvaffaqiyatli yuklandi: ${success.secureUrl}");
          emit(
            state.copyWith(
              mainStatus: MainStatus.succes,
              uploadedPhotos: success, // bitta rasm uchun
            ),
          );
          event.onSuccess();
        },
      );
    } catch (e) {
      print("💥 Bloc Exception: $e");
      emit(
        state.copyWith(
          mainStatus: MainStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      event.onFailure();
    }
  }

  _profileNewPhoneSendOtpEvent(ProfileNewPhoneOtpEvent event, emit) async {
    try {
      print("📱 OTP jo'natish boshlandi: ${event.newPhoneE.phoneNumber}");
      emit(state.copyWith(mainStatus: MainStatus.loading));

      final either = await profileNewPhoneUsecase.call(event.newPhoneE);
      print("📡 UseCase javobi: $either");

      either.either(
        (failure) {
          print("❌ Failure holati: $failure");
          emit(
            state.copyWith(
              mainStatus: MainStatus.failure,
              errorMessage: failure.toString(),
            ),
          );
          event.onFailure();
        },
        (success) {
          print("✅ Success holati: $success");
          emit(
            state.copyWith(
              mainStatus: MainStatus.succes,
              phoneNumber: event.newPhoneE.phoneNumber,
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
          mainStatus: MainStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      event.onFailure();
    }
  }

  _profileNewPhoneVerifyOtpEvent(ProfileNewPhoneVerifyOtpEvent event, emit) async {
    emit(state.copyWith(mainStatus: MainStatus.loading));
    final either = await profileNewPhoneVerifyOtpUsecase.call(event.verifyOtpModel);

    either.either(
          (failure) {
        emit(
          state.copyWith(
            mainStatus: MainStatus.failure,
            errorMessage: failure.toString(),
          ),
        );

        event.onFailure();
      },
          (success) {
        emit(state.copyWith(mainStatus: MainStatus.succes, errorMessage: ''));
        event.onSuccess(success.message);
      },
    );
  }

  _profileNewPassword(ProfileNewPasswordEvent event, emit) async {
    emit(state.copyWith(mainStatus: MainStatus.loading));
    final either = await newPasswordUsecase.call(event.newPassword);

    either.either(
          (failure) {
        emit(
          state.copyWith(
            mainStatus: MainStatus.failure,
            errorMessage: failure.toString(),
          ),
        );

        event.onFailure();
      },
          (success) {
        emit(state.copyWith(mainStatus: MainStatus.succes, errorMessage: ''));
        event.onSuccess(success.message);
      },
    );
  }
}
