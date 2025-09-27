
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:housell/core/constants/app_status.dart';
import 'package:housell/core/usecase/usecase.dart';
import 'package:housell/features/home/domain/usecase/home_usecase.dart';
import 'package:housell/features/home/presentation/bloc/home_event.dart';
import 'package:housell/features/home/presentation/bloc/home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeGetHousesUsecase homeGetHousesUsecase;
  final HomeGetHousesIdUsecase homeGetHousesIdUsecase;

  HomeBloc(this.homeGetHousesUsecase, this.homeGetHousesIdUsecase)
    : super(HomeState.initial()) {
    on<HomeGetHousesLoading>(_getLoading);
    on<HomeGetHousesIdEvent>(_getHouseId);
    add(
      HomeGetHousesLoading(
        propertyModel: null,
        onFailure: () {},
        onSuccess: () {},
      ),
    );
  }

  Future<void> _getLoading(
    HomeGetHousesLoading event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(mainStatus: MainStatus.loading));
      final either = await homeGetHousesUsecase.call(NoParams());
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
              errorMessage: '',
              propertyModel: success,
            ),
          );
          event.onSuccess();
        },
      );
    } catch (e) {
      print("❌ Kutilmagan xatolik: $e");
      emit(
        state.copyWith(
          mainStatus: MainStatus.failure,
          errorMessage: "Kutilmagan xatolik yuz berdi: $e",
        ),
      );
      event.onFailure();
    }
  }

  Future<void> _getHouseId(
    HomeGetHousesIdEvent event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(mainStatus: MainStatus.loading));
      final result = await homeGetHousesIdUsecase.call(event.id);
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
              propertyModel: success,
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
}
