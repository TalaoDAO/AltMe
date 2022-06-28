import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/did/did.dart';
import 'package:altme/home/home.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:key_generator/key_generator.dart';
import 'package:logging/logging.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
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
    required String mnemonic,
    Function(CryptoAccount cryptoAccount)? onComplete,
  }) async {
    int index = 0;

    final String? derivePathIndex =
        await secureStorageProvider.get(SecureStorageKeys.derivePathIndex);

    if (derivePathIndex != null && derivePathIndex.isNotEmpty) {
      index = int.parse(derivePathIndex) + 1;
    }

    await secureStorageProvider.set(
      SecureStorageKeys.derivePathIndex,
      index.toString(),
    );

    final cryptoKey = await keyGenerator.jwkFromMnemonic(
      mnemonic: mnemonic,
      accountType: AccountType.crypto,
      derivePathIndex: index,
    );

    final cryptoSecretKey = await keyGenerator.secretKeyFromMnemonic(
      mnemonic: mnemonic,
      accountType: AccountType.crypto,
      derivePathIndex: index,
    );

    final String cryptoWalletAddress =
        await keyGenerator.tz1AddressFromSecretKey(
      secretKey: cryptoSecretKey,
    );

    final CryptoAccountData cryptoAccountData = CryptoAccountData(
      mnemonics: mnemonic,
      key: cryptoKey,
      walletAddress: cryptoWalletAddress,
      secretKey: cryptoSecretKey,
    );

    final cryptoAccounts = List.of(state.cryptoAccount.data)
      ..add(cryptoAccountData);

    final CryptoAccount cryptoAccount = CryptoAccount(data: cryptoAccounts);
    final String cryptoAccountString = jsonEncode(cryptoAccount);
    await secureStorageProvider.set(
      SecureStorageKeys.cryptoAccount,
      cryptoAccountString,
    );

    if (onComplete != null) {
      onComplete.call(cryptoAccount);
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
          (element) => element.walletAddress == cryptoAccountData.walletAddress)
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

    emitCryptoAccount(cryptoAccount);

    final credential = await generateAssociatedWalletCredential(
      accountName: 'account ${cryptoAccounts.length}',
      walletAddress: cryptoAccountData.walletAddress,
    );
    if (credential != null) {
      await insertCredential(credential);
    }
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

  /// Give user metadata to KYC. Currently we are just sending user DID.
  bool setKYCMetadata() {
    final selectedCredentials = <CredentialModel>[];
    for (final credentialModel in state.credentials) {
      final credentialTypeList = credentialModel.credentialPreview.type;

      ///credential and issuer provided in claims
      if (credentialTypeList.contains('EmailPass')) {
        final credentialSubjectModel = credentialModel
            .credentialPreview.credentialSubjectModel as EmailPassModel;
        if (credentialSubjectModel.passbaseMetadata != '') {
          selectedCredentials.add(credentialModel);
        }
      }
    }
    if (selectedCredentials.isNotEmpty) {
      final firstEmailPassCredentialSubject =
          selectedCredentials.first.credentialPreview.credentialSubjectModel;
      if (firstEmailPassCredentialSubject is EmailPassModel) {
        /// Give user email from first EmailPass to KYC. When KYC is successful
        /// this email is used to send the over18 credential link to user.
        PassbaseSDK.prefillUserEmail = firstEmailPassCredentialSubject.email;
        PassbaseSDK.metaData = firstEmailPassCredentialSubject.passbaseMetadata;
        return true;
      }
    }
    return false;
  }

  ///helper function to generate TezosAssociatedAddressCredential
  Future<CredentialModel?> generateAssociatedWalletCredential({
    required String accountName,
    required String walletAddress,
  }) async {
    final log = Logger('altme/associated_wallet_credential/create');
    try {
      final secretKey = await secureStorageProvider.get(
        SecureStorageKeys.ssiKey,
      );

      final did = didCubit.state.did!;

      final options = {
        'proofPurpose': 'assertionMethod',
        'verificationMethod': didCubit.state.verificationMethod
      };
      final verifyOptions = {'proofPurpose': 'assertionMethod'};
      final id = 'urn:uuid:${const Uuid().v4()}';
      final formatter = DateFormat('yyyy-MM-ddTHH:mm:ss');
      final issuanceDate = '${formatter.format(DateTime.now())}Z';

      final tezosAssociatedAddressModel = TezosAssociatedAddressModel(
        id: did,
        accountName: accountName,
        associatedAddress: walletAddress,
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
        secretKey!,
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
          return _createCredential(vc);
        }
      } else {
        return _createCredential(vc);
      }
    } catch (e, s) {
      log.severe('something went wrong e: $e, stackTrace: $s', e, s);
      return null;
    }
  }

  Future<CredentialModel> _createCredential(String vc) async {
    final jsonCredential = jsonDecode(vc) as Map<String, dynamic>;
    final id = 'urn:uuid:${const Uuid().v4()}';
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
