import 'package:bloc/bloc.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/usecase/usecase.dart';
import 'package:housell/features/profile/domain/usecase/profile_usecase.dart';
import 'package:housell/features/profile/presentation/bloc/profile_event.dart';
import 'package:housell/features/profile/presentation/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileGetUsecase profileGetUsecase;
  final ProfilePatchUsecase profilePathUsecase;

  ProfileBloc(this.profileGetUsecase, this.profilePathUsecase) : super(ProfileState.initial()) {
    on<ProfileGetMeEvent>(_profileMe);
    on<ProfilePatchEvent>(_patchProfile);
  }

  Future<void> _profileMe(ProfileGetMeEvent event,
      Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(mainStatus: MainStatus.loading));
      final result = await profileGetUsecase.call(NoParams());
      result.either(
              (failure) {
            emit(state.copyWith(
                mainStatus: MainStatus.failure,
                errorMessage: failure.toString()));
          }, (success) {
        emit(state.copyWith(
            mainStatus: MainStatus.succes, profileModel: success));
      }
      );
    } catch(e) {
      emit(state.copyWith(mainStatus: MainStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _patchProfile(ProfilePatchEvent event, Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(mainStatus: MainStatus.loading));
      final result = await profilePathUsecase.call(event.patchParams);
      result.either((failure) {
        emit(state.copyWith(mainStatus: MainStatus.failure, errorMessage: failure.toString()));
      }, (success) {
        emit(state.copyWith(mainStatus: MainStatus.succes, profileModel: success));
      });
    } catch (e) {
      emit(state.copyWith(mainStatus: MainStatus.failure, errorMessage: e.toString()));
    }
  }
}