import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';

import 'package:secure_storage/secure_storage.dart';

part 'wallet_cubit.g.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required this.secureStorageProvider,
    required this.homeCubit,
    required this.credentialListCubit,
    required this.keyGenerator,
    required this.credentialsCubit,
  }) : super(const WalletState());

  final SecureStorageProvider secureStorageProvider;
  final HomeCubit homeCubit;
  final CredentialListCubit credentialListCubit;
  final KeyGenerator keyGenerator;
  final CredentialsCubit credentialsCubit;

  final log = getLogger('WalletCubit');

  Future<void> setCurrentWalletAccount(int index) async {
    emit(state.loading());
    await secureStorageProvider.set(
      SecureStorageKeys.currentCryptoIndex,
      index.toString(),
    );
    emit(
      state.copyWith(
        status: WalletStatus.populate,
        currentCryptoIndex: index,
      ),
    );
  }

  Future<void> createCryptoWallet({
    String? accountName,
    required String mnemonicOrKey,
    required bool isImported,
    required bool isFromOnboarding,
    BlockchainType? blockchainType,
    void Function({
      required CryptoAccount cryptoAccount,
      required MessageHandler messageHandler,
    })?
        onComplete,
  }) async {
    if (isFromOnboarding) {
      final String? ssiKey =
          await secureStorageProvider.get(SecureStorageKeys.ssiKey);
      if (ssiKey != null) {
        await credentialsCubit.addRequiredCredentials(ssiKey: ssiKey);
      }
    }

    /// tracking added accounts
    final String totalAccountsYet = await secureStorageProvider.get(
          SecureStorageKeys.cryptoAccounTrackingIndex,
        ) ??
        '0';

    final int accountsCount = int.parse(totalAccountsYet);
    late CryptoAccount updatedCryptoAccount;

    final isSecretKey = isValidPrivateKey(mnemonicOrKey);

    /// when blockchain type is pre-selected
    if (blockchainType != null) {
      log.i('creating both $blockchainType accounts');
      updatedCryptoAccount = await createBlockchainAccount(
        accountName: accountName,
        mnemonicOrKey: mnemonicOrKey,
        isImported: isImported,
        isSecretKey: isSecretKey,
        blockchainType: blockchainType,
        totalAccountsYet: accountsCount,
      );
    } else {
      if (isSecretKey) {
        final isTezosSecretKey = mnemonicOrKey.startsWith('edsk') ||
            mnemonicOrKey.startsWith('spsk') ||
            mnemonicOrKey.startsWith('p2sk');

        log.i(
          'creating ${isTezosSecretKey ? 'tezos' : 'ethereum based'} account',
        );

        if (isTezosSecretKey) {
          /// creating tezos account
          updatedCryptoAccount = await createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.tezos,
            totalAccountsYet: accountsCount,
          );
        } else {
          /// creating all ethereum based accounts
          await createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.fantom,
            totalAccountsYet: accountsCount,
          );
          await createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.polygon,
            totalAccountsYet: accountsCount + 1,
          );
          await createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.binance,
            totalAccountsYet: accountsCount + 2,
          );
          updatedCryptoAccount = await createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.ethereum,
            totalAccountsYet: accountsCount + 3,
          );
        }
      } else {
        /// polygon at start
        await createBlockchainAccount(
          accountName: accountName,
          mnemonicOrKey: mnemonicOrKey,
          isImported: isImported,
          isSecretKey: isSecretKey,
          blockchainType: BlockchainType.polygon,
          totalAccountsYet: accountsCount,
        );

        /// tezos at start
        updatedCryptoAccount = await createBlockchainAccount(
          accountName: accountName,
          mnemonicOrKey: mnemonicOrKey,
          isImported: isImported,
          isSecretKey: isSecretKey,
          blockchainType: BlockchainType.tezos,
          totalAccountsYet: accountsCount + 1,
        );
      }
    }

    onComplete?.call(
      cryptoAccount: updatedCryptoAccount,
      messageHandler: ResponseMessage(
        ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED,
      ),
    );
  }

  Future<CryptoAccount> createBlockchainAccount({
    String? accountName,
    required String mnemonicOrKey,
    required bool isImported,
    required bool isSecretKey,
    required BlockchainType blockchainType,
    required int totalAccountsYet,
  }) async {
    final AccountType accountType = blockchainType.accountType;

    int derivePathIndex = 0;
    final bool isCreated = !isImported;

    log.i('isImported - $isImported');
    if (isCreated) {
      /// Note: while adding derivePathIndex is always increased
      final String? savedDerivePathIndex =
          await secureStorageProvider.get(blockchainType.derivePathIndexKey);

      if (savedDerivePathIndex != null && savedDerivePathIndex.isNotEmpty) {
        derivePathIndex = int.parse(savedDerivePathIndex) + 1;
      }

      await secureStorageProvider.set(
        blockchainType.derivePathIndexKey,
        derivePathIndex.toString(),
      );
    }

    log.i('derivePathIndex - $derivePathIndex');

    /// Note: while importing derivePathIndex is always 0

    late String walletAddress;
    late String secretKey;

    if (isSecretKey) {
      secretKey = mnemonicOrKey;

      walletAddress = await keyGenerator.walletAddressFromSecretKey(
        secretKey: secretKey,
        accountType: accountType,
      );
    } else {
      secretKey = await keyGenerator.secretKeyFromMnemonic(
        mnemonic: mnemonicOrKey,
        accountType: accountType,
        derivePathIndex: derivePathIndex,
      );

      walletAddress = await keyGenerator.walletAddressFromMnemonic(
        mnemonic: mnemonicOrKey,
        accountType: accountType,
        derivePathIndex: derivePathIndex,
      );
    }

    final int newCount = totalAccountsYet + 1;

    await secureStorageProvider.set(
      SecureStorageKeys.cryptoAccounTrackingIndex,
      newCount.toString(),
    );

    String name = 'My Account $newCount';

    if (accountName != null && accountName.isNotEmpty) {
      name = accountName;
    }

    final CryptoAccountData cryptoAccountData = CryptoAccountData(
      name: name,
      walletAddress: walletAddress,
      secretKey: secretKey,
      isImported: isImported,
      blockchainType: blockchainType,
    );
    final cryptoAccounts = List.of(state.cryptoAccount.data)
      ..add(cryptoAccountData);

    final CryptoAccount cryptoAccount = CryptoAccount(data: cryptoAccounts);
    final String cryptoAccountString = jsonEncode(cryptoAccount);

    await secureStorageProvider.set(
      SecureStorageKeys.cryptoAccount,
      cryptoAccountString,
    );

    emitCryptoAccount(cryptoAccount);

    /// set new account as current
    await setCurrentWalletAccount(cryptoAccounts.length - 1);
    log.i('$blockchainType created');

    final credential = await credentialsCubit.createAssociatedWalletCredential(
      blockchainType: blockchainType,
      cryptoAccountData: cryptoAccountData,
    );

    if (credential != null) {
      await credentialsCubit.insertCredential(
        credential: credential,
        showMessage: false,
      );
    }

    return cryptoAccount;
  }

  Future<void> editCryptoAccountName({
    required String newAccountName,
    required int index,
    dynamic Function(CryptoAccount cryptoAccount)? onComplete,
    required BlockchainType blockchainType,
  }) async {
    final CryptoAccountData cryptoAccountData = state.cryptoAccount.data[index];
    cryptoAccountData.name = newAccountName;

    final cryptoAccounts = List.of(state.cryptoAccount.data);
    cryptoAccounts[index] = cryptoAccountData;

    final CryptoAccount cryptoAccount = CryptoAccount(data: cryptoAccounts);
    final String cryptoAccountString = jsonEncode(cryptoAccount.toJson());

    await secureStorageProvider.set(
      SecureStorageKeys.cryptoAccount,
      cryptoAccountString,
    );

    await credentialsCubit.insertOrUpdateAssociatedWalletCredential(
      blockchainType: blockchainType,
      cryptoAccountData: cryptoAccountData,
    );

    emitCryptoAccount(cryptoAccount);

    onComplete?.call(cryptoAccount);
  }

  void emitCryptoAccount(CryptoAccount cryptoAccount) {
    emit(
      state.copyWith(
        status: WalletStatus.populate,
        cryptoAccount: cryptoAccount,
      ),
    );
  }

  Future<void> resetWallet() async {
    await secureStorageProvider.deleteAllExceptsSomeKeys(
      [SecureStorageKeys.version],
    );

    // await credentialsRepository.deleteAll();
    // await profileCubit.resetProfile();
    // await connectedDappRepository.deleteAll();

    /// clear app states
    homeCubit.emitHasNoWallet();
    await credentialListCubit.clearHomeCredentials();
    emit(
      state.copyWith(
        status: WalletStatus.reset,
        cryptoAccount: const CryptoAccount(),
        currentCryptoIndex: 0,
      ),
    );
    emit(state.copyWith(status: WalletStatus.init));
  }
}
