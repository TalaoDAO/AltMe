import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/did/did.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';

import 'package:secure_storage/secure_storage.dart';

part 'import_account_cubit.g.dart';
part 'import_account_state.dart';

class ImportAccountCubit extends Cubit<ImportAccountState> {
  ImportAccountCubit({
    required this.didKitProvider,
    required this.secureStorageProvider,
    required this.keyGenerator,
    required this.homeCubit,
    required this.didCubit,
    required this.walletCubit,
  }) : super(const ImportAccountState());

  final DIDKitProvider didKitProvider;
  final SecureStorageProvider secureStorageProvider;
  final KeyGenerator keyGenerator;
  final HomeCubit homeCubit;
  final DIDCubit didCubit;
  final WalletCubit walletCubit;

  void isMnemonicsOrKeyValid(String value) {
    //different type of tezos private keys start with 'edsk' ,
    //'pspsk' and 'p2sk;
    final bool isSecretKey = isValidPrivateKey(value);

    emit(
      state.populating(
        isTextFieldEdited: value.isNotEmpty,
        isMnemonicOrKeyValid:
            (bip39.validateMnemonic(value) || isSecretKey) && value.isNotEmpty,
      ),
    );
  }

  void setAccountType(AccountType accountType) {
    emit(
      state.populating(
        accountType: accountType,
      ),
    );
  }

  Future<void> import({String? accountName}) async {
    final log = getLogger('ImportAccountCubit - import');
    emit(state.loading());
    await Future<void>.delayed(const Duration(milliseconds: 500));

    try {
      /// crypto wallet
      final BlockchainType blockchainType =
          getBlockchainType(state.accountType);

      final String? mnemonicOrKey = await getSecureStorage
          .get(SecureStorageKeys.importAccountStep2Mnemonics);

      if (mnemonicOrKey == null) throw Exception();

      await walletCubit.createCryptoWallet(
        accountName: accountName,
        mnemonicOrKey: mnemonicOrKey,
        isImported: true,
        blockchainType: blockchainType,
        isFromOnboarding: false,
        onComplete: ({
          required CryptoAccount cryptoAccount,
          required MessageHandler messageHandler,
        }) async {
          emit(
            state.success(
              messageHandler: ResponseMessage(
                ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED,
              ),
            ),
          );
        },
      );

      await getSecureStorage
          .delete(SecureStorageKeys.importAccountStep2Mnemonics);

      await homeCubit.emitHasWallet();
      emit(state.success());
    } catch (error, stack) {
      log.e('error: $error,stack: $stack');
      log.e('something went wrong when generating a key', error);
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_ERROR_GENERATING_KEY,
          ),
        ),
      );
    }
  }
}
