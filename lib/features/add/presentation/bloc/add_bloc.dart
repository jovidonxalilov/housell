import 'package:bloc/bloc.dart';
import 'package:housell/features/add/data/datasource/add_datasource.dart';
import 'package:housell/features/add/domain/usecase/add_usecase.dart';
import 'package:housell/features/add/presentation/bloc/add_event.dart';
import 'package:housell/features/add/presentation/bloc/add_state.dart';
import 'package:housell/features/auth/presentation/bloc/auth_bloc.dart';

import '../../../../core/constants/app_status.dart';
import '../../../home/data/model/property_model.dart';
import '../../data/model/url_photos_model.dart';

class AddHouseBloc extends Bloc<AddEvent, AddHouseState> {
  final AddHouseUsecase addHouseUsecase;
  final AddPhotosUrlUsecase addPhotosUrlUsecase;

  AddHouseBloc(this.addHouseUsecase, this.addPhotosUrlUsecase) : super(AddHouseState.initial()) {
    on<AddHouseEvent>(_addHouse);
    on<AddPhotosUrlEvent>(_urlPhotos);
  }

  Future<void> _addHouse(AddHouseEvent event, Emitter<AddHouseState> emit) async {
    try {
      emit(state.copyWith(mainStatus: MainStatus.loading));
      print("🔄 Bloc: Ma'lumot jo'natilmoqda...");

      final either = await addHouseUsecase.call(event.propertyModel);
      either.either(
            (failure) {
          print("❌ Bloc: Xatolik - $failure");
          String errorMessage = failure.toString();
          emit(
            state.copyWith(
              mainStatus: MainStatus.failure,
              errorMessage: errorMessage,
            ),
          );
          event.onFailure();
        },
            (success) {
          print("✅ Bloc: Muvaffaqiyat");
          // BU YERDA EMIT QILISHNI UNUTGAN EDINGIZ!
          emit(
            state.copyWith(
                propertyModel: success,
                mainStatus: MainStatus.succes
            ),
          );
          event.onSuccess();
        },
      );
    } catch(e) {
      print("💥 Bloc Exception xatolik: $e");
      emit(
        state.copyWith(
          mainStatus: MainStatus.failure,
          errorMessage: e.toString(),
        ),
      );
      event.onFailure();
    }
  }

  Future<void> _urlPhotos(AddPhotosUrlEvent event, Emitter<AddHouseState> emit) async {
    try {
      print("🔄 ${event.photos.length} ta rasm yuklanmoqda...");
      emit(state.copyWith(mainStatus: MainStatus.loading));

      List<PhotosUrl> uploadedUrls = [];
      List<String> errorMessages = [];

      // Upload each image sequentially to avoid overwhelming the server
      for (int i = 0; i < event.photos.length; i++) {
        final file = event.photos[i];
        print("📤 Rasm ${i + 1}/${event.photos.length} yuklanmoqda...");

        final either = await addPhotosUrlUsecase.call(Photos(file: file));

        either.either(
              (failure) {
            print("❌ Rasm ${i + 1} yuklashda xato: $failure");
            errorMessages.add("Rasm ${i + 1}: ${failure.toString()}");
          },
              (success) {
            print("✅ Rasm ${i + 1} muvaffaqiyatli yuklandi: ${success.secureUrl}");
            uploadedUrls.add(success);
          },
        );
      }

      if (uploadedUrls.isEmpty) {
        print("❌ Hech qanday rasm yuklanmadi");
        emit(state.copyWith(
          mainStatus: MainStatus.failure,
          errorMessage: "Rasmlar yuklanmadi: ${errorMessages.join(', ')}",
        ));
        event.onFailure();
        return;
      }

      print("✅ Jami ${uploadedUrls.length} ta rasm yuklandi");

      emit(state.copyWith(
        mainStatus: MainStatus.succes,
        uploadedPhotos: uploadedUrls,
      ));
      event.onSuccess();
    } catch (e) {
      print("💥 Bloc Exception: $e");
      emit(state.copyWith(
        mainStatus: MainStatus.failure,
        errorMessage: e.toString(),
      ));
      event.onFailure();
    }
  }

}