import 'package:altme/app/app.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'crypto_bottom_sheet_cubit.g.dart';

part 'crypto_bottom_sheet_state.dart';

class CryptoBottomSheetCubit extends Cubit<CryptoBottomSheetState> {
  CryptoBottomSheetCubit({
    required this.secureStorageProvider,
    required this.walletCubit,
  }) : super(CryptoBottomSheetState()) {
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
      onComplete: (cryptoAccount) {
        emit(state.success(cryptoAccount: cryptoAccount));
      },
    );
  }
}
