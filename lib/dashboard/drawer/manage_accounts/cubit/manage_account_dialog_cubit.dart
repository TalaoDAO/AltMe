import 'package:bloc/bloc.dart';

class ManageAccountDialogCubit extends Cubit<bool> {
  ManageAccountDialogCubit() : super(false);

  void toggleState() {
    emit(!state);
  }
}
