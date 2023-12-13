import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';

class ActiveBiometricsCubit extends Cubit<bool> {
  ActiveBiometricsCubit({required this.profileCubit}) : super(false);

  final ProfileCubit profileCubit;

  void load() {
    final type = profileCubit.state.model.walletProtectionType;
    final isEnabled = type == WalletProtectionType.FA2 ||
        type == WalletProtectionType.biometrics;
    emit(isEnabled);
  }

  void updateSwitch({required bool value}) {
    emit(value);
  }
}
