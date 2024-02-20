import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/wallet_connect/cubit/wallet_connect_cubit.dart';
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
    required this.keyGenerator,
    required this.credentialsCubit,
    required this.walletConnectCubit,
  }) : super(const WalletState());

  final SecureStorageProvider secureStorageProvider;
  final HomeCubit homeCubit;
  final KeyGenerator keyGenerator;
  final CredentialsCubit credentialsCubit;
  final WalletConnectCubit walletConnectCubit;

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
    bool showStatus = true,
    void Function({
      required CryptoAccount cryptoAccount,
      required MessageHandler messageHandler,
    })? onComplete,
  }) async {
    if (isFromOnboarding) {
      // if enterprise and walletAttestation data is available and added
      await credentialsCubit.addWalletCredential();
    }

    /// tracking added accounts
    final String totalAccountsYet = await secureStorageProvider.get(
          SecureStorageKeys.cryptoAccounTrackingIndex,
        ) ??
        '0';

    final int accountsCount = int.parse(totalAccountsYet);
    final cryptoAccountDataList = List.of(state.cryptoAccount.data);

    final isSecretKey = isValidPrivateKey(mnemonicOrKey);

    /// when blockchain type is pre-selected
    if (blockchainType != null) {
      /// Here, we create temporary accounts and check for their
      /// existence beforehand.
      final newAcc = await _generateAccount(
        mnemonicOrKey: mnemonicOrKey,
        isImported: isImported,
        isSecretKey: isSecretKey,
        blockchainType: blockchainType,
        totalAccountsYet: int.parse(totalAccountsYet),
      );

      ///Before creating a duplicate account, please ensure that it
      ///doesn't already exist.
      if (cryptoAccountDataList.any(
        (acc) =>
            acc.walletAddress == newAcc.walletAddress &&
            acc.blockchainType == newAcc.blockchainType,
      )) {
        onComplete?.call(
          cryptoAccount: CryptoAccount(data: cryptoAccountDataList),
          messageHandler: ResponseMessage(
            message:
                ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ALREADY_EXIST,
          ),
        );
        return;
      }

      log.i('creating both $blockchainType accounts');
      cryptoAccountDataList.add(
        await _createBlockchainAccount(
          accountName: accountName,
          mnemonicOrKey: mnemonicOrKey,
          isImported: isImported,
          isSecretKey: isSecretKey,
          blockchainType: blockchainType,
          totalAccountsYet: accountsCount,
          showStatus: showStatus,
        ),
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
          cryptoAccountDataList.add(
            await _createBlockchainAccount(
              accountName: accountName,
              mnemonicOrKey: mnemonicOrKey,
              isImported: isImported,
              isSecretKey: isSecretKey,
              blockchainType: BlockchainType.tezos,
              totalAccountsYet: accountsCount,
              showStatus: showStatus,
            ),
          );
        } else {
          /// creating all ethereum based accounts
          cryptoAccountDataList.add(
            await _createBlockchainAccount(
              accountName: accountName,
              mnemonicOrKey: mnemonicOrKey,
              isImported: isImported,
              isSecretKey: isSecretKey,
              blockchainType: BlockchainType.fantom,
              totalAccountsYet: accountsCount,
              showStatus: showStatus,
            ),
          );
          cryptoAccountDataList.add(
            await _createBlockchainAccount(
              accountName: accountName,
              mnemonicOrKey: mnemonicOrKey,
              isImported: isImported,
              isSecretKey: isSecretKey,
              blockchainType: BlockchainType.polygon,
              totalAccountsYet: accountsCount + 1,
              showStatus: showStatus,
            ),
          );
          cryptoAccountDataList.add(
            await _createBlockchainAccount(
              accountName: accountName,
              mnemonicOrKey: mnemonicOrKey,
              isImported: isImported,
              isSecretKey: isSecretKey,
              blockchainType: BlockchainType.binance,
              totalAccountsYet: accountsCount + 2,
              showStatus: showStatus,
            ),
          );
          cryptoAccountDataList.add(
            await _createBlockchainAccount(
              accountName: accountName,
              mnemonicOrKey: mnemonicOrKey,
              isImported: isImported,
              isSecretKey: isSecretKey,
              blockchainType: BlockchainType.ethereum,
              totalAccountsYet: accountsCount + 3,
              showStatus: showStatus,
            ),
          );
        }
      } else {
        /// Polygon at start
        cryptoAccountDataList.add(
          await _createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.polygon,
            totalAccountsYet: accountsCount,
            showStatus: showStatus,
          ),
        );

        /// Binance at start
        cryptoAccountDataList.add(
          await _createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.binance,
            totalAccountsYet: accountsCount + 1,
            showStatus: showStatus,
          ),
        );

        /// Tezos at start
        cryptoAccountDataList.add(
          await _createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.tezos,
            totalAccountsYet: accountsCount + 2,
            showStatus: showStatus,
          ),
        );

        /// Ethereum at start
        cryptoAccountDataList.add(
          await _createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: BlockchainType.ethereum,
            totalAccountsYet: accountsCount + 3,
            showStatus: showStatus,
          ),
        );
      }
    }

    final updatedCryptoAccount = CryptoAccount(data: cryptoAccountDataList);
    await _saveCryptoAccountDataInStorage(updatedCryptoAccount);

    if (blockchainType != BlockchainType.tezos) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await walletConnectCubit.initialise();
    }

    emitCryptoAccount(updatedCryptoAccount);

    onComplete?.call(
      cryptoAccount: updatedCryptoAccount,
      messageHandler: ResponseMessage(
        message: ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED,
      ),
    );

    /// set new account as current
    await setCurrentWalletAccount(cryptoAccountDataList.length - 1);
  }

  Future<CryptoAccountData> _createBlockchainAccount({
    String? accountName,
    required String mnemonicOrKey,
    required bool isImported,
    required bool isSecretKey,
    required BlockchainType blockchainType,
    required int totalAccountsYet,
    required bool showStatus,
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

    log.i('$blockchainType created');

    /// If we are not using crypto in the wallet we are not generating
    /// AssociatedAddress credentials.
    final credential = Parameters.walletHandlesCrypto
        ? await credentialsCubit.createOrUpdateAssociatedWalletCredential(
            blockchainType: blockchainType,
            cryptoAccountData: cryptoAccountData,
          )
        : null;

    if (credential != null) {
      await credentialsCubit.insertCredential(
        credential: credential,
        showMessage: false,
        showStatus: showStatus,
      );
    }

    return cryptoAccountData;
  }

  /// Add newly created accounts to the list for safekeeping.
  Future<void> _saveCryptoAccountDataInStorage(
    CryptoAccount cryptoAccount,
  ) async {
    final String cryptoAccountString = jsonEncode(cryptoAccount);

    await secureStorageProvider.set(
      SecureStorageKeys.cryptoAccount,
      cryptoAccountString,
    );
  }

  Future<CryptoAccountData> _generateAccount({
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

    String name = 'My Account $newCount';

    if (accountName != null && accountName.isNotEmpty) {
      name = accountName;
    }

    return CryptoAccountData(
      name: name,
      walletAddress: walletAddress,
      secretKey: secretKey,
      isImported: isImported,
      blockchainType: blockchainType,
    );
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
      [
        SecureStorageKeys.version,
      ],
    );

    // await credentialsRepository.deleteAll();
    // await profileCubit.resetProfile();
    // await connectedDappRepository.deleteAll();

    /// clear app states
    homeCubit.emitHasNoWallet();
    credentialsCubit.reset();
    emit(
      state.copyWith(
        status: WalletStatus.reset,
        cryptoAccount: const CryptoAccount(),
        currentCryptoIndex: 0,
      ),
    );
    emit(state.copyWith(status: WalletStatus.init));
  }

  CryptoAccountData? getCryptoAccountData(String publicKey) {
    final CryptoAccountData? currentAccount =
        state.cryptoAccount.data.firstWhereOrNull(
      (element) =>
          element.walletAddress.toUpperCase() == publicKey.toUpperCase(),
    );
    return currentAccount;
  }
}
