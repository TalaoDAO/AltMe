import 'package:altme/app/app.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'manage_accounts_cubit.g.dart';

part 'manage_accounts_state.dart';

class ManageAccountsCubit extends Cubit<ManageAccountsState> {
  ManageAccountsCubit({
    required this.secureStorageProvider,
    required this.walletCubit,
  }) : super(ManageAccountsState()) {
    initialise();
  }

  final SecureStorageProvider secureStorageProvider;
  final WalletCubit walletCubit;

  Future<void> initialise() async {
    emit(state.loading());
    emit(
      state.success(
        currentCryptoIndex: walletCubit.state.currentCryptoIndex,
        cryptoAccount: walletCubit.state.cryptoAccount,
      ),
    );
  }

  Future<void> setCurrentWalletAccount(int index) async {
    emit(state.loading());
    await walletCubit.setCurrentWalletAccount(index);
    emit(state.success(currentCryptoIndex: index));
  }

  Future<void> addCryptoAccount({String? accountName}) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final String? ssiMnemonic =
        await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);

    await walletCubit.createCryptoWallet(
      accountName: accountName,
      isImported: false,
      mnemonicOrKey: ssiMnemonic!,
      onComplete: (cryptoAccount, newIndex) {
        emit(
          state.success(
            cryptoAccount: cryptoAccount,
            messageHandler: ResponseMessage(
              ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED,
            ),
          ),
        );
      },
    );
  }

  Future<void> editCryptoAccount({
    required String newAccountName,
    required int index,
  }) async {
    emit(state.loading());
    await walletCubit.editCryptoAccountName(
      newAccountName: newAccountName,
      index: index,
      onComplete: (cryptoAccount) {
        emit(state.success(cryptoAccount: cryptoAccount));
      },
    );
  }
}
