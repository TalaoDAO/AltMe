import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/connection_bridge/connection_bridge.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/did/did.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'helper_function.dart';

part 'wallet_cubit.g.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required this.credentialsRepository,
    required this.connectedDappRepository,
    required this.secureStorageProvider,
    required this.profileCubit,
    required this.homeCubit,
    required this.credentialListCubit,
    required this.keyGenerator,
    required this.didCubit,
    required this.didKitProvider,
    required this.advanceSettingsCubit,
  }) : super(WalletState());

  final CredentialsRepository credentialsRepository;
  final ConnectedDappRepository connectedDappRepository;
  final SecureStorageProvider secureStorageProvider;
  final ProfileCubit profileCubit;
  final HomeCubit homeCubit;
  final CredentialListCubit credentialListCubit;
  final KeyGenerator keyGenerator;
  final DIDCubit didCubit;
  final DIDKitProvider didKitProvider;
  final AdvanceSettingsCubit advanceSettingsCubit;

  final log = getLogger('WalletCubit');

  Future<void> initialize({required String? ssiKey}) async {
    if (ssiKey != null) {
      if (ssiKey.isNotEmpty) {
        unawaited(loadAllCredentials(ssiKey: ssiKey));
      }
    }
  }

  Future<void> loadAllCredentials({required String ssiKey}) async {
    final log = getLogger('loadAllCredentials');
    final savedCredentials = await credentialsRepository.findAll(/* filters */);
    emit(
      state.copyWith(
        status: WalletStatus.populate,
        credentials: savedCredentials,
      ),
    );
    log.i('credentials loaded from repository - ${savedCredentials.length}');
    await addRequiredCredentials(ssiKey: ssiKey);
  }

  Future<void> addRequiredCredentials({required String ssiKey}) async {
    final log = getLogger('addRequiredCredentials');

    /// device info card
    final walletCredentialCards = await credentialListFromCredentialSubjectType(
      CredentialSubjectType.walletCredential,
    );
    if (walletCredentialCards.isEmpty) {
      final walletCredential = await generateWalletCredential(
        ssiKey: ssiKey,
        didKitProvider: didKitProvider,
        didCubit: didCubit,
      );
      if (walletCredential != null) {
        log.i('CredentialSubjectType.walletCredential added');
        await insertCredential(
          credential: walletCredential,
          showMessage: false,
        );
      }
    }
  }

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
        await addRequiredCredentials(ssiKey: ssiKey);
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
        /// only creating tezos at start
        updatedCryptoAccount = await createBlockchainAccount(
          accountName: accountName,
          mnemonicOrKey: mnemonicOrKey,
          isImported: isImported,
          isSecretKey: isSecretKey,
          blockchainType: BlockchainType.tezos,
          totalAccountsYet: accountsCount,
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

    /// If we are not using crypto in the wallet we are not generating
    /// AssociatedAddress credentials.
    final credential = Parameters.hasCryptoCallToAction
        ? await generateAssociatedWalletCredential(
            cryptoAccountData: cryptoAccountData,
            didCubit: didCubit,
            didKitProvider: didKitProvider,
            blockchainType: blockchainType,
            keyGenerator: keyGenerator,
          )
        : null;

    if (credential != null) {
      await insertCredential(
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

    /// get id of current AssociatedAddres credential of this account
    final oldCredentialList = List<CredentialModel>.from(state.credentials);

    final filteredCredentialList = getCredentialsFromFilterList(
      [
        Field(path: [r'$..type'], filter: blockchainType.filter),
        Field(
          path: [r'$..associatedAddress'],
          filter: Filter('String', cryptoAccountData.walletAddress),
        ),
      ],
      oldCredentialList,
    );

    /// update or create AssociatedAddres credential with new name
    if (filteredCredentialList.isNotEmpty) {
      final credential = await generateAssociatedWalletCredential(
        cryptoAccountData: cryptoAccountData,
        oldId: filteredCredentialList.first.id,
        didCubit: didCubit,
        didKitProvider: didKitProvider,
        blockchainType: blockchainType,
        keyGenerator: keyGenerator,
      );
      if (credential != null) {
        await updateCredential(credential: credential);
      }
    } else {
      final credential = await generateAssociatedWalletCredential(
        cryptoAccountData: cryptoAccountData,
        didCubit: didCubit,
        didKitProvider: didKitProvider,
        blockchainType: blockchainType,
        keyGenerator: keyGenerator,
      );
      if (credential != null) {
        await insertCredential(credential: credential);
      }
    }

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

  Future<void> deleteById({
    required CredentialModel credential,
    bool showMessage = true,
  }) async {
    emit(state.loading());
    await credentialsRepository.deleteById(credential.id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == credential.id);
    await credentialListCubit.deleteById(credential);
    emit(
      state.copyWith(
        status: WalletStatus.delete,
        credentials: credentials,
        messageHandler: showMessage
            ? ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE,
              )
            : null,
      ),
    );
  }

  Future<void> updateCredential({
    required CredentialModel credential,
    bool showMessage = true,
  }) async {
    await credentialsRepository.update(credential);
    final index =
        state.credentials.indexWhere((element) => element.id == credential.id);

    final credentials = List.of(state.credentials);
    credentials[index] = credential;

    await credentialListCubit.updateCredential(credential);
    emit(
      state.copyWith(
        status: WalletStatus.update,
        credentials: credentials,
        messageHandler: showMessage
            ? ResponseMessage(
                ResponseString
                    .RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE,
              )
            : null,
      ),
    );
  }

  Future<void> handleUnknownRevocationStatus(CredentialModel credential) async {
    await credentialsRepository.update(credential);
    final index =
        state.credentials.indexWhere((element) => element.id == credential.id);
    if (index != -1) {
      final credentials = List.of(state.credentials)
        ..removeWhere((element) => element.id == credential.id)
        ..insert(index, credential);
      emit(
        state.copyWith(
          status: WalletStatus.populate,
          credentials: credentials,
        ),
      );
    }
  }

  Future<void> insertCredential({
    required CredentialModel credential,
    bool showMessage = true,
  }) async {
    await replaceCredential(credential: credential);

    /// if same email credential is present
    await credentialsRepository.insert(credential);
    final credentials = List.of(state.credentials)..add(credential);

    final CredentialCategory credentialCategory =
        credential.credentialPreview.credentialSubjectModel.credentialCategory;

    if (credentialCategory == CredentialCategory.gamingCards &&
        credentialListCubit.state.gamingCredentials.isEmpty) {
      if (!advanceSettingsCubit.state.isGamingEnabled) {
        advanceSettingsCubit.toggleGamingRadio();
      }
    }

    if (credentialCategory == CredentialCategory.communityCards &&
        credentialListCubit.state.communityCredentials.isEmpty) {
      if (!advanceSettingsCubit.state.isCommunityEnabled) {
        advanceSettingsCubit.toggleCommunityRadio();
      }
    }

    if (credentialCategory == CredentialCategory.identityCards &&
        credentialListCubit.state.identityCredentials.isEmpty) {
      if (!advanceSettingsCubit.state.isIdentityEnabled) {
        advanceSettingsCubit.toggleIdentityRadio();
      }
    }

    if (credentialCategory == CredentialCategory.passCards &&
        credentialListCubit.state.passCredentials.isEmpty) {
      if (!advanceSettingsCubit.state.isPassEnabled) {
        advanceSettingsCubit.togglePassRadio();
      }
    }

    // if (credentialCategory == CredentialCategory.blockchainAccountsCards &&
    //     credentialListCubit.state.blockchainAccountsCredentials.isEmpty) {
    //   if (!advanceSettingsCubit.state.isBlockchainAccountsEnabled) {
    //     advanceSettingsCubit.toggleBlockchainAccountsRadio();
    //   }
    // }

    if (credentialCategory == CredentialCategory.educationCards &&
        credentialListCubit.state.educationCredentials.isEmpty) {
      if (!advanceSettingsCubit.state.isEducationEnabled) {
        advanceSettingsCubit.toggleEducationRadio();
      }
    }

    if (credentialCategory == CredentialCategory.othersCards &&
        credentialListCubit.state.othersCredentials.isEmpty) {
      if (!advanceSettingsCubit.state.isOtherEnabled) {
        advanceSettingsCubit.toggleOtherRadio();
      }
    }

    await credentialListCubit.insertCredential(
      credential: credential,
    );

    emit(
      state.copyWith(
        status: WalletStatus.insert,
        credentials: credentials,
        messageHandler: showMessage
            ? ResponseMessage(
                ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE,
              )
            : null,
      ),
    );
  }

  Future<void> replaceCredential({
    required CredentialModel credential,
    bool showMessage = true,
  }) async {
    final credentialSubjectModel =
        credential.credentialPreview.credentialSubjectModel;

    /// Old EmailPass needs to be removed if currently adding new EmailPass
    /// with same email address
    if (credentialSubjectModel.credentialSubjectType ==
        CredentialSubjectType.emailPass) {
      final String? email = (credentialSubjectModel as EmailPassModel).email;

      final List<CredentialModel> allCredentials =
          await credentialsRepository.findAll();

      if (email != null) {
        for (final storedCredential in allCredentials) {
          final iteratedCredentialSubjectModel =
              storedCredential.credentialPreview.credentialSubjectModel;

          if (iteratedCredentialSubjectModel.credentialSubjectType ==
              CredentialSubjectType.emailPass) {
            if (email ==
                (iteratedCredentialSubjectModel as EmailPassModel).email) {
              await deleteById(
                credential: storedCredential,
                showMessage: false,
              );
              break;
            }
          }
        }
      }
    }

    ///remove old card added by YOTI
    if (credentialSubjectModel.credentialSubjectType ==
        CredentialSubjectType.over13) {
      final List<CredentialModel> allCredentials =
          await credentialsRepository.findAll();
      for (final storedCredential in allCredentials) {
        final credentialSubjectModel =
            storedCredential.credentialPreview.credentialSubjectModel;
        if (credentialSubjectModel.credentialSubjectType ==
            CredentialSubjectType.over13) {
          await deleteById(
            credential: storedCredential,
            showMessage: false,
          );
          break;
        }
      }
    }

    ///remove old card added by YOTI
    if (credentialSubjectModel.credentialSubjectType ==
        CredentialSubjectType.over18) {
      final List<CredentialModel> allCredentials =
          await credentialsRepository.findAll();
      for (final storedCredential in allCredentials) {
        final credentialSubjectModel =
            storedCredential.credentialPreview.credentialSubjectModel;
        if (credentialSubjectModel.credentialSubjectType ==
            CredentialSubjectType.over18) {
          await deleteById(
            credential: storedCredential,
            showMessage: false,
          );
          break;
        }
      }
    }

    ///remove old card added by YOTI
    if (credentialSubjectModel.credentialSubjectType ==
        CredentialSubjectType.ageRange) {
      final List<CredentialModel> allCredentials =
          await credentialsRepository.findAll();
      for (final storedCredential in allCredentials) {
        final credentialSubjectModel =
            storedCredential.credentialPreview.credentialSubjectModel;
        if (credentialSubjectModel.credentialSubjectType ==
            CredentialSubjectType.ageRange) {
          await deleteById(
            credential: storedCredential,
            showMessage: false,
          );
          break;
        }
      }
    }
  }

  Future<void> resetWallet({
    List<String>? exceptKeys = const [SecureStorageKeys.version],
  }) async {
    if (exceptKeys == null || exceptKeys.isEmpty) {
      await secureStorageProvider.deleteAll();
    } else {
      final keyValues = await secureStorageProvider.getAllValues();
      final keys = keyValues.keys.toList();
      for (final key in keys) {
        if (!exceptKeys.contains(key)) {
          await secureStorageProvider.delete(key);
        }
      }
    }

    // await credentialsRepository.deleteAll();
    // await profileCubit.resetProfile();
    // await connectedDappRepository.deleteAll();

    /// clear app states
    homeCubit.emitHasNoWallet();
    await credentialListCubit.clearHomeCredentials();
    emit(
      state.copyWith(
        status: WalletStatus.reset,
        credentials: [],
        cryptoAccount: CryptoAccount(data: const []),
        currentCryptoIndex: 0,
      ),
    );
    emit(state.copyWith(status: WalletStatus.init));
  }

  Future<void> recoverWallet(List<CredentialModel> credentials) async {
    await credentialsRepository.deleteAll();
    for (final credential in credentials) {
      await credentialsRepository.insert(credential);
    }
    emit(state.copyWith(status: WalletStatus.init, credentials: credentials));
  }

  Future<List<CredentialModel>> credentialListFromCredentialSubjectType(
    CredentialSubjectType credentialSubjectType,
  ) async {
    if (state.credentials.isEmpty) return [];
    final List<CredentialModel> resultList = [];
    for (final credential in state.credentials) {
      final credentialSubjectModel =
          credential.credentialPreview.credentialSubjectModel;
      if (credentialSubjectModel.credentialSubjectType ==
          credentialSubjectType) {
        resultList.add(credential);
      }
    }
    return resultList;
  }
}
