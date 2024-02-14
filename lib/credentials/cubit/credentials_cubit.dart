import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/activity/activity.dart';
import 'package:altme/dashboard/profile/models/display_external_issuer.dart';
import 'package:altme/wallet/model/model.dart';
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
  }) : super(const CredentialsState());

  final CredentialsRepository credentialsRepository;
  final SecureStorageProvider secureStorageProvider;

  final DIDKitProvider didKitProvider;
  final KeyGenerator keyGenerator;
  final AdvanceSettingsCubit advanceSettingsCubit;
  final JWTDecode jwtDecode;
  final ProfileCubit profileCubit;
  final OIDC4VC oidc4vc;

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

  Future<void> addWalletCredential() async {
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
    bool showMessage = true,
  }) async {
    emit(state.loading());
    await credentialsRepository.deleteById(id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == id);
    final dummies = _getAvalaibleDummyCredentials(credentials);
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
        await modifyCredential(credential: updatedCredential);
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
        await modifyCredential(credential: updatedCredential);
      }
      await credentialsRepository.insert(updatedCredential);
      credentials = List.of(state.credentials)..add(updatedCredential);
    } else {
      if (!isPendingCredential) await modifyCredential(credential: credential);
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
            /// check if email is same
            if (email ==
                (iteratedCredentialSubjectModel as EmailPassModel).email) {
              /// format should be same ldp_vc or jwt_vc
              if ((credential.jwt == null && storedCredential.jwt == null) ||
                  (credential.jwt != null && storedCredential.jwt != null)) {
                await deleteById(
                  id: storedCredential.id,
                  showMessage: false,
                );
                break;
              }
            }
          }
        }
      }
    }

    final cardsToCheck = [
      CredentialSubjectType.over13,
      CredentialSubjectType.over15,
      CredentialSubjectType.over18,
      CredentialSubjectType.over21,
      CredentialSubjectType.over50,
      CredentialSubjectType.over65,
      CredentialSubjectType.ageRange,
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
              id: storedCredential.id,
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

    /// update or create AssociatedAddres credential with new name
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

      // final credential = state.credentials.where((element) => element.);
      final credential = await createOrUpdateAssociatedWalletCredential(
        blockchainType: blockchainType,
        cryptoAccountData: cryptoAccountData,
        oldId: oldCredential.id,
      );
      if (credential != null) {
        await updateCredential(credential: credential);
      }
    } else {
      final credential = await createOrUpdateAssociatedWalletCredential(
        blockchainType: blockchainType,
        cryptoAccountData: cryptoAccountData,
      );
      if (credential != null) {
        await insertCredential(credential: credential);
      }
    }
  }

  Future<CredentialModel?> createOrUpdateAssociatedWalletCredential({
    required BlockchainType blockchainType,
    required CryptoAccountData cryptoAccountData,
    String? oldId,
  }) async {
    return generateAssociatedWalletCredential(
      cryptoAccountData: cryptoAccountData,
      didKitProvider: didKitProvider,
      blockchainType: blockchainType,
      keyGenerator: keyGenerator,
      oldId: oldId,
      oidc4vc: oidc4vc,
      profileCubit: profileCubit,
    );
  }

  ///get dummy cards
  Map<CredentialCategory, List<DiscoverDummyCredential>>
      _getAvalaibleDummyCredentials(List<CredentialModel> credentials) {
    final dummies = <CredentialCategory, List<DiscoverDummyCredential>>{};
    // entreprise user may have options to display some dummies (true/false)

    final profileSetting = profileCubit.state.model.profileSetting;
    final vcFormatType = profileCubit.state.model.profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.vcFormatType;

    final discoverCardsOptions = profileSetting.discoverCardsOptions;
    // entreprise user may have a list of external issuer
    final externalIssuers =
        profileSetting.discoverCardsOptions?.displayExternalIssuer;

    for (final CredentialCategory category in getCredentialCategorySorted) {
      final List<CredentialSubjectType> currentCredentialsSubjectTypeList =
          credentials
              .map(
                (e) => e.credentialPreview.credentialSubjectModel
                    .credentialSubjectType,
              )
              .toList();

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

              if (displayOver18 || displayOver18Jwt) {
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
                  (vcFormatType == VCFormatType.jwtVcJson ||
                          vcFormatType == VCFormatType.vcSdJWT) &&
                      discoverCardsOptions.displayVerifiableIdJwt;

              if (displayVerifiableId || displayVerifiableIdJwt) {
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
            if (discoverCardsOptions.displayChainborn &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.chainbornMembership)) {
              allSubjectTypeForCategory.add(
                CredentialSubjectType.chainbornMembership,
              );
            }
            if (discoverCardsOptions.displayTezotopia &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.tezotopiaMembership)) {
              allSubjectTypeForCategory.add(
                CredentialSubjectType.tezotopiaMembership,
              );
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

            if (discoverCardsOptions.displayPhonePass &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.phonePass)) {
              allSubjectTypeForCategory.add(
                CredentialSubjectType.phonePass,
              );
            }

          case CredentialCategory.educationCards:
            break;
          case CredentialCategory.financeCards:
            if (discoverCardsOptions.displayDefi &&
                !allSubjectTypeForCategory
                    .contains(CredentialSubjectType.defiCompliance)) {
              allSubjectTypeForCategory.add(
                CredentialSubjectType.defiCompliance,
              );
            }

          case CredentialCategory.humanityProofCards:
            break;
          case CredentialCategory.socialMediaCards:
            break;
          case CredentialCategory.walletIntegrity:
            break;
          case CredentialCategory.blockchainAccountsCards:
            break;
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

// Generate list of external issuer from the profile
      dummies[category] =
          getDummiesFromExternalIssuerList(category, externalIssuers ?? []);
// add dummies from the category
      dummies[category]?.addAll(
        requiredDummySubjects
            .map((item) => item.dummyCredential(vcFormatType))
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
          image: e.background_image,
          display: Display(
            backgroundColor: e.background_color,
            backgroundImage: DisplayDetails(url: e.background_image),
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
