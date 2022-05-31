import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';

class HomeCubit extends Cubit<HomeStatus> {
  HomeCubit() : super(HomeStatus.hasNoWallet);

  void emitHasWallet() {
    emit(HomeStatus.hasWallet);
  }

  void emitHasNoWallet() {
    emit(HomeStatus.hasNoWallet);
  }
}
