import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manage_accounts_cubit.g.dart';

part 'manage_accounts_state.dart';

class ManageAccountsCubit extends Cubit<ManageAccountsState> {
  ManageAccountsCubit({
    required this.credentialsCubit,
    required this.manageNetworkCubit,
  }) : super(const ManageAccountsState()) {
    initialise();
  }

  final CredentialsCubit credentialsCubit;
  final ManageNetworkCubit manageNetworkCubit;

  WalletCubit get walletCubit => credentialsCubit.walletCubit;

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

    final blockchainType =
        walletCubit.state.cryptoAccount.data[index].blockchainType;
    await credentialsCubit.loadAllCredentials(
      blockchainType: blockchainType,
    );
    emit(state.success(currentCryptoIndex: index));

    final testnet = credentialsCubit
        .profileCubit.state.model.profileSetting.blockchainOptions?.testnet;

    if (testnet != null) {
      final currentNetworkList = blockchainType.networks;
      if (testnet) {
        await manageNetworkCubit.setNetwork(currentNetworkList[1]);
      } else {
        await manageNetworkCubit.setNetwork(currentNetworkList[0]);
      }
    }
  }

  Future<void> editCryptoAccount({
    required String newAccountName,
    required int index,
    required BlockchainType blockchainType,
  }) async {
    emit(state.loading());
    await walletCubit.editCryptoAccountName(
      newAccountName: newAccountName,
      index: index,
      blockchainType: blockchainType,
      credentialsCubit: credentialsCubit,
      onComplete: (cryptoAccount) {
        emit(state.success(cryptoAccount: cryptoAccount));
      },
    );
  }

  Future<void> deleteCryptoAccount({
    required int index,
    required BlockchainType blockchainType,
  }) async {
    // should not be able to delete correct index
    emit(state.loading());
    await walletCubit.deleteCryptoAccount(
      index: index,
      blockchainType: blockchainType,
      credentialsCubit: credentialsCubit,
      onComplete: (cryptoAccount, newIndex) {
        emit(
          state.success(
            cryptoAccount: cryptoAccount,
            currentCryptoIndex: newIndex,
          ),
        );
      },
    );
  }
}
