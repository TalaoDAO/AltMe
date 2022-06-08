import 'package:bloc/bloc.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(const DrawerState());

  void setFingerprintEnabled({bool enabled = false}) {
    emit(state.copyWith(isBiometricsEnable: enabled));
  }
}
