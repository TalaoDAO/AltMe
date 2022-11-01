import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'biometrics_cubit.g.dart';
part 'biometrics_state.dart';

class BiometricsCubit extends Cubit<BiometricsState> {
  BiometricsCubit() : super(const BiometricsState()) {
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
