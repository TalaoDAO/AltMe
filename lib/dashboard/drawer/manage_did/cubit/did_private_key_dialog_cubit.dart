import 'package:bloc/bloc.dart';

class DIDPrivateKeyDialogCubit extends Cubit<bool> {
  DIDPrivateKeyDialogCubit() : super(false);

  void toggleState() {
    emit(!state);
  }
}
