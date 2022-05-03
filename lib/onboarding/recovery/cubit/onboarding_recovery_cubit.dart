import 'package:altme/app/app.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:cryptocurrency_keys/cryptocurrency_keys.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'onboarding_recovery_cubit.g.dart';

part 'onboarding_recovery_state.dart';

class OnBoardingRecoveryCubit extends Cubit<OnBoardingRecoveryState> {
  OnBoardingRecoveryCubit({
    required this.walletCubit,
    required this.cryptoKeys,
    required this.secureStorageProvider,
  }) : super(const OnBoardingRecoveryState());

  final WalletCubit walletCubit;
  final CryptocurrencyKeys cryptoKeys;
  final SecureStorageProvider secureStorageProvider;

  void isMnemonicsValid(String value) {
    emit(
      state.success(
        isTextFieldEdited: value.isNotEmpty,
        isMnemonicValid: bip39.validateMnemonic(value) && value.isNotEmpty,
      ),
    );
  }

  Future<void> saveMnemonic(String mnemonic) async {
    await secureStorageProvider.set(SecureStorageKeys.mnemonic, mnemonic);
  }
}
