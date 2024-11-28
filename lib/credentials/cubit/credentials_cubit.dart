import 'dart:async';
import 'dart:convert';

import 'package:altme/activity_log/activity_log.dart';
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
    required this.activityLogManager,
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
  final ActivityLogManager activityLogManager;

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
      final profileLinked = credential.profileLinkedId;
      final vcId = profileCubit.state.model.profileType.getVCId;
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

        if (profileLinked != null) {
          if (profileLinked == vcId) updatedCredentials.add(updatedCredential);
        } else {
          updatedCredentials.add(updatedCredential);
        }
      } else if (credential.isDefaultCredential && credential.isPolygonIdCard) {
        final updatedCredential = credential.copyWith(
          credentialPreview: credential.credentialPreview.copyWith(
            credentialSubjectModel:
                credential.credentialPreview.credentialSubjectModel.copyWith(
              credentialCategory: CredentialCategory.polygonidCards,
            ),
          ),
        );

        if (profileLinked != null) {
          if (profileLinked == vcId) updatedCredentials.add(updatedCredential);
        } else {
          updatedCredentials.add(updatedCredential);
        }
      } else {
        if (profileLinked != null) {
          if (profileLinked == vcId) updatedCredentials.add(credential);
        } else {
          updatedCredentials.add(credential);
        }
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
    required QRCodeScanCubit qrCodeScanCubit,
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
        profileLinkedId: ProfileType.enterprise.getVCId,
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

    final credential =
        state.credentials.where((element) => element.id == id).first;

    await credentialsRepository.deleteById(id);
    final credentials = List.of(state.credentials)
      ..removeWhere((element) => element.id == id);
    final dummies = _getAvalaibleDummyCredentials(
      credentials: credentials,
      blockchainType: blockchainType,
    );

    await activityLogManager.saveLog(
      LogData(
        type: LogType.deleteVC,
        vcInfo: VCInfo(id: credential.id, name: credential.getName),
      ),
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

    await activityLogManager.saveLog(
      LogData(
        type: LogType.addVC,
        vcInfo: VCInfo(id: credential.id, name: credential.getName),
      ),
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

    // if (qrCodeScanCubit.missingCredentialCompleter != null) {
    //   qrCodeScanCubit.missingCredentialCompleter!.complete(true);
    // }
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

      final isOnSameProfile = storedCredential.profileLinkedId ==
          profileCubit.state.model.profileType.getVCId;

      final isCredentialMatched =
          isCredentialSubjectTypeMatched && isFormatMatched && isOnSameProfile;

      if (isCredentialMatched) {
        // credential and format matches

        /// Old EmailPass needs to be removed if currently adding new EmailPass
        /// with same email address
        if (credentialSubjectModel.credentialSubjectType ==
            CredentialSubjectType.emailPass) {
          late String? oldEmail;
          late String? newEmail;
          if (credential.data['email'] != null) {
            oldEmail = credential.data['email'] as String;
          } else {
            oldEmail = (credentialSubjectModel as EmailPassModel).email;
          }
          if (storedCredential.data['email'] != null) {
            newEmail = storedCredential.data['email'] as String;
          } else {
            newEmail = (iteratedCredentialSubjectModel as EmailPassModel).email;
          }
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
        } else if (credentialSubjectModel
                .credentialSubjectType.isBlockchainAccount ||
            credentialSubjectModel.credentialSubjectType.supportSingleOnly) {
          await deleteById(
            id: storedCredential.id,
            showMessage: false,
            blockchainType: blockchainType,
          );
        }
      }
    }
  }

  Future<void> recoverWallet({
    required List<CredentialModel> credentials,
  }) async {
    await credentialsRepository.deleteAll();

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
      profileType: profileCubit.state.model.profileType,
    );

    if (credential != null) {
      await modifyCredential(
        credential: credential,
        blockchainType: cryptoAccountData.blockchainType,
      );

      await insertCredential(
        credential: credential,
        blockchainType: cryptoAccountData.blockchainType,
        showMessage: false,
      );
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
    final formatsSupported = profileModel
            .profileSetting
            .selfSovereignIdentityOptions
            .customOidc4vcProfile
            .formatsSupported ??
        [];

    final discoverCardsOptions = profileSetting.discoverCardsOptions;
    // entreprise user may have a list of external issuer
    final externalIssuers =
        profileSetting.discoverCardsOptions?.displayExternalIssuer;

    for (final CredentialCategory category in getCredentialCategorySorted) {
      final allCategoryVC = <CredInfo>[];

      /// tezVoucher is available only on Android platform
      if (isIOS) {
        allCategoryVC.removeWhere(
          (item) => item.credentialType == CredentialSubjectType.tezVoucher,
        );
      }

      // remove cards in discover based on profile
      if (discoverCardsOptions != null) {
        // add cards in discover based on profile

        switch (category) {
          case CredentialCategory.identityCards:

            /// over 13
            if (formatsSupported.contains(VCFormatType.ldpVc) &&
                discoverCardsOptions.displayOver13) {
              allCategoryVC.add(
                CredInfo(
                  credentialType: CredentialSubjectType.over13,
                  formatType: VCFormatType.ldpVc,
                ),
              );
            }

            /// Over 15
            if (formatsSupported.contains(VCFormatType.ldpVc) &&
                discoverCardsOptions.displayOver15) {
              allCategoryVC.add(
                CredInfo(
                  credentialType: CredentialSubjectType.over15,
                  formatType: VCFormatType.ldpVc,
                ),
              );
            }

            while (true) {
              /// Over 18
              if (formatsSupported.contains(VCFormatType.ldpVc) &&
                  discoverCardsOptions.displayOver18) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.over18,
                    formatType: VCFormatType.ldpVc,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.vcSdJWT) &&
                  discoverCardsOptions.displayOver18SdJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.over18,
                    formatType: VCFormatType.vcSdJWT,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.jwtVcJson) &&
                  discoverCardsOptions.displayOver18Jwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.over18,
                    formatType: VCFormatType.jwtVcJson,
                  ),
                );
                break;
              }
              break;
            }

            /// Over 21
            if (formatsSupported.contains(VCFormatType.ldpVc) &&
                discoverCardsOptions.displayOver21) {
              allCategoryVC.add(
                CredInfo(
                  credentialType: CredentialSubjectType.over21,
                  formatType: VCFormatType.ldpVc,
                ),
              );
            }

            /// Over 50
            if (formatsSupported.contains(VCFormatType.ldpVc) &&
                discoverCardsOptions.displayOver50) {
              allCategoryVC.add(
                CredInfo(
                  credentialType: CredentialSubjectType.over50,
                  formatType: VCFormatType.ldpVc,
                ),
              );
            }

            /// Over 65
            if (formatsSupported.contains(VCFormatType.ldpVc) &&
                discoverCardsOptions.displayOver65) {
              allCategoryVC.add(
                CredInfo(
                  credentialType: CredentialSubjectType.over65,
                  formatType: VCFormatType.ldpVc,
                ),
              );
            }

            /// verifiableIdCard
            while (true) {
              if (formatsSupported.contains(VCFormatType.vcSdJWT) &&
                  discoverCardsOptions.displayVerifiableIdSdJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.verifiableIdCard,
                    formatType: VCFormatType.vcSdJWT,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.ldpVc) &&
                  discoverCardsOptions.displayVerifiableId) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.verifiableIdCard,
                    formatType: VCFormatType.ldpVc,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.jwtVc) &&
                  discoverCardsOptions.displayVerifiableIdJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.verifiableIdCard,
                    formatType: VCFormatType.jwtVc,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.jwtVcJson) &&
                  discoverCardsOptions.displayVerifiableIdJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.verifiableIdCard,
                    formatType: VCFormatType.jwtVcJson,
                  ),
                );
                break;
              }
              break;
            }

            /// age range
            if (formatsSupported.contains(VCFormatType.ldpVc) &&
                discoverCardsOptions.displayAgeRange) {
              allCategoryVC.add(
                CredInfo(
                  credentialType: CredentialSubjectType.ageRange,
                  formatType: VCFormatType.ldpVc,
                ),
              );
            }

            /// livenessCard
            while (true) {
              if (formatsSupported.contains(VCFormatType.ldpVc) &&
                  discoverCardsOptions.displayHumanity) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.livenessCard,
                    formatType: VCFormatType.ldpVc,
                  ),
                );
                break;
              }

              if (formatsSupported.contains(VCFormatType.jwtVcJson) &&
                  discoverCardsOptions.displayHumanityJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.livenessCard,
                    formatType: VCFormatType.jwtVcJson,
                  ),
                );
                break;
              }
              break;
            }

            /// gender
            if (formatsSupported.contains(VCFormatType.ldpVc) &&
                discoverCardsOptions.displayGender) {
              allCategoryVC.add(
                CredInfo(
                  credentialType: CredentialSubjectType.gender,
                  formatType: VCFormatType.ldpVc,
                ),
              );
            }

          case CredentialCategory.advantagesCards:

            /// chainbornMembership
            if (Parameters.showChainbornCard) {
              if (formatsSupported.contains(VCFormatType.ldpVc) &&
                  discoverCardsOptions.displayChainborn) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.chainbornMembership,
                    formatType: VCFormatType.ldpVc,
                  ),
                );
              }
            }

            /// tezotopiaMembership
            if (Parameters.showTezotopiaCard) {
              if (formatsSupported.contains(VCFormatType.ldpVc) &&
                  discoverCardsOptions.displayTezotopia) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.tezotopiaMembership,
                    formatType: VCFormatType.ldpVc,
                  ),
                );
              }
            }

          case CredentialCategory.professionalCards:
            break;

          case CredentialCategory.contactInfoCredentials:

            /// Email Pass
            while (true) {
              if (formatsSupported.contains(VCFormatType.ldpVc) &&
                  discoverCardsOptions.displayEmailPass) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.emailPass,
                    formatType: VCFormatType.ldpVc,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.jwtVcJson) &&
                  discoverCardsOptions.displayEmailPassJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.emailPass,
                    formatType: VCFormatType.jwtVcJson,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.vcSdJWT) &&
                  discoverCardsOptions.displayEmailPassSdJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.emailPass,
                    formatType: VCFormatType.vcSdJWT,
                  ),
                );
                break;
              }
              break;
            }

            /// Phone Pass

            while (true) {
              if (formatsSupported.contains(VCFormatType.ldpVc) &&
                  discoverCardsOptions.displayPhonePass) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.phonePass,
                    formatType: VCFormatType.ldpVc,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.jwtVcJson) &&
                  discoverCardsOptions.displayPhonePassJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.phonePass,
                    formatType: VCFormatType.jwtVcJson,
                  ),
                );
                break;
              }
              if (formatsSupported.contains(VCFormatType.vcSdJWT) &&
                  discoverCardsOptions.displayPhonePassSdJwt) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.phonePass,
                    formatType: VCFormatType.vcSdJWT,
                  ),
                );
                break;
              }
              break;
            }

          case CredentialCategory.educationCards:
            break;
          case CredentialCategory.financeCards:
            if (Parameters.supportDefiCompliance) {
              if (formatsSupported.contains(VCFormatType.ldpVc) &&
                  discoverCardsOptions.displayDefi) {
                allCategoryVC.add(
                  CredInfo(
                    credentialType: CredentialSubjectType.defiCompliance,
                    formatType: VCFormatType.ldpVc,
                  ),
                );
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
              allCategoryVC.addAll([
                CredInfo(
                  credentialType: CredentialSubjectType.tezosAssociatedWallet,
                  formatType: VCFormatType.ldpVc,
                ),
                CredInfo(
                  credentialType:
                      CredentialSubjectType.ethereumAssociatedWallet,
                  formatType: VCFormatType.ldpVc,
                ),
                CredInfo(
                  credentialType: CredentialSubjectType.fantomAssociatedWallet,
                  formatType: VCFormatType.ldpVc,
                ),
                CredInfo(
                  credentialType: CredentialSubjectType.binanceAssociatedWallet,
                  formatType: VCFormatType.ldpVc,
                ),
                CredInfo(
                  credentialType: CredentialSubjectType.polygonAssociatedWallet,
                  formatType: VCFormatType.ldpVc,
                ),
                CredInfo(
                  credentialType:
                      CredentialSubjectType.etherlinkAssociatedWallet,
                  formatType: VCFormatType.ldpVc,
                ),
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

      final List<CredInfo> requiredCreds = [];

      for (final credInfo in allCategoryVC) {
        final isBlockchainAccount = credInfo.credentialType.isBlockchainAccount;

        /// remove if credential it is blockchain account
        if (isBlockchainAccount) {
          continue;
        }

        final credentialsOfSameType = credentials
            .where(
              (element) =>
                  element.credentialPreview.credentialSubjectModel
                      .credentialSubjectType ==
                  credInfo.credentialType,
            )
            .toList();

        if (credentialsOfSameType.isNotEmpty &&
            credInfo.credentialType.supportSingleOnly) {
          /// credential available case
          for (final credential in credentialsOfSameType) {
            if (credInfo.formatType.vcValue == credential.getFormat) {
              /// do not add if format matched
              /// there can be same credentials with different format
            } else {
              requiredCreds.add(credInfo);
            }
          }
        } else {
          /// credential not available case
          requiredCreds.add(credInfo);
        }
      }

      /// Generate list of external issuer from the profile
      dummies[category] =
          getDummiesFromExternalIssuerList(category, externalIssuers ?? []);

      /// add dummies from the category
      dummies[category]?.addAll(
        requiredCreds
            .map(
              (item) => item.credentialType.dummyCredential(
                profileSetting: profileSetting,
                assignedVCFormatType: item.formatType,
              ),
            )
            .toList(),
      );
    }

    return dummies;
  }

  Future<void> generateCryptoAccountsCards(
    List<CryptoAccountData> cryptoAccounts,
  ) async {
    // Loop on cryptoAccounts and generate the cards
    for (final cryptoAccount in cryptoAccounts) {
      final cryptoAccountData = CryptoAccountData(
        name: cryptoAccount.name,
        secretKey: cryptoAccount.secretKey,
        walletAddress: cryptoAccount.walletAddress,
        isImported: cryptoAccount.isImported,
        blockchainType: cryptoAccount.blockchainType,
      );

      await insertAssociatedWalletCredential(
        cryptoAccountData: cryptoAccountData,
      );
    }
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
            backgroundImage:
                DisplayDetails(url: e.background_image ?? e.background_url),
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
