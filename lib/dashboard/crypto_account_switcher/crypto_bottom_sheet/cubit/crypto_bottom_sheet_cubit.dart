import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'crypto_bottom_sheet_cubit.g.dart';

part 'crypto_bottom_sheet_state.dart';

class CryptoBottomSheetCubit extends Cubit<CryptoBottomSheetState> {
  CryptoBottomSheetCubit({
    required this.credentialsCubit,
  }) : super(const CryptoBottomSheetState()) {
    initialise();
  }

  final CredentialsCubit credentialsCubit;

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
    await credentialsCubit.loadAllCredentials(
      blockchainType:
          walletCubit.state.cryptoAccount.data[index].blockchainType,
    );
    emit(state.success(currentCryptoIndex: index));
  }

  Future<void> editCryptoAccount({
    required String newAccountName,
    required int index,
    required BlockchainType blockchainType,
  }) async {
    emit(state.loading());
    await walletCubit.editCryptoAccountName(
      newAccountName: newAccountName,
      blockchainType: blockchainType,
      index: index,
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
      onComplete: (cryptoAccount) {
        emit(state.success(cryptoAccount: cryptoAccount));
      },
    );
  }
}
