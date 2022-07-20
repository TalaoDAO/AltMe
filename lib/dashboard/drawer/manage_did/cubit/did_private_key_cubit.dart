import 'package:bloc/bloc.dart';

class DIDPrivateKeyCubit extends Cubit<bool> {
  DIDPrivateKeyCubit() : super(false);

  void toggleState() {
    emit(!state);
  }
}

