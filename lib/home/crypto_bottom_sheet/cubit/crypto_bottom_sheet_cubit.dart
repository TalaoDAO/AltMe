import 'package:altme/app/app.dart';
import 'package:altme/wallet/cubit/wallet_cubit.dart';
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
  }) : super(const CryptoBottomSheetState());

  final SecureStorageProvider secureStorageProvider;
  final WalletCubit walletCubit;

  Future<void> addCryptoAccount() async {
    emit(state.loading());
    final String? ssiMnemonic =
        await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);
    await walletCubit.createCryptoWallet(mnemonic: ssiMnemonic!);
    emit(state.success());
    //show message
  }
}
