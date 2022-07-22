import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/pick/credential_manifest/helpers/get_credentials_from_filter_list.dart';
import 'package:altme/did/did.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:logging/logging.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'wallet_cubit.g.dart';

part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required this.repository,
    required this.secureStorageProvider,
    required this.profileCubit,
    required this.homeCubit,
    required this.credentialListCubit,
    required this.keyGenerator,
    required this.didCubit,
    required this.didKitProvider,
  }) : super(WalletState()) {
    initialize();
  }

  final CredentialsRepository repository;
  final SecureStorageProvider secureStorageProvider;
  final ProfileCubit profileCubit;
  final HomeCubit homeCubit;
  final CredentialListCubit credentialListCubit;
  final KeyGenerator keyGenerator;
  final DIDCubit didCubit;
  final DIDKitProvider didKitProvider;

  Future initialize() async {
    final ssiKey = await secureStorageProvider.get(SecureStorageKeys.ssiKey);
    if (ssiKey != null) {
      if (ssiKey.isNotEmpty) {
        /// When app is initialized, set all credentials with active status to
        /// unknown status
        await repository.initializeRevocationStatus();
        await loadAllCredentialsFromRepository();
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
    Function(CryptoAccount cryptoAccount)? onComplete,
  }) async {
    int index = 0;

    if (!isImported) {
      final String? derivePathIndex =
          await secureStorageProvider.get(SecureStorageKeys.derivePathIndex);

      if (derivePathIndex != null && derivePathIndex.isNotEmpty) {
        index = int.parse(derivePathIndex) + 1;
      }
      await secureStorageProvider.set(
        SecureStorageKeys.derivePathIndex,
        index.toString(),
      );
    }

    late String cryptoKey;
    late String cryptoWalletAddress;
    late String cryptoSecretKey;

    final isSecretKey = mnemonicOrKey.startsWith('edsk') ||
        mnemonicOrKey.startsWith('spsk') ||
        mnemonicOrKey.startsWith('p2sk');

    cryptoKey = isSecretKey
        ? await keyGenerator.jwkFromSecretKey(
            secretKey: mnemonicOrKey,
          )
        : await keyGenerator.jwkFromMnemonic(
            mnemonic: mnemonicOrKey,
            accountType: AccountType.crypto,
            derivePathIndex: index,
          );

    cryptoSecretKey = isSecretKey
        ? mnemonicOrKey
        : await keyGenerator.secretKeyFromMnemonic(
            mnemonic: mnemonicOrKey,
            accountType: AccountType.crypto,
            derivePathIndex: index,
          );

    cryptoWalletAddress = isSecretKey
        ? await keyGenerator.tz1AddressFromSecretKey(
            secretKey: cryptoSecretKey,
          )
        : cryptoWalletAddress = await keyGenerator.tz1AddressFromSecretKey(
            secretKey: cryptoSecretKey,
          );

    String name = 'My Account ${index + 1}';

    if (accountName != null && accountName.isNotEmpty) {
      name = accountName;
    }
    final CryptoAccountData cryptoAccountData = CryptoAccountData(
      name: name,
      key: cryptoKey,
      walletAddress: cryptoWalletAddress,
      secretKey: cryptoSecretKey,
      isImported: isImported,
    );

    final cryptoAccounts = List.of(state.cryptoAccount.data)
      ..add(cryptoAccountData);

    final CryptoAccount cryptoAccount = CryptoAccount(data: cryptoAccounts);
    final String cryptoAccountString = jsonEncode(cryptoAccount);
    await secureStorageProvider.set(
      SecureStorageKeys.cryptoAccount,
      cryptoAccountString,
    );

    onComplete?.call(cryptoAccount);

    final credential = await generateAssociatedWalletCredential(
      accountName: cryptoAccountData.name,
      walletAddress: cryptoWalletAddress,
      cryptoKey: cryptoKey,
    );
    if (credential != null) {
      await insertCredential(credential);
    }

    emitCryptoAccount(cryptoAccount);
  }

  Future<void> editCryptoAccountName({
    required String newAccountName,
    required int index,
    Function(CryptoAccount cryptoAccount)? onComplete,
  }) async {
    final CryptoAccountData cryptoAccountData = state.cryptoAccount.data[index];
    cryptoAccountData.name = newAccountName;

    final cryptoAccounts = List.of(state.cryptoAccount.data)
      ..removeWhere(
        (element) => element.walletAddress == cryptoAccountData.walletAddress,
      )
      ..insert(index, cryptoAccountData);

    final CryptoAccount cryptoAccount = CryptoAccount(data: cryptoAccounts);
    final String cryptoAccountString = jsonEncode(cryptoAccount);
    await secureStorageProvider.set(
      SecureStorageKeys.cryptoAccount,
      cryptoAccountString,
    );

    if (onComplete != null) {
      onComplete.call(cryptoAccount);
    }

    /// get id of current AssociatedAddres credential of this account
    final oldCredentialList = getCredentialsFromFilterList(
      [
        Field([r'$..type'], Filter('String', 'TezosAssociatedAddress')),
        Field(
          [r'$..associatedAddress'],
          Filter('String', cryptoAccountData.walletAddress),
        ),
      ],
      state.credentials,
    );

    /// update or create AssociatedAddres credential with new name
    if (oldCredentialList.isNotEmpty) {
      final credential = await generateAssociatedWalletCredential(
        accountName: cryptoAccountData.name,
        walletAddress: cryptoAccountData.walletAddress,
        cryptoKey: cryptoAccountData.key,
        oldId: oldCredentialList.first.id,
      );
      if (credential != null) {
        await updateCredential(credential);
      }
    } else {
      final credential = await generateAssociatedWalletCredential(
        accountName: cryptoAccountData.name,
        walletAddress: cryptoAccountData.walletAddress,
        cryptoKey: cryptoAccountData.key,
      );
      if (credential != null) {
        await insertCredential(credential);
      }
    }

    emitCryptoAccount(cryptoAccount);
  }

  void emitCryptoAccount(CryptoAccount cryptoAccount) {
    emit(
      state.copyWith(
        status: WalletStatus.populate,
        cryptoAccount: cryptoAccount,
      ),
    );
  }

  Future deleteById(CredentialModel credential) async {
    emit(state.loading());
    await repository.deleteById(credential.id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == credential.id);
    await credentialListCubit.deleteById(credential);
    emit(
      state.copyWith(
        status: WalletStatus.delete,
        credentials: credentials,
        messageHandler: ResponseMessage(
          ResponseString
              .RESPONSE_STRING_CREDENTIAL_DETAIL_DELETE_SUCCESS_MESSAGE,
        ),
      ),
    );
  }

  Future loadAllCredentialsFromRepository() async {
    await repository.findAll(/* filters */).then((values) {
      emit(
        state.copyWith(
          status: WalletStatus.populate,
          credentials: values,
        ),
      );
    });
  }

  Future updateCredential(CredentialModel credential) async {
    await repository.update(credential);
    final index =
        state.credentials.indexWhere((element) => element.id == credential.id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == credential.id)
      ..insert(index, credential);
    await credentialListCubit.updateCredential(credential);
    emit(
      state.copyWith(
        status: WalletStatus.update,
        credentials: credentials,
        messageHandler: ResponseMessage(
          ResponseString.RESPONSE_STRING_CREDENTIAL_DETAIL_EDIT_SUCCESS_MESSAGE,
        ),
      ),
    );
  }

  Future handleUnknownRevocationStatus(CredentialModel credential) async {
    await repository.update(credential);
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

  Future insertCredential(CredentialModel credential) async {
    await repository.insert(credential);
    final credentials = List.of(state.credentials)..add(credential);
    await credentialListCubit.insertCredential(credential);
    emit(
      state.copyWith(
        status: WalletStatus.insert,
        credentials: credentials,
        messageHandler: ResponseMessage(
          ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE,
        ),
      ),
    );
  }

  Future resetWallet() async {
    /// ssi
    await secureStorageProvider.delete(SecureStorageKeys.ssiMnemonic);
    await secureStorageProvider.delete(SecureStorageKeys.ssiKey);

    /// did
    await secureStorageProvider.delete(SecureStorageKeys.did);
    await secureStorageProvider.delete(SecureStorageKeys.didMethod);
    await secureStorageProvider.delete(SecureStorageKeys.didMethodName);
    await secureStorageProvider.delete(SecureStorageKeys.verificationMethod);

    /// crypto
    await secureStorageProvider.delete(SecureStorageKeys.cryptoAccount);
    await secureStorageProvider.delete(SecureStorageKeys.derivePathIndex);
    await secureStorageProvider.delete(SecureStorageKeys.currentCryptoIndex);
    await secureStorageProvider.delete(SecureStorageKeys.data);

    /// credentials
    await repository.deleteAll();

    /// user data
    await profileCubit.resetProfile();

    /// clear app states
    homeCubit.emitHasNoWallet();
    await credentialListCubit.clearHomeCredentials();
    emit(
      state.copyWith(
        status: WalletStatus.reset,
        credentials: [],
        cryptoAccount: CryptoAccount(data: const []),
        currentCryptoIndex: null,
      ),
    );
    emit(state.copyWith(status: WalletStatus.init));
  }

  Future<void> recoverWallet(List<CredentialModel> credentials) async {
    await repository.deleteAll();
    for (final credential in credentials) {
      await repository.insert(credential);
    }
    homeCubit.emitHasNoWallet();
    emit(state.copyWith(status: WalletStatus.init, credentials: credentials));
  }

  ///helper function to generate TezosAssociatedAddressCredential
  Future<CredentialModel?> generateAssociatedWalletCredential({
    required String accountName,
    required String walletAddress,
    required String cryptoKey,
    String? oldId,
  }) async {
    final log = Logger('altme/associated_wallet_credential/create');
    try {
      const didMethod = AltMeStrings.defaultDIDMethod;
      final didSsi = didCubit.state.did!;
      final did = didKitProvider.keyToDID(didMethod, cryptoKey);

      final verificationMethod =
          await didKitProvider.keyToVerificationMethod(didMethod, cryptoKey);

      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': verificationMethod
      };
      final verifyOptions = {'proofPurpose': 'assertionMethod'};
      final id = 'urn:uuid:${const Uuid().v4()}';
      final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
      final issuanceDate = '${formatter.format(DateTime.now())}Z';

      final tezosAssociatedAddressModel = TezosAssociatedAddressModel(
        id: didSsi,
        accountName: accountName,
        associatedAddress: walletAddress,
        type: 'TezosAssociatedAddress',
      );

      final tezosAssociatedAddressCredential = TezosAssociatedAddressCredential(
        id: id,
        issuer: did,
        issuanceDate: issuanceDate,
        credentialSubjectModel: tezosAssociatedAddressModel,
      );
      final vc = await didKitProvider.issueCredential(
        jsonEncode(tezosAssociatedAddressCredential.toJson()),
        jsonEncode(options),
        cryptoKey,
      );
      final result =
          await didKitProvider.verifyCredential(vc, jsonEncode(verifyOptions));
      final jsonVerification = jsonDecode(result) as Map<String, dynamic>;

      if ((jsonVerification['warnings'] as List<dynamic>).isNotEmpty) {
        log.warning(
          'credential verification return warnings',
          jsonVerification['warnings'],
        );
      }

      if ((jsonVerification['errors'] as List<dynamic>).isNotEmpty) {
        log.severe('failed to verify credential', jsonVerification['errors']);
        if (jsonVerification['errors'][0] != 'No applicable proof') {
          throw ResponseMessage(
            ResponseString
                .RESPONSE_STRING_FAILED_TO_VERIFY_SELF_ISSUED_CREDENTIAL,
          );
        } else {
          return _createCredential(vc, oldId);
        }
      } else {
        return _createCredential(vc, oldId);
      }
    } catch (e, s) {
      log.severe('something went wrong e: $e, stackTrace: $s', e, s);
      return null;
    }
  }

  Future<CredentialModel> _createCredential(String vc, String? oldId) async {
    final jsonCredential = jsonDecode(vc) as Map<String, dynamic>;
    final id = oldId ?? 'urn:uuid:${const Uuid().v4()}';
    return CredentialModel(
      id: id,
      alias: '',
      image: 'image',
      data: jsonCredential,
      display: Display.emptyDisplay()..toJson(),
      shareLink: '',
      credentialPreview: Credential.fromJson(jsonCredential),
      revocationStatus: RevocationStatus.unknown,
    );
  }
}
