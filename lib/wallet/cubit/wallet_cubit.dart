import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/wallet_connect/cubit/wallet_connect_cubit.dart';
import 'package:altme/credentials/credentials.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/key_generator/key_generator.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:secure_storage/secure_storage.dart';

part 'wallet_cubit.g.dart';
part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required this.secureStorageProvider,
    required this.homeCubit,
    required this.keyGenerator,
  }) : super(const WalletState());

  final SecureStorageProvider secureStorageProvider;
  final HomeCubit homeCubit;
  final KeyGenerator keyGenerator;

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
    required QRCodeScanCubit qrCodeScanCubit,
    required CredentialsCubit credentialsCubit,
    required WalletConnectCubit walletConnectCubit,
    BlockchainType? blockchainType,
    bool showStatus = true,
    void Function({
      required CryptoAccount cryptoAccount,
      required MessageHandler messageHandler,
    })? onComplete,
  }) async {
// if wallet has no crypto do nothing and return
    if (!Parameters.walletHandlesCrypto) {
      return;
    }

    // if (isFromOnboarding) {
    //   // if enterprise and walletAttestation data is available and added
    //   await credentialsCubit.addWalletCredential(
    //     blockchainType: state.currentAccount?.blockchainType,
    //   );
    // }

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
      final newAcc = await generateAccount(
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
          qrCodeScanCubit: qrCodeScanCubit,
          credentialsCubit: credentialsCubit,
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
              qrCodeScanCubit: qrCodeScanCubit,
              credentialsCubit: credentialsCubit,
            ),
          );
        } else {
          /// creating all ethereum based accounts

          final accounts = <BlockchainType, int>{
            BlockchainType.fantom: 0,
            BlockchainType.polygon: 1,
            BlockchainType.binance: 2,
            BlockchainType.etherlink: 3,
            BlockchainType.ethereum: 4,
          };

          for (final entry in accounts.entries) {
            final blockchainType = entry.key;
            final value = entry.value;

            final accountData = await _createBlockchainAccount(
              accountName: accountName,
              mnemonicOrKey: mnemonicOrKey,
              isImported: isImported,
              isSecretKey: isSecretKey,
              blockchainType: blockchainType,
              totalAccountsYet: accountsCount + value,
              showStatus: showStatus,
              qrCodeScanCubit: qrCodeScanCubit,
              credentialsCubit: credentialsCubit,
            );

            cryptoAccountDataList.add(accountData);
          }
        }
      } else {
        /// creating accounts at start

        final accounts = <BlockchainType, int>{
          BlockchainType.fantom: 0,
          BlockchainType.polygon: 1,
          BlockchainType.binance: 2,
          BlockchainType.tezos: 3,
          BlockchainType.etherlink: 4,
          BlockchainType.ethereum: 5, // default account as it is last
        };

        for (final entry in accounts.entries) {
          final blockchainType = entry.key;
          final value = entry.value;

          final accountData = await _createBlockchainAccount(
            accountName: accountName,
            mnemonicOrKey: mnemonicOrKey,
            isImported: isImported,
            isSecretKey: isSecretKey,
            blockchainType: blockchainType,
            totalAccountsYet: accountsCount + value,
            showStatus: showStatus,
            qrCodeScanCubit: qrCodeScanCubit,
            credentialsCubit: credentialsCubit,
          );

          cryptoAccountDataList.add(accountData);
        }
      }
    }

    final updatedCryptoAccount = CryptoAccount(data: cryptoAccountDataList);
    await _saveCryptoAccountDataInStorage(updatedCryptoAccount);

    await Future<void>.delayed(const Duration(milliseconds: 500));
    await walletConnectCubit.initialise();

    /// set new account as current
    await setCurrentWalletAccount(cryptoAccountDataList.length - 1);

    emitCryptoAccount(updatedCryptoAccount);

    onComplete?.call(
      cryptoAccount: updatedCryptoAccount,
      messageHandler: ResponseMessage(
        message: ResponseString.RESPONSE_STRING_CRYPTO_ACCOUNT_ADDED,
      ),
    );
  }

  Future<CryptoAccountData> _createBlockchainAccount({
    String? accountName,
    required String mnemonicOrKey,
    required bool isImported,
    required bool isSecretKey,
    required BlockchainType blockchainType,
    required int totalAccountsYet,
    required bool showStatus,
    required QRCodeScanCubit qrCodeScanCubit,
    required CredentialsCubit credentialsCubit,
  }) async {
    final AccountType accountType = blockchainType.accountType;

    int derivePathIndex = 0;
    final bool isCreated = !isImported;

    final String? savedDerivePathIndex =
        await secureStorageProvider.get(blockchainType.derivePathIndexKey);

    log.i('isImported - $isImported');
    if (isCreated) {
      /// Note: while adding derivePathIndex is always increased

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

    if (savedDerivePathIndex == null) {
      // at start it should be 0
      await secureStorageProvider.set(blockchainType.derivePathIndexKey, '0');
    }

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
    if (Parameters.walletHandlesCrypto) {
      // only for default profile at wallet creation
      // get crurrent current profile type from profileCubit
      final ProfileType currentProfileType =
          credentialsCubit.profileCubit.state.model.profileType;
      if (currentProfileType != ProfileType.enterprise) {
        await credentialsCubit.profileCubit.setProfile(ProfileType.defaultOne);
        await credentialsCubit.insertAssociatedWalletCredential(
          cryptoAccountData: cryptoAccountData,
        );
        await credentialsCubit.profileCubit.setProfile(currentProfileType);
      } else {
        await credentialsCubit.insertAssociatedWalletCredential(
          cryptoAccountData: cryptoAccountData,
        );
      }
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

  Future<CryptoAccountData> generateAccount({
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
    required CredentialsCubit credentialsCubit,
  }) async {
    emit(state.copyWith(status: WalletStatus.loading));

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

    emitCryptoAccount(cryptoAccount);

    onComplete?.call(cryptoAccount);
  }

  Future<void> deleteCryptoAccount({
    required int index,
    dynamic Function(CryptoAccount cryptoAccount, int newIndex)? onComplete,
    required BlockchainType blockchainType,
    required CredentialsCubit credentialsCubit,
  }) async {
    emit(state.copyWith(status: WalletStatus.loading));

    // final CryptoAccountData deletedCryptoAccountData =
    //     state.cryptoAccount.data[index];

    final cryptoAccounts = List.of(state.cryptoAccount.data)..removeAt(index);

    final CryptoAccount cryptoAccount = CryptoAccount(data: cryptoAccounts);
    final String cryptoAccountString = jsonEncode(cryptoAccount.toJson());

    await secureStorageProvider.set(
      SecureStorageKeys.cryptoAccount,
      cryptoAccountString,
    );

    /// check if associated wallet credential is available for
    /// blockchain type

    /// update current index after deletion
    final CryptoAccountData currentCryptoAccountData =
        state.cryptoAccount.data[state.currentCryptoIndex];
    final newIndex = cryptoAccounts.indexWhere(
      (account) =>
          account.walletAddress == currentCryptoAccountData.walletAddress &&
          account.blockchainType == currentCryptoAccountData.blockchainType,
    );
    await setCurrentWalletAccount(newIndex);

    emitCryptoAccount(cryptoAccount);

    onComplete?.call(cryptoAccount, newIndex);
  }

  void emitCryptoAccount(CryptoAccount cryptoAccount) {
    emit(
      state.copyWith(
        status: WalletStatus.populate,
        cryptoAccount: cryptoAccount,
      ),
    );
  }

  Future<void> resetWallet(CredentialsCubit credentialsCubit) async {
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
