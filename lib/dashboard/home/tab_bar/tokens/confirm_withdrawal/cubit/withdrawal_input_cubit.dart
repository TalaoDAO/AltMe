import 'package:bloc/bloc.dart';

class WithdrawalInputCubit extends Cubit<bool> {
  WithdrawalInputCubit() : super(true);

  void setState({required bool isTextFieldEmpty}) {
    emit(isTextFieldEmpty);
  }
}
