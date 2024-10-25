import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';

class RestoreOptionsCubit extends Cubit<RestoreType> {
  RestoreOptionsCubit() : super(RestoreType.cryptoWallet);

  void updateSwitch(RestoreType restoreType) {
    emit(restoreType);
  }
}
