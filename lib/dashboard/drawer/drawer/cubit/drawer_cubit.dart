import 'package:arago_wallet/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'drawer_cubit.g.dart';
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
    emit(state.copyWith(isBiometricsEnabled: enabled));
  }
}
