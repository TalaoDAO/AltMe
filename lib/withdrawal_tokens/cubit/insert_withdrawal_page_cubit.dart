import 'package:bloc/bloc.dart';

class InsertWithdrawalPageCubit extends Cubit<bool> {
  InsertWithdrawalPageCubit() : super(false);

  void isValidWithdrawal({required bool isValid}) {
    emit(isValid);
  }
}
