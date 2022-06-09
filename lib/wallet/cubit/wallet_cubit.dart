import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:passbase_flutter/passbase_flutter.dart';
import 'package:secure_storage/secure_storage.dart';

part 'wallet_cubit.g.dart';
part 'wallet_state.dart';

class WalletCubit extends Cubit<WalletState> {
  WalletCubit({
    required this.repository,
    required this.secureStorageProvider,
    required this.profileCubit,
    required this.homeCubit,
    required this.credentialListCubit,
  }) : super(WalletState()) {
    initialize();
  }

  final CredentialsRepository repository;
  final SecureStorageProvider secureStorageProvider;
  final ProfileCubit profileCubit;
  final HomeCubit homeCubit;
  final CredentialListCubit credentialListCubit;

  Future initialize() async {
    final key = await secureStorageProvider.get(SecureStorageKeys.key);
    if (key != null) {
      if (key.isNotEmpty) {
        /// When app is initialized, set all credentials with active status to
        /// unknown status
        await repository.initializeRevocationStatus();
        await loadAllCredentialsFromRepository();
      }
    }
  }

  Future deleteById(CredentialModel credential) async {
    emit(state.loading());
    await repository.deleteById(credential.id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == credential.id);
    await credentialListCubit.deleteById(credential);
    emit(
      state.success(
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
          status: WalletStatus.idle,
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
      state.success(
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
      emit(state.success(status: WalletStatus.idle, credentials: credentials));
    }
  }

  Future insertCredential(CredentialModel credential) async {
    await repository.insert(credential);
    final credentials = List.of(state.credentials)..add(credential);
    await credentialListCubit.insertCredential(credential);
    emit(
      state.success(
        status: WalletStatus.insert,
        credentials: credentials,
        messageHandler: ResponseMessage(
          ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE,
        ),
      ),
    );
  }

  Future resetWallet() async {
    await secureStorageProvider.delete(SecureStorageKeys.key);
    await secureStorageProvider.delete(SecureStorageKeys.mnemonic);
    await secureStorageProvider.delete(SecureStorageKeys.data);
    await repository.deleteAll();
    await profileCubit.resetProfile();
    homeCubit.emitHasNoWallet();
    await credentialListCubit.clearCredentials();
    emit(state.success(status: WalletStatus.reset, credentials: []));
    emit(state.success(status: WalletStatus.init));
  }

  Future<void> recoverWallet(List<CredentialModel> credentials) async {
    await repository.deleteAll();
    for (final credential in credentials) {
      await repository.insert(credential);
    }
    homeCubit.emitHasNoWallet();
    emit(state.success(status: WalletStatus.init, credentials: credentials));
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
}
