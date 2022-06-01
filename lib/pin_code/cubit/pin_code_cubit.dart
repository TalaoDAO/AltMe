import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'pin_code_cubit.g.dart';

part 'pin_code_state.dart';

class PinCodeCubit extends Cubit<PinCodeState> {
  PinCodeCubit({required this.secureStorageProvider})
      : super(const PinCodeState());

  final SecureStorageProvider secureStorageProvider;

  Future<void> savePinCode(String pinCode) async {
    try {
      emit(state.loading());
      await secureStorageProvider.set(SecureStorageKeys.pinCode, pinCode);
      emit(state.success(data: true));
    } catch (e) {
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
    }
  }

  Future<void> isValidPinCode(String pinCode) async {
    try {
      emit(state.loading());
      final savedPinCode =
          await secureStorageProvider.get(SecureStorageKeys.pinCode);
      if (savedPinCode == pinCode) {
        emit(state.success(data: true));
      } else {
        emit(state.success(data: false));
      }
    } catch (e) {
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_SOMETHING_WENT_WRONG_TRY_AGAIN_LATER,
          ),
        ),
      );
    }
  }
}
