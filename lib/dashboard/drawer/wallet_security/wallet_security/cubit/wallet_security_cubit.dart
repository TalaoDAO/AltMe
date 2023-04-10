import 'package:altme/app/app.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'wallet_security_cubit.g.dart';
part 'wallet_security_state.dart';

class WalletSecurityCubit extends Cubit<WalletSecurityState> {
  WalletSecurityCubit() : super(const WalletSecurityState()) {
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
