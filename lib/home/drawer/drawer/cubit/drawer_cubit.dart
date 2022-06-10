import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:secure_storage/secure_storage.dart';

part 'drawer_state.dart';

class DrawerCubit extends Cubit<DrawerState> {
  DrawerCubit() : super(const DrawerState()) {
    init();
  }

  Future<void> init() async {
    final fingerprintEnabled =
        await getSecureStorage.get(SecureStorageKeys.fingerprintEnabled);
    setFingerprintEnabled(enabled: fingerprintEnabled == true.toString());
  }

  void setFingerprintEnabled({bool enabled = false}) {
    emit(state.copyWith(isBiometricsEnable: enabled));
  }
}
