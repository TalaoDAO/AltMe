import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/dashboard/profile/models/display_external_issuer.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc/bloc.dart';
import 'package:credential_manifest/credential_manifest.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:key_generator/key_generator.dart';
import 'package:oidc4vc/oidc4vc.dart';

import 'package:secure_storage/secure_storage.dart';
import 'package:uuid/uuid.dart';

part 'credentials_helper_function.dart';

part 'credentials_cubit.g.dart';

part 'credentials_state.dart';

class CredentialsCubit extends Cubit<CredentialsState> {
  CredentialsCubit({
    required this.credentialsRepository,
    required this.secureStorageProvider,
    required this.didKitProvider,
    required this.advanceSettingsCubit,
    required this.keyGenerator,
    required this.jwtDecode,
    required this.profileCubit,
    required this.oidc4vc,
    required this.walletCubit,
  }) : super(const CredentialsState());

  final CredentialsRepository credentialsRepository;
  final SecureStorageProvider secureStorageProvider;

  final DIDKitProvider didKitProvider;
  final KeyGenerator keyGenerator;
  final AdvanceSettingsCubit advanceSettingsCubit;
  final JWTDecode jwtDecode;
  final ProfileCubit profileCubit;
  final OIDC4VC oidc4vc;
  final WalletCubit walletCubit;

  final log = getLogger('CredentialsCubit');

