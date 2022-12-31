import 'package:altme/app/shared/shared.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'create_account_state.dart';
part 'create_account_cubit.g.dart';

class CreateAccountCubit extends Cubit<CreateAccountState> {
  CreateAccountCubit({
    required this.walletCubit,
  }) : super(const CreateAccountState());

  final WalletCubit walletCubit;

  Future<void> createCryptoAccount({
    String? accountName,
    required BlockchainType blockChaintype,
  }) async {
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final String? ssiMnemonic =
        await getSecureStorage.get(SecureStorageKeys.ssiMnemonic);

    await walletCubit.createCryptoWallet(
      accountName: accountName,
      isImported: false,
      mnemonicOrKey: ssiMnemonic!,
      blockchainType: blockChaintype,
      isFromOnboarding: false,
      onComplete: ({
        required CryptoAccount cryptoAccount,
        required MessageHandler messageHandler,
      }) async {
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
}
