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
    required this.didCubit,
    required this.didKitProvider,
    required this.advanceSettingsCubit,
    required this.keyGenerator,
  }) : super(const CredentialsState());

  final CredentialsRepository credentialsRepository;
  final SecureStorageProvider secureStorageProvider;
  final DIDCubit didCubit;
  final DIDKitProvider didKitProvider;
  final KeyGenerator keyGenerator;
  final AdvanceSettingsCubit advanceSettingsCubit;

  final log = getLogger('CredentialsCubit');

  Future<void> loadAllCredentials() async {
    final log = getLogger('loadAllCredentials');
    final String? ssiKey =
        await secureStorageProvider.get(SecureStorageKeys.ssiKey);
    if (ssiKey == null || ssiKey.isEmpty) {
      log.i('can not load all credentials beacuse there is no ssi key');
      return;
    }
    emit(state.copyWith(status: CredentialsStatus.loading));
    final savedCredentials = await credentialsRepository.findAll(/* filters */);
    final dummies = _getAvalaibleDummyCredentials(savedCredentials);

    final List<CredentialModel> updatedCredentials = <CredentialModel>[];

    /// manually categorizing default credential
    for (final credential in savedCredentials) {
      final isDefaultCredential = credential
              .credentialPreview.credentialSubjectModel.credentialSubjectType ==
          CredentialSubjectType.defaultCredential;

      if (isDefaultCredential && isVerifiableDiplomaType(credential)) {
        final updatedCredential = credential.copyWith(
          credentialPreview: credential.credentialPreview.copyWith(
            credentialSubjectModel:
                credential.credentialPreview.credentialSubjectModel.copyWith(
              credentialCategory: CredentialCategory.educationCards,
            ),
          ),
        );
        updatedCredentials.add(updatedCredential);
      } else if (isDefaultCredential && isPolygonIdCard(credential)) {
        final updatedCredential = credential.copyWith(
          credentialPreview: credential.credentialPreview.copyWith(
            credentialSubjectModel:
                credential.credentialPreview.credentialSubjectModel.copyWith(
              credentialCategory: CredentialCategory.polygonidCards,
            ),
          ),
        );

        updatedCredentials.add(updatedCredential);
      } else {
        updatedCredentials.add(credential);
      }
    }

    emit(
      state.copyWith(
        status: CredentialsStatus.populate,
        credentials: updatedCredentials,
        dummyCredentials: dummies,
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

  void reset() {
    emit(
      state.copyWith(
        status: CredentialsStatus.reset,
        credentials: [],
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
    final dummies = _getAvalaibleDummyCredentials(credentials);
    emit(
      state.copyWith(
        status: CredentialsStatus.delete,
        credentials: credentials,
        dummyCredentials: dummies,
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
    bool showStatus = true,
  }) async {
    late final List<CredentialModel> credentials;

    final isDefaultCredential = credential
            .credentialPreview.credentialSubjectModel.credentialSubjectType ==
        CredentialSubjectType.defaultCredential;

    if (isDefaultCredential && isVerifiableDiplomaType(credential)) {
      final updatedCredential = credential.copyWith(
        credentialPreview: credential.credentialPreview.copyWith(
          credentialSubjectModel:
              credential.credentialPreview.credentialSubjectModel.copyWith(
            credentialCategory: CredentialCategory.educationCards,
          ),
        ),
      );
      await replaceCredential(credential: updatedCredential);
      await credentialsRepository.insert(updatedCredential);
      credentials = List.of(state.credentials)..add(updatedCredential);
    } else if (isDefaultCredential && isPolygonIdCard(credential)) {
      final updatedCredential = credential.copyWith(
        credentialPreview: credential.credentialPreview.copyWith(
          credentialSubjectModel:
              credential.credentialPreview.credentialSubjectModel.copyWith(
            credentialCategory: CredentialCategory.polygonidCards,
          ),
        ),
      );
      await replaceCredential(credential: updatedCredential);
      await credentialsRepository.insert(updatedCredential);
      credentials = List.of(state.credentials)..add(updatedCredential);
    } else {
      await replaceCredential(credential: credential);
      await credentialsRepository.insert(credential);
      credentials = List.of(state.credentials)..add(credential);
    }

    final CredentialCategory credentialCategory =
        credential.credentialPreview.credentialSubjectModel.credentialCategory;

    enableCredentialCategory(category: credentialCategory);

    final dummies = _getAvalaibleDummyCredentials(credentials);

    emit(
      state.copyWith(
        status: showStatus ? CredentialsStatus.insert : CredentialsStatus.idle,
        credentials: credentials,
        dummyCredentials: dummies,
        messageHandler: showMessage
            ? ResponseMessage(
                ResponseString.RESPONSE_STRING_CREDENTIAL_ADDED_MESSAGE,
              )
            : null,
      ),
    );
  }

  void enableCredentialCategory({required CredentialCategory category}) {
    switch (category) {
      case CredentialCategory.advantagesCards:
        if (!advanceSettingsCubit.state.isGamingEnabled) {
          advanceSettingsCubit.toggleGamingRadio();
        }

      case CredentialCategory.contactInfoCredentials:
        if (!advanceSettingsCubit.state.isCommunityEnabled) {
          advanceSettingsCubit.toggleCommunityRadio();
        }

      case CredentialCategory.identityCards:
        if (!advanceSettingsCubit.state.isIdentityEnabled) {
          advanceSettingsCubit.toggleIdentityRadio();
        }

      case CredentialCategory.blockchainAccountsCards:
        if (!advanceSettingsCubit.state.isBlockchainAccountsEnabled) {
          advanceSettingsCubit.toggleBlockchainAccountsRadio();
        }

      case CredentialCategory.educationCards:
        if (!advanceSettingsCubit.state.isEducationEnabled) {
          advanceSettingsCubit.toggleEducationRadio();
        }

      case CredentialCategory.othersCards:
        if (!advanceSettingsCubit.state.isOtherEnabled) {
          advanceSettingsCubit.toggleOtherRadio();
        }

      case CredentialCategory.financeCards:
        // TODO(all): Handle this case.
        break;
      case CredentialCategory.humanityProofCards:
        // TODO(all): Handle this case.
        break;
      case CredentialCategory.socialMediaCards:
        // TODO(all): Handle this case.
        break;
      case CredentialCategory.walletIntegrity:
        // TODO(all): Handle this case.
        break;
      case CredentialCategory.polygonidCards:
        // TODO: Handle this case.
        break;
    }
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

  Future<void> recoverWallet({
    required List<CredentialModel> credentials,
    required bool isPolygonIdCredentials,
  }) async {
    if (!isPolygonIdCredentials) {
      await credentialsRepository.deleteAll();
    }
    for (final credential in credentials) {
      await credentialsRepository.insert(credential);
    }
    final updatedCredentials =
        await credentialsRepository.findAll(/* filters */);
    emit(
      state.copyWith(
        status: CredentialsStatus.init,
        credentials: updatedCredentials,
      ),
    );
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

  Future<void> insertOrUpdateAssociatedWalletCredential({
    required BlockchainType blockchainType,
    required CryptoAccountData cryptoAccountData,
  }) async {
    /// get id of current AssociatedAddres credential of this account
    final oldCredentialList = List<CredentialModel>.from(state.credentials);

    // need to update code
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
      final credential = await createAssociatedWalletCredential(
        blockchainType: blockchainType,
        cryptoAccountData: cryptoAccountData,
      );
      if (credential != null) {
        await updateCredential(credential: credential);
      }
    } else {
      final credential = await createAssociatedWalletCredential(
        blockchainType: blockchainType,
        cryptoAccountData: cryptoAccountData,
      );
      if (credential != null) {
        await insertCredential(credential: credential);
      }
    }
  }

  Future<CredentialModel?> createAssociatedWalletCredential({
    required BlockchainType blockchainType,
    required CryptoAccountData cryptoAccountData,
  }) async {
    return generateAssociatedWalletCredential(
      cryptoAccountData: cryptoAccountData,
      didCubit: didCubit,
      didKitProvider: didKitProvider,
      blockchainType: blockchainType,
      keyGenerator: keyGenerator,
    );
  }

  ///get dummy cards
  Map<CredentialCategory, List<DiscoverDummyCredential>>
      _getAvalaibleDummyCredentials(List<CredentialModel> credentials) {
    final dummies = <CredentialCategory, List<DiscoverDummyCredential>>{};
    for (final category in getCredentialCategorySorted) {
      final List<CredentialSubjectType> currentCredentialsSubjectTypeList =
          credentials
              .map(
                (e) => e.credentialPreview.credentialSubjectModel
                    .credentialSubjectType,
              )
              .toList();

      final allSubjectTypeForCategory = category.credSubjectsToShowInDiscover;

      /// tezVoucher and tezotopiaMembership is available only on Android
      /// platform
      if (isIOS) {
        allSubjectTypeForCategory.remove(CredentialSubjectType.tezVoucher);
        //allSubjectTypeForCategory.remove
        //(CredentialSubjectType.tezotopiaMembership);
      }

      final List<CredentialSubjectType> requiredDummySubjects = [];

      for (final subjectType in allSubjectTypeForCategory) {
        if (currentCredentialsSubjectTypeList.contains(subjectType)) {
          if (subjectType.weCanRemoveItIfCredentialExist) {
            continue;
          } else {
            requiredDummySubjects.add(subjectType);
          }
        } else {
          requiredDummySubjects.add(subjectType);
        }
      }

      dummies[category] = requiredDummySubjects
          .map(DiscoverDummyCredential.fromSubjectType)
          .toList();
    }
    return dummies;
  }
}
