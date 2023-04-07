import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/did/did.dart';
import 'package:altme/wallet/model/model.dart';
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

part 'credentials_helper_function.dart';

part 'credentials_cubit.g.dart';

part 'credentials_state.dart';

class CredentialsCubit extends Cubit<CredentialsState> {
  CredentialsCubit({
    required this.credentialsRepository,
    required this.secureStorageProvider,
    required this.credentialListCubit,
    required this.didCubit,
    required this.didKitProvider,
    required this.advanceSettingsCubit,
  }) : super(const CredentialsState());

  final CredentialsRepository credentialsRepository;
  final SecureStorageProvider secureStorageProvider;
  final CredentialListCubit credentialListCubit;
  final DIDCubit didCubit;
  final DIDKitProvider didKitProvider;
  final AdvanceSettingsCubit advanceSettingsCubit;

  final log = getLogger('CredentialsCubit');

  Future<void> initialize({required String ssiKey}) async {
    if (ssiKey.isNotEmpty) {
      return loadAllCredentials(ssiKey: ssiKey);
    }
  }

  Future<void> loadAllCredentials({required String ssiKey}) async {
    final log = getLogger('loadAllCredentials');
    final savedCredentials = await credentialsRepository.findAll(/* filters */);
    emit(
      state.copyWith(
        status: CredentialsStatus.populate,
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
        status: CredentialsStatus.delete,
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
        status: CredentialsStatus.update,
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
          status: CredentialsStatus.populate,
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

    if (credentialCategory == CredentialCategory.blockchainAccountsCards &&
        credentialListCubit.state.blockchainAccountsCredentials.isEmpty) {
      if (!advanceSettingsCubit.state.isBlockchainAccountsEnabled) {
        advanceSettingsCubit.toggleBlockchainAccountsRadio();
      }
    }

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
        status: CredentialsStatus.insert,
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

    final cardsToCheck = [
      CredentialSubjectType.over13,
      CredentialSubjectType.over15,
      CredentialSubjectType.over18,
      CredentialSubjectType.ageRange
    ];

    ///remove old card added by YOTI

    for (final card in cardsToCheck) {
      if (credentialSubjectModel.credentialSubjectType == card) {
        final List<CredentialModel> allCredentials =
            await credentialsRepository.findAll();
        for (final storedCredential in allCredentials) {
          final credentialSubjectModel =
              storedCredential.credentialPreview.credentialSubjectModel;
          if (credentialSubjectModel.credentialSubjectType == card) {
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

  Future<void> recoverWallet(List<CredentialModel> credentials) async {
    await credentialsRepository.deleteAll();
    for (final credential in credentials) {
      await credentialsRepository.insert(credential);
    }
    emit(state.copyWith(
        status: CredentialsStatus.init, credentials: credentials));
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
