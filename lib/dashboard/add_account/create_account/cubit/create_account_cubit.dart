import 'package:altme/app/shared/shared.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    required this.credentialsCubit,
    required this.qrCodeScanCubit,
    required this.walletConnectCubit,
  }) : super(const CreateAccountState());

  final WalletCubit walletCubit;
  final CredentialsCubit credentialsCubit;
  final QRCodeScanCubit qrCodeScanCubit;
  final WalletConnectCubit walletConnectCubit;

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
      showStatus: false,
      qrCodeScanCubit: qrCodeScanCubit,
      credentialsCubit: credentialsCubit,
      walletConnectCubit: walletConnectCubit,
      onComplete: ({
        required CryptoAccount cryptoAccount,
        required MessageHandler messageHandler,
      }) async {
        emit(
          state.success(
            cryptoAccount: cryptoAccount,
            messageHandler: ResponseMessage(
              message: ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED,
            ),
          ),
        );
      },
    );
  }
}
