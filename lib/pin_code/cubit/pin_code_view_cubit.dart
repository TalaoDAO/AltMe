import 'package:bloc/bloc.dart';

part 'pin_code_view_state.dart';

class PinCodeViewCubit extends Cubit<PinCodeViewState> {
  PinCodeViewCubit() : super(PinCodeViewState());

  void setEnteredPasscode(String enteredPasscode) {
    emit(state.copyWith(enteredPasscode));
  }
}