  Future<void> loadAllCredentials({
    required BlockchainType blockchainType,
  }) async {
    final log = getLogger('loadAllCredentials');
    final String? ssiKey =
        await secureStorageProvider.get(SecureStorageKeys.ssiKey);
    if (ssiKey == null || ssiKey.isEmpty) {
      log.i('can not load all credentials beacuse there is no ssi key');
      return;
    }

    emit(state.copyWith(status: CredentialsStatus.loading));
    final savedCredentials = await credentialsRepository.findAll(/* filters */);
    final dummies = _getAvalaibleDummyCredentials(
      credentials: savedCredentials,
      blockchainType: blockchainType,
    );

    final List<CredentialModel> updatedCredentials = <CredentialModel>[];

    /// manually categorizing default credential
    for (final credential in savedCredentials) {
      if (credential.isDefaultCredential &&
          credential.isVerifiableDiplomaType) {
        final updatedCredential = credential.copyWith(
          credentialPreview: credential.credentialPreview.copyWith(
            credentialSubjectModel:
                credential.credentialPreview.credentialSubjectModel.copyWith(
              credentialCategory: CredentialCategory.educationCards,
            ),
          ),
        );
        updatedCredentials.add(updatedCredential);
      } else if (credential.isDefaultCredential && credential.isPolygonIdCard) {
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
  }

  Future<void> addWalletCredential({
    required BlockchainType? blockchainType,
  }) async {
    final log = getLogger('addRequiredCredentials');

    final walletType = profileCubit.state.model.walletType;

    if (walletType != WalletType.enterprise) {
      return;
    }

    final walletAttestationData = await secureStorageProvider
        .get(SecureStorageKeys.walletAttestationData);

    if (walletAttestationData == null) {
      return;
    }

    /// device info card
    final walletCredentialCards = await credentialListFromCredentialSubjectType(
      CredentialSubjectType.walletCredential,
    );

    final payload = jwtDecode.parseJwt(walletAttestationData);

    if (walletCredentialCards.isEmpty) {
      final id = 'urn:uuid:${const Uuid().v4()}';
      final walletCredential = CredentialModel(
        id: id,
        image: null,
        data: const <String, dynamic>{},
        shareLink: '',
        expirationDate: payload['exp'].toString(),
        credentialPreview: Credential(
          id,
          ['dummy2'],
          ['WalletCredential'],
          payload['iss'].toString(), // issuer
          payload['exp'].toString(),
          payload['iat'].toString(),
          [
            Proof.dummy(),
          ],
          WalletCredentialModel(
            id: id,
            type: 'WalletCredential',
            issuedBy: const Author(''),
            publicKey: payload['cnf']['jwk'].toString(),
            walletInstanceKey: payload['sub'].toString(),
          ),
          [Translation('en', '')],
          [Translation('en', '')],
          CredentialStatusField.emptyCredentialStatusField(),
          [Evidence.emptyEvidence()],
        ),
        activities: [Activity(acquisitionAt: DateTime.now())],
        jwt: walletAttestationData,
        format: 'jwt',
      );

      log.i('CredentialSubjectType.walletCredential added');
      await insertCredential(
        credential: walletCredential,
        showMessage: false,
        blockchainType: blockchainType,
      );
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
    required String id,
    required BlockchainType? blockchainType,
    bool showMessage = true,
  }) async {
    emit(state.loading());
    await credentialsRepository.deleteById(id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == id);
    final dummies = _getAvalaibleDummyCredentials(
      credentials: credentials,
      blockchainType: blockchainType,
    );
    emit(
      state.copyWith(
        status: CredentialsStatus.delete,
        credentials: credentials,
        dummyCredentials: dummies,
        messageHandler: showMessage
            ? ResponseMessage(
                message: ResponseString
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
                message: ResponseString
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
    required BlockchainType? blockchainType,
    bool showMessage = true,
    bool showStatus = true,
    bool isPendingCredential = false,
  }) async {
    late final List<CredentialModel> credentials;

    if (credential.isDefaultCredential && credential.isVerifiableDiplomaType) {
      final updatedCredential = credential.copyWith(
        credentialPreview: credential.credentialPreview.copyWith(
          credentialSubjectModel:
              credential.credentialPreview.credentialSubjectModel.copyWith(
            credentialCategory: CredentialCategory.educationCards,
          ),
        ),
      );
      if (!isPendingCredential) {
        await modifyCredential(
          credential: updatedCredential,
          blockchainType: blockchainType,
        );
      }
      await credentialsRepository.insert(updatedCredential);
      credentials = List.of(state.credentials)..add(updatedCredential);
    } else if (credential.isDefaultCredential && credential.isPolygonIdCard) {
      final updatedCredential = credential.copyWith(
        credentialPreview: credential.credentialPreview.copyWith(
          credentialSubjectModel:
              credential.credentialPreview.credentialSubjectModel.copyWith(
            credentialCategory: CredentialCategory.polygonidCards,
          ),
        ),
      );
      if (!isPendingCredential) {
        await modifyCredential(
          credential: updatedCredential,
          blockchainType: blockchainType,
        );
      }
      await credentialsRepository.insert(updatedCredential);
      credentials = List.of(state.credentials)..add(updatedCredential);
    } else {
      if (!isPendingCredential) {
        await modifyCredential(
          credential: credential,
          blockchainType: blockchainType,
        );
      }
      await credentialsRepository.insert(credential);
      credentials = List.of(state.credentials)..add(credential);
    }

    final CredentialCategory credentialCategory =
        credential.credentialPreview.credentialSubjectModel.credentialCategory;

    enableCredentialCategory(category: credentialCategory);

    final dummies = _getAvalaibleDummyCredentials(
      credentials: credentials,
      blockchainType: blockchainType,
    );

    emit(
      state.copyWith(
        status: showStatus ? CredentialsStatus.insert : CredentialsStatus.idle,
        credentials: credentials,
        dummyCredentials: dummies,
        messageHandler: showMessage
            ? ResponseMessage(
                message:
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

      case CredentialCategory.professionalCards:
        if (!advanceSettingsCubit.state.isProfessionalEnabled) {
          advanceSettingsCubit.toggleProfessionalRadio();
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
      case CredentialCategory.humanityProofCards:
      case CredentialCategory.socialMediaCards:
      case CredentialCategory.walletIntegrity:
      case CredentialCategory.polygonidCards:
      case CredentialCategory.pendingCards:
        break;
    }
  }

  Future<void> modifyCredential({
    required CredentialModel credential,
    bool showMessage = true,
    required BlockchainType? blockchainType,
  }) async {
    final credentialSubjectModel =
        credential.credentialPreview.credentialSubjectModel;

    final List<CredentialModel> allCredentials =
        await credentialsRepository.findAll();

    for (final storedCredential in allCredentials) {
      final iteratedCredentialSubjectModel =
          storedCredential.credentialPreview.credentialSubjectModel;
      final iteratedCredentialFormat = storedCredential.format;

      final isCredentialSubjectTypeMatched =
          credentialSubjectModel.credentialSubjectType ==
              iteratedCredentialSubjectModel.credentialSubjectType;

      final isFormatMatched = iteratedCredentialFormat == credential.format;

      final isCredentialMatched =
          isCredentialSubjectTypeMatched && isFormatMatched;

      if (isCredentialMatched) {
        // credential and format matches

        /// Old EmailPass needs to be removed if currently adding new EmailPass
        /// with same email address
        if (credentialSubjectModel.credentialSubjectType ==
            CredentialSubjectType.emailPass) {
          final String? oldEmail =
              (credentialSubjectModel as EmailPassModel).email;
          final newEmail =
              (iteratedCredentialSubjectModel as EmailPassModel).email;

          if (oldEmail != null && oldEmail == newEmail) {
            /// check if email is same

            await deleteById(
              id: storedCredential.id,
              showMessage: false,
              blockchainType: blockchainType,
            );
            break;
          } else {
            /// other cards
            if (credentialSubjectModel
                .credentialSubjectType.supportSingleOnly) {
              await deleteById(
                id: storedCredential.id,
                showMessage: false,
                blockchainType: blockchainType,
              );
              break;
            } else {
              // don not remove if support multiple
            }
          }
        } else {
          /// other cards
          if (credentialSubjectModel.credentialSubjectType.supportSingleOnly) {
            if (!credentialSubjectModel
                .credentialSubjectType.isBlockchainAccount) {
              await deleteById(
                id: storedCredential.id,
                showMessage: false,
                blockchainType: blockchainType,
              );
            }

            break;
          } else {
            // don not remove if support multiple
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

  Future<void> insertAssociatedWalletCredential({
    required CryptoAccountData cryptoAccountData,
  }) async {
    final supportAssociatedCredential =
        supportCryptoCredential(profileCubit.state.model);

    if (!supportAssociatedCredential) {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description':
              'The crypto associated credential is not supported.',
        },
      );
    }

    final didKeyType = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid;

    final privateKey = await getPrivateKey(
      didKeyType: didKeyType,
      profileCubit: profileCubit,
    );

    final (did, _) = await getDidAndKid(
      didKeyType: didKeyType,
      privateKey: privateKey,
      profileCubit: profileCubit,
    );

    final private = jsonDecode(privateKey) as Map<String, dynamic>;

    final credential = await generateAssociatedWalletCredential(
      cryptoAccountData: cryptoAccountData,
      didKitProvider: didKitProvider,
      blockchainType: cryptoAccountData.blockchainType,
      keyGenerator: keyGenerator,
      did: did,
      customOidc4vcProfile: profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile,
      oidc4vc: oidc4vc,
      privateKey: private,
    );

    if (credential != null) {
      await insertCredential(
        credential: credential,
        blockchainType: cryptoAccountData.blockchainType,
      );
    }
  }

  Future<void> updateAssociatedWalletCredential({
    required BlockchainType blockchainType,
    required CryptoAccountData cryptoAccountData,
  }) async {
    /// get id of current AssociatedAddres credential of this account
    final oldCredentialList = List<CredentialModel>.from(state.credentials);

    // need to update code
    final filteredCredentialList = getCredentialsFromFilterList(
      filterList: [
        Field(path: [r'$..type'], filter: blockchainType.filter),
        Field(
          path: [r'$..associatedAddress'],
          filter: Filter(
            type: 'String',
            pattern: cryptoAccountData.walletAddress,
          ),
        ),
      ],
      credentialList: oldCredentialList,
    );

    /// update AssociatedAddres credential with new name
    if (filteredCredentialList.isNotEmpty) {
      //find old id of the credential
      final oldCredential = oldCredentialList.where((CredentialModel element) {
        final credentialSubjectModel =
            element.credentialPreview.credentialSubjectModel;

        String? walletAddress;

        if (credentialSubjectModel is EthereumAssociatedAddressModel) {
          walletAddress = credentialSubjectModel.associatedAddress;
        } else if (credentialSubjectModel is TezosAssociatedAddressModel) {
          walletAddress = credentialSubjectModel.associatedAddress;
        } else if (credentialSubjectModel is FantomAssociatedAddressModel) {
          walletAddress = credentialSubjectModel.associatedAddress;
        } else if (credentialSubjectModel is BinanceAssociatedAddressModel) {
          walletAddress = credentialSubjectModel.associatedAddress;
        } else if (credentialSubjectModel is PolygonAssociatedAddressModel) {
          walletAddress = credentialSubjectModel.associatedAddress;
        } else {
          return false;
        }

        if (walletAddress != null &&
            walletAddress == cryptoAccountData.walletAddress) {
          return true;
        }

        return false;
      }).first;

      final did = oldCredential.credentialPreview.credentialSubjectModel.id;

      if (did == null) {
        throw ResponseMessage(
          data: {
            'error': 'invalid_request',
            'error_description': 'DID is required.',
          },
        );
      }

      final didKeyType = profileCubit.state.model.profileSetting
          .selfSovereignIdentityOptions.customOidc4vcProfile.defaultDid;

      final privateKey = await getPrivateKey(
        profileCubit: profileCubit,
        didKeyType: didKeyType,
      );

      final private = jsonDecode(privateKey) as Map<String, dynamic>;

      final credential = await generateAssociatedWalletCredential(
        cryptoAccountData: cryptoAccountData,
        didKitProvider: didKitProvider,
        blockchainType: blockchainType,
        keyGenerator: keyGenerator,
        oldId: oldCredential.id,
        did: oldCredential.credentialPreview.credentialSubjectModel.id!,
        customOidc4vcProfile: profileCubit.state.model.profileSetting
            .selfSovereignIdentityOptions.customOidc4vcProfile,
        oidc4vc: oidc4vc,
        privateKey: private,
      );

      if (credential != null) {
        await updateCredential(credential: credential);
      }
    }
  }

  ///get dummy cards
  Map<CredentialCategory, List<DiscoverDummyCredential>>
      _getAvalaibleDummyCredentials({
    required List<CredentialModel> credentials,
    required BlockchainType? blockchainType,
  }) {
    final dummies = <CredentialCategory, List<DiscoverDummyCredential>>{};
    // entreprise user may have options to display some dummies (true/false)

    final profileModel = profileCubit.state.model;
    final profileSetting = profileModel.profileSetting;
    final vcFormatType = profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.vcFormatType;

    final isDutchProfile = profileModel.profileType == ProfileType.dutch;

    final discoverCardsOptions = profileSetting.discoverCardsOptions;
    // entreprise user may have a list of external issuer
    final externalIssuers =
        profileSetting.discoverCardsOptions?.displayExternalIssuer;

    for (final CredentialCategory category in getCredentialCategorySorted) {
      final allSubjectTypeForCategory = <CredentialSubjectType>[];

      /// tezVoucher is available only on Android platform
      if (isIOS) {
        allSubjectTypeForCategory.remove(CredentialSubjectType.tezVoucher);
      }

      // remove cards in discover based on profile
      if (discoverCardsOptions != null) {
        // add cards in discover based on profile
        switch (category) {
          case CredentialCategory.identityCards:
            if (discoverCardsOptions.displayOver13 &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.over13)) {
              allSubjectTypeForCategory.add(CredentialSubjectType.over13);
            }
            if (discoverCardsOptions.displayOver15 &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.over15)) {
              allSubjectTypeForCategory.add(CredentialSubjectType.over15);
            }

            if (!allSubjectTypeForCategory
                .contains(CredentialSubjectType.over18)) {
              final displayOver18 = vcFormatType == VCFormatType.ldpVc &&
                  discoverCardsOptions.displayOver18;
              final displayOver18Jwt = vcFormatType == VCFormatType.jwtVcJson &&
                  discoverCardsOptions.displayOver18Jwt;

              if (isDutchProfile || displayOver18 || displayOver18Jwt) {
                allSubjectTypeForCategory.add(CredentialSubjectType.over18);
              }
            }

            if (discoverCardsOptions.displayOver21 &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.over21)) {
              allSubjectTypeForCategory.add(CredentialSubjectType.over21);
            }
            if (discoverCardsOptions.displayOver50 &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.over50)) {
              allSubjectTypeForCategory.add(CredentialSubjectType.over50);
            }
            if (discoverCardsOptions.displayOver65 &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.over65)) {
              allSubjectTypeForCategory.add(CredentialSubjectType.over65);
            }

            if (!allSubjectTypeForCategory
                .contains(CredentialSubjectType.verifiableIdCard)) {
              final displayVerifiableId = vcFormatType == VCFormatType.ldpVc &&
                  discoverCardsOptions.displayVerifiableId;
              final displayVerifiableIdJwt =
                  (vcFormatType == VCFormatType.jwtVc ||
                          vcFormatType == VCFormatType.jwtVcJson) &&
                      discoverCardsOptions.displayVerifiableIdJwt;
              final displayVerifiableIdSdJwt =
                  vcFormatType == VCFormatType.vcSdJWT &&
                      discoverCardsOptions.displayVerifiableIdSdJwt;

              if (displayVerifiableId ||
                  displayVerifiableIdJwt ||
                  displayVerifiableIdSdJwt) {
                allSubjectTypeForCategory
                    .add(CredentialSubjectType.verifiableIdCard);
              }
            }

            if (discoverCardsOptions.displayAgeRange &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.ageRange)) {
              allSubjectTypeForCategory.add(CredentialSubjectType.ageRange);
            }

            if (discoverCardsOptions.displayHumanity &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.livenessCard)) {
              allSubjectTypeForCategory.add(CredentialSubjectType.livenessCard);
            }

            if (!allSubjectTypeForCategory
                .contains(CredentialSubjectType.livenessCard)) {
              final displayHumanity = vcFormatType == VCFormatType.ldpVc &&
                  discoverCardsOptions.displayHumanity;
              final displayHumanityJwt =
                  vcFormatType == VCFormatType.jwtVcJson &&
                      discoverCardsOptions.displayHumanityJwt;

              if (displayHumanity || displayHumanityJwt) {
                allSubjectTypeForCategory
                    .add(CredentialSubjectType.livenessCard);
              }
            }

            if (discoverCardsOptions.displayGender &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.gender)) {
              allSubjectTypeForCategory.add(CredentialSubjectType.gender);
            }
          case CredentialCategory.advantagesCards:
            if (Parameters.showChainbornCard) {
              if (discoverCardsOptions.displayChainborn &&
                  !allSubjectTypeForCategory
                      .contains(CredentialSubjectType.chainbornMembership)) {
                allSubjectTypeForCategory.add(
                  CredentialSubjectType.chainbornMembership,
                );
              }
            }

            if (Parameters.showTezotopiaCard) {
              if (discoverCardsOptions.displayTezotopia &&
                  !allSubjectTypeForCategory
                      .contains(CredentialSubjectType.tezotopiaMembership)) {
                allSubjectTypeForCategory.add(
                  CredentialSubjectType.tezotopiaMembership,
                );
              }
            }

          case CredentialCategory.professionalCards:
            break;

          case CredentialCategory.contactInfoCredentials:
            if (!allSubjectTypeForCategory
                .contains(CredentialSubjectType.emailPass)) {
              final displayEmailPass = vcFormatType == VCFormatType.ldpVc &&
                  discoverCardsOptions.displayEmailPass;
              final displayEmailPassJwt =
                  vcFormatType == VCFormatType.jwtVcJson &&
                      discoverCardsOptions.displayEmailPassJwt;

              if (displayEmailPass || displayEmailPassJwt) {
                allSubjectTypeForCategory.add(CredentialSubjectType.emailPass);
              }
            }

            if (!allSubjectTypeForCategory
                .contains(CredentialSubjectType.phonePass)) {
              final displayPhonePass = vcFormatType == VCFormatType.ldpVc &&
                  discoverCardsOptions.displayPhonePass;
              final displayPhonePassJwt =
                  vcFormatType == VCFormatType.jwtVcJson &&
                      discoverCardsOptions.displayPhonePassJwt;

              if (displayPhonePass || displayPhonePassJwt) {
                allSubjectTypeForCategory.add(CredentialSubjectType.phonePass);
              }
            }

          case CredentialCategory.educationCards:
            break;
          case CredentialCategory.financeCards:
            if (Parameters.supportDefiCompliance) {
              if (discoverCardsOptions.displayDefi &&
                  !allSubjectTypeForCategory
                      .contains(CredentialSubjectType.defiCompliance)) {
                allSubjectTypeForCategory
                    .add(CredentialSubjectType.defiCompliance);
              }
            }

          case CredentialCategory.humanityProofCards:
            break;
          case CredentialCategory.socialMediaCards:
            break;
          case CredentialCategory.walletIntegrity:
            break;
          case CredentialCategory.blockchainAccountsCards:
            if (Parameters.walletHandlesCrypto) {
              allSubjectTypeForCategory.addAll([
                CredentialSubjectType.tezosAssociatedWallet,
                CredentialSubjectType.ethereumAssociatedWallet,
                CredentialSubjectType.fantomAssociatedWallet,
                CredentialSubjectType.binanceAssociatedWallet,
                CredentialSubjectType.polygonAssociatedWallet,
              ]);
            }

          case CredentialCategory.othersCards:
            break;
          case CredentialCategory.polygonidCards:
            break;
          case CredentialCategory.pendingCards:
            break;
        }
      }

      final List<CredentialSubjectType> requiredDummySubjects = [];

      for (final subjectType in allSubjectTypeForCategory) {
        /// remove if format is not matching
        if (!subjectType.getVCFormatType.contains(vcFormatType)) {
          continue;
        }

        final isBlockchainAccount = subjectType.isBlockchainAccount;

        final supportAssociatedCredential =
            supportCryptoCredential(profileModel);

        /// remove if credential is blockchain account and
        /// profile do not support
        if (isBlockchainAccount && !supportAssociatedCredential) {
          continue;
        }

        final Map<BlockchainType, CredentialSubjectType>
            blockchainToSubjectType = {
          BlockchainType.tezos: CredentialSubjectType.tezosAssociatedWallet,
          BlockchainType.fantom: CredentialSubjectType.fantomAssociatedWallet,
          BlockchainType.binance: CredentialSubjectType.binanceAssociatedWallet,
          BlockchainType.ethereum:
              CredentialSubjectType.ethereumAssociatedWallet,
          BlockchainType.polygon: CredentialSubjectType.polygonAssociatedWallet,
        };

        final isCurrentBlockchainAccount =
            blockchainToSubjectType[blockchainType] == subjectType;

        final credentialsOfSameType = credentials
            .where(
              (element) =>
                  element.credentialPreview.credentialSubjectModel
                      .credentialSubjectType ==
                  subjectType,
            )
            .toList();

        if (credentialsOfSameType.isNotEmpty && subjectType.supportSingleOnly) {
          final availableWalletAddresses = <String>[];

          if (isBlockchainAccount && supportAssociatedCredential) {
            /// getting list of available wallet address of current
            /// blockchain account
            for (final credential in credentialsOfSameType) {
              final String? walletAddress = getWalletAddress(
                credential.credentialPreview.credentialSubjectModel,
              );

              if (walletAddress != null) {
                availableWalletAddresses.add(walletAddress);
              }
            }
          }

          /// credential available case
          for (final credential in credentialsOfSameType) {
            if (isBlockchainAccount && supportAssociatedCredential) {
              /// there can be multiple blockchain profiles
              ///
              /// each profiles should be allowed to add the respective cards
              ///
              /// so we have to check the current profile wallet address and
              /// compare with existing blockchain card to add in discover or
              /// not

              final String? currentWalletAddress =
                  walletCubit.state.currentAccount?.walletAddress;

              /// if current blockchain card is not available in list of
              /// credentails then add in the discover list
              /// else do not add if it is blockchain

              final isBlockChainCardAvailable = availableWalletAddresses
                  .contains(currentWalletAddress.toString());

              if (!isBlockChainCardAvailable && isCurrentBlockchainAccount) {
                /// if already added do not add
                if (!requiredDummySubjects.contains(subjectType)) {
                  requiredDummySubjects.add(subjectType);
                }
              }

              //get current wallet address
            } else {
              if (vcFormatType.vcValue == credential.getFormat) {
                /// do not add if format matched
                /// there can be same credentials with different format
              } else {
                requiredDummySubjects.add(subjectType);
              }
            }
          }
        } else {
          /// credential not available case

          if (isBlockchainAccount &&
              supportAssociatedCredential &&
              !isCurrentBlockchainAccount) {
            /// do not add if current blockchain acccount does not match
          } else {
            requiredDummySubjects.add(subjectType);
          }
        }
      }

      /// Generate list of external issuer from the profile
      dummies[category] =
          getDummiesFromExternalIssuerList(category, externalIssuers ?? []);

      /// add dummies from the category
      dummies[category]?.addAll(
        requiredDummySubjects
            .map((item) => item.dummyCredential(profileSetting))
            .toList(),
      );
    }

    return dummies;
  }
}

List<DiscoverDummyCredential> getDummiesFromExternalIssuerList(
  CredentialCategory category,
  List<DisplayExternalIssuer> externalIssuers,
) {
  // filtering the external issuer list
  final List<DisplayExternalIssuer> list = List.from(externalIssuers);
  list.removeWhere((element) => element.category != category.name);
  return list
      .map(
        (e) => DiscoverDummyCredential(
          credentialSubjectType: CredentialSubjectType.defaultCredential,
          link: e.redirect,
          image: e.background_url,
          display: Display(
            backgroundColor: e.background_color,
            backgroundImage: DisplayDetails(url: e.background_url),
            name: e.title,
            textColor: e.text_color,
            logo: DisplayDetails(url: e.logo),
            description: e.subtitle,
          ),
          whyGetThisCardExtern: e.why_get_this_card,
          expirationDateDetailsExtern: e.validity_period,
          howToGetItExtern: e.how_to_get_it,
          longDescriptionExtern: e.description,
          websiteLink: e.website,
        ),
      )
      .toList();
}
