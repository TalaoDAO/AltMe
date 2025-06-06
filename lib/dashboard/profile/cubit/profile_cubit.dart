import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/profile/models/display_external_issuer.dart';
import 'package:altme/dashboard/profile/models/models.dart';
import 'package:altme/dashboard/profile/profile_provider/get_profile_from_provider.dart';
import 'package:altme/dashboard/profile/profile_provider/get_wallet_attestation_data.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/oidc4vc/model/oidc4vci_stack.dart';
import 'package:altme/oidc4vc/model/oidc4vci_state.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:random_string/random_string.dart';

import 'package:secure_storage/secure_storage.dart';

part 'profile_cubit.g.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required this.secureStorageProvider,
    required this.oidc4vc,
    required this.didKitProvider,
    required this.langCubit,
    required this.jwtDecode,
  }) : super(ProfileState(model: ProfileModel.empty())) {
    load();
  }

  final SecureStorageProvider secureStorageProvider;
  final OIDC4VC oidc4vc;
  final DIDKitProvider didKitProvider;
  final LangCubit langCubit;
  final JWTDecode jwtDecode;

  Timer? _timer;

  int loginAttemptCount = 0;

  void passcodeEntered() {
    loginAttemptCount++;
    if (loginAttemptCount > 3) return;

    if (loginAttemptCount == 3) {
      setActionAllowValue(value: false);
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        resetloginAttemptCount();
        _timer?.cancel();
      });
    }
  }

  void resetloginAttemptCount() {
    loginAttemptCount = 0;
    setActionAllowValue(value: true);
  }

  void setActionAllowValue({required bool value}) {
    emit(state.copyWith(status: AppStatus.idle, allowLogin: value));
  }

  Future<void> load() async {
    final ssiKey = await secureStorageProvider.get(SecureStorageKeys.ssiKey);

    if (ssiKey == null) {
      return emit(state.copyWith(status: AppStatus.success));
    }

    emit(state.loading());

    final log = getLogger('ProfileCubit - load');
    try {
      /// walletType
      var walletType = WalletType.personal;

      final walletTypeString =
          await secureStorageProvider.get(SecureStorageKeys.walletType);

      if (walletTypeString != null) {
        final enumVal = WalletType.values.firstWhereOrNull(
          (ele) => ele.toString() == walletTypeString,
        );
        if (enumVal != null) {
          walletType = enumVal;
        }
      }

      var walletProtectionType = WalletProtectionType.pinCode;

      final walletProtectionTypeString = await secureStorageProvider
          .get(SecureStorageKeys.walletProtectionType);

      if (walletProtectionTypeString != null) {
        final enumVal = WalletProtectionType.values.firstWhereOrNull(
          (ele) => ele.toString() == walletProtectionTypeString,
        );
        if (enumVal != null) {
          walletProtectionType = enumVal;
        }
      }

      /// developer mode

      final isDeveloperModeValue =
          await secureStorageProvider.get(SecureStorageKeys.isDeveloperMode);

      bool isDeveloperMode =
          isDeveloperModeValue != null && isDeveloperModeValue == 'true';

      /// profileType

      var profileType = ProfileType.defaultOne;

      final profileTypeString =
          await secureStorageProvider.get(SecureStorageKeys.profileType);

      if (profileTypeString != null) {
        final enumVal = ProfileType.values.firstWhereOrNull(
          (ele) => ele.toString() == profileTypeString,
        );
        if (enumVal != null) {
          profileType = enumVal;
        }
      }
      final oidc4VCIStackJsonString =
          await secureStorageProvider.get(SecureStorageKeys.oidc4VCIStack);
      late Oidc4VCIStack oidc4VCIStack;
      if (oidc4VCIStackJsonString == null) {
        oidc4VCIStack = Oidc4VCIStack();
      } else {
        oidc4VCIStack = Oidc4VCIStack.fromJson(
          json.decode(oidc4VCIStackJsonString) as Map<String, dynamic>,
        );
      }

      String? enterpriseWalletName;

      final enterpriseProfileSettingJsonString =
          await secureStorageProvider.get(
        SecureStorageKeys.enterpriseProfileSetting,
      );

      final europeanWalletProfileSettingJsonString =
          await secureStorageProvider.get(
        SecureStorageKeys.europeanWalletProfileSetting,
      );

      if (enterpriseProfileSettingJsonString != null) {
        final ProfileSetting enterpriseProfileSetting = ProfileSetting.fromJson(
          json.decode(enterpriseProfileSettingJsonString)
              as Map<String, dynamic>,
        );

        enterpriseWalletName =
            enterpriseProfileSetting.generalOptions.profileName;
      }

      /// profileSetting
      late ProfileSetting profileSetting;

      late ProfileModel profileModel;

      /// based on profileType set the profile setting
      switch (profileType) {
        case ProfileType.custom:
          final customProfileSettingJsonString = await secureStorageProvider
              .get(SecureStorageKeys.customProfileSettings);

          if (customProfileSettingJsonString != null) {
            final customProfileSettingMap =
                jsonDecode(customProfileSettingJsonString)
                    as Map<String, dynamic>;

            profileSetting = ProfileSetting.fromJson(customProfileSettingMap);
          } else {
            profileSetting = ProfileSetting.initial();
          }

          profileModel = ProfileModel(
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            profileType: profileType,
            profileSetting: profileSetting,
            enterpriseWalletName: enterpriseWalletName,
          );

        case ProfileType.defaultOne:
          final privateKey = await getPrivateKey(
            didKeyType: Parameters.didKeyTypeForDefault,
            profileCubit: this,
          );

          final (did, _) = await getDidAndKid(
            didKeyType: Parameters.didKeyTypeForDefault,
            privateKey: privateKey,
            profileCubit: this,
          );

          profileModel = ProfileModel.defaultOne(
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            clientId: did,
            clientSecret: randomString(12),
            enterpriseWalletName: enterpriseWalletName,
          );

        case ProfileType.ebsiV3:
          final privateKey = await getPrivateKey(
            didKeyType: Parameters.didKeyTypeForEbsiV3,
            profileCubit: this,
          );

          final (did, _) = await getDidAndKid(
            didKeyType: Parameters.didKeyTypeForEbsiV3,
            privateKey: privateKey,
            profileCubit: this,
          );

          profileModel = ProfileModel.ebsiV3(
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            clientId: did,
            clientSecret: randomString(12),
            enterpriseWalletName: enterpriseWalletName,
          );

        // case ProfileType.ebsiV4:
        //   final privateKey = await getPrivateKey(
        //     didKeyType: Parameters.didKeyTypeForEbsiV4,
        //     profileCubit: this,
        //   );

        //   final (did, _) = await getDidAndKid(
        //     didKeyType: Parameters.didKeyTypeForEbsiV4,
        //     privateKey: privateKey,
        //     profileCubit: this,
        //   );

        //   profileModel = ProfileModel.ebsiV4(
        //     walletType: walletType,
        //     walletProtectionType: walletProtectionType,
        //     isDeveloperMode: isDeveloperMode,
        //     clientId: did,
        //     clientSecret: randomString(12),
        //     enterpriseWalletName: enterpriseWalletName,
        //   );

        case ProfileType.diipv3:
          final privateKey = await getPrivateKey(
            didKeyType: Parameters.didKeyTypeForOwfBaselineProfile,
            profileCubit: this,
          );

          final (did, _) = await getDidAndKid(
            didKeyType: Parameters.didKeyTypeForOwfBaselineProfile,
            privateKey: privateKey,
            profileCubit: this,
          );

          profileModel = ProfileModel.diipv3(
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            clientId: did,
            clientSecret: randomString(12),
            enterpriseWalletName: enterpriseWalletName,
          );

        case ProfileType.enterprise:
          if (enterpriseProfileSettingJsonString != null) {
            profileSetting = ProfileSetting.fromJson(
              json.decode(enterpriseProfileSettingJsonString)
                  as Map<String, dynamic>,
            );
            if (profileSetting.settingsMenu.displayDeveloperMode == false) {
              isDeveloperMode = false;
            }
          } else {
            profileSetting = ProfileSetting.initial();
          }

          profileModel = ProfileModel(
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            profileType: profileType,
            profileSetting: profileSetting,
            enterpriseWalletName: profileSetting.generalOptions.profileName,
          );
        case ProfileType.europeanWallet:
          if (europeanWalletProfileSettingJsonString != null) {
            final customProfileSettingMap =
                jsonDecode(europeanWalletProfileSettingJsonString)
                    as Map<String, dynamic>;

            profileSetting = ProfileSetting.fromJson(customProfileSettingMap);
          } else {
            throw Exception(
              'Failed to load European wallet profile setting',
            );
          }

          profileModel = ProfileModel(
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            profileType: profileType,
            profileSetting: profileSetting,
            enterpriseWalletName: enterpriseWalletName,
          );

        case ProfileType.inji:
          final injiProfileSettingJsonString = await secureStorageProvider
              .get(SecureStorageKeys.injiProfileSetting);

          if (injiProfileSettingJsonString != null) {
            final injiProfileSettingMap =
                jsonDecode(injiProfileSettingJsonString)
                    as Map<String, dynamic>;

            profileSetting = ProfileSetting.fromJson(injiProfileSettingMap);
          } else {
            throw Exception(
              'Failed to load Inji wallet profile setting',
            );
          }

          profileModel = ProfileModel(
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            profileType: profileType,
            profileSetting: profileSetting,
            enterpriseWalletName: enterpriseWalletName,
          );
      }

      await update(profileModel.copyWith(oidc4VCIStack: oidc4VCIStack));
    } catch (e, s) {
      log.e(
        'something went wrong',
        error: e,
        stackTrace: s,
      );
      emit(
        state.error(
          messageHandler: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE,
          ),
        ),
      );
    }
  }

  Future<void> update(ProfileModel profileModel) async {
    emit(state.loading());
    final log = getLogger('ProfileCubit - update');

    try {
      await secureStorageProvider.set(
        SecureStorageKeys.oidc4VCIStack,
        jsonEncode(profileModel.oidc4VCIStack),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.walletType,
        profileModel.walletType.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.walletProtectionType,
        profileModel.walletProtectionType.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isDeveloperMode,
        profileModel.isDeveloperMode.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.profileType,
        profileModel.profileType.toString(),
      );

      emit(
        state.copyWith(
          model: profileModel,
          status: AppStatus.success,
        ),
      );
    } catch (e, s) {
      log.e(
        'something went wrong',
        error: e,
        stackTrace: s,
      );

      emit(
        state.error(
          messageHandler: ResponseMessage(
            message: ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE,
          ),
        ),
      );
    }
  }

  Future<void> setWalletProtectionType({
    required WalletProtectionType walletProtectionType,
  }) async {
    final profileModel =
        state.model.copyWith(walletProtectionType: walletProtectionType);
    await update(profileModel);
  }

  Future<void> setWalletType({
    required WalletType walletType,
  }) async {
    final profileModel = state.model.copyWith(walletType: walletType);
    await update(profileModel);
  }

  Future<void> updateProfileSetting({
    DidKeyType? didKeyType,
    bool? securityLevel,
    bool? scope,
    bool? cryptoHolderBinding,
    bool? credentialManifestSupport,
    ClientAuthentication? clientAuthentication,
    String? clientId,
    String? clientSecret,
    bool? confirmSecurityVerifierAccess,
    bool? secureSecurityAuthenticationWithPinCode,
    bool? verifySecurityIssuerWebsiteIdentity,
    OIDC4VCIDraftType? oidc4vciDraftType,
    OIDC4VPDraftType? oidc4vpDraftType,
    ClientType? clientType,
    VCFormatType? vcFormatType,
    List<VCFormatType>? formatsSupported,
    ProofHeaderType? proofHeaderType,
    ProofType? proofType,
    bool? pushAuthorizationRequest,
    bool? statusListCaching,
    bool? displayNotification,
    bool? dpopSupport,
    bool? displayMode,
  }) async {
    final profileModel = state.model.copyWith(
      profileSetting: state.model.profileSetting.copyWith(
        walletSecurityOptions:
            state.model.profileSetting.walletSecurityOptions.copyWith(
          confirmSecurityVerifierAccess: confirmSecurityVerifierAccess,
          verifySecurityIssuerWebsiteIdentity:
              verifySecurityIssuerWebsiteIdentity,
          secureSecurityAuthenticationWithPinCode:
              secureSecurityAuthenticationWithPinCode,
        ),
        helpCenterOptions:
            state.model.profileSetting.helpCenterOptions.copyWith(
          displayNotification: displayNotification,
        ),
        selfSovereignIdentityOptions:
            state.model.profileSetting.selfSovereignIdentityOptions.copyWith(
          customOidc4vcProfile: state.model.profileSetting
              .selfSovereignIdentityOptions.customOidc4vcProfile
              .copyWith(
            defaultDid: didKeyType,
            securityLevel: securityLevel,
            proofHeader: proofHeaderType,
            scope: scope,
            cryptoHolderBinding: cryptoHolderBinding,
            credentialManifestSupport: credentialManifestSupport,
            clientAuthentication: clientAuthentication,
            clientId: clientId,
            clientSecret: clientSecret,
            oidc4vciDraft: oidc4vciDraftType,
            oidc4vpDraft: oidc4vpDraftType,
            clientType: clientType,
            vcFormatType: vcFormatType,
            proofType: proofType,
            pushAuthorizationRequest: pushAuthorizationRequest,
            statusListCache: statusListCaching,
            dpopSupport: dpopSupport,
            formatsSupported: formatsSupported,
            displayMode: displayMode,
          ),
        ),
      ),
    );

    await secureStorageProvider.set(
      SecureStorageKeys.customProfileSettings,
      jsonEncode(profileModel.profileSetting.toJson()),
    );

    emit(
      state.copyWith(
        model: profileModel,
        status: AppStatus.success,
      ),
    );
  }

  Future<void> setDeveloperModeStatus({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isDeveloperMode: enabled);
    await update(profileModel);
  }

  Future<void> setProfileSetting({
    required ProfileSetting profileSetting,
    required ProfileType profileType,
  }) async {
    final externalIssuers =
        profileSetting.discoverCardsOptions?.displayExternalIssuer;

    final updatedExternalIssuer = <DisplayExternalIssuer>[];
    if (externalIssuers != null) {
      for (final data in externalIssuers) {
        // background image
        String? backgroundImage = data.background_url;
        if (backgroundImage != null && isURL(backgroundImage)) {
          try {
            final http.Response response =
                await http.get(Uri.parse(backgroundImage));
            if (response.statusCode == 200) {
              backgroundImage = base64Encode(response.bodyBytes);
            }
          } catch (e) {
            //
          }
        }

        // logo
        String? logo = data.logo;
        if (logo != null && isURL(logo)) {
          try {
            final http.Response response = await http.get(Uri.parse(logo));
            if (response.statusCode == 200) {
              logo = base64Encode(response.bodyBytes);
            }
          } catch (e) {
            //
          }
        }

        //created update external issuer
        final issuer =
            data.copyWith(background_url: backgroundImage, logo: logo);
        updatedExternalIssuer.add(issuer);
      }
    }

    String? companyLogo = profileSetting.generalOptions.companyLogo;

    ///company logo

    if (isURL(companyLogo)) {
      try {
        final http.Response response = await http.get(Uri.parse(companyLogo));
        if (response.statusCode == 200) {
          companyLogo = base64Encode(response.bodyBytes);
        }
      } catch (e) {
        //
      }
    }

    String? companyLogoLight = profileSetting.generalOptions.companyLogoLight;

    ///company Logo Light

    if (companyLogoLight != null && isURL(companyLogoLight)) {
      try {
        final http.Response response =
            await http.get(Uri.parse(companyLogoLight));
        if (response.statusCode == 200) {
          companyLogoLight = base64Encode(response.bodyBytes);
        }
      } catch (e) {
        //
      }
    }

    final profileModel = state.model.copyWith(
      isDeveloperMode: profileSetting.settingsMenu.displayDeveloperMode &&
          state.model.isDeveloperMode,
      profileSetting: profileSetting.copyWith(
        generalOptions: profileSetting.generalOptions.copyWith(
          companyLogo: companyLogo,
          companyLogoLight: companyLogoLight,
        ),
        discoverCardsOptions: profileSetting.discoverCardsOptions?.copyWith(
          displayExternalIssuer: updatedExternalIssuer,
        ),
      ),
      profileType: profileType,
      enterpriseWalletName: profileSetting.generalOptions.profileName,
    );
    await update(profileModel);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }

  Future<void> setProfile(ProfileType profileType) async {
    final previousProfileType = state.model.profileType;
    if (previousProfileType == ProfileType.custom) {
      await secureStorageProvider.set(
        SecureStorageKeys.customProfileSettings,
        jsonEncode(state.model.profileSetting.toJson()),
      );
    }

    switch (profileType) {
      case ProfileType.ebsiV3:
        await update(
          ProfileModel.ebsiV3(
            walletProtectionType: state.model.walletProtectionType,
            isDeveloperMode: state.model.isDeveloperMode,
            walletType: state.model.walletType,
            enterpriseWalletName: state.model.enterpriseWalletName,
            clientId: state.model.profileSetting.selfSovereignIdentityOptions
                .customOidc4vcProfile.clientId,
            clientSecret: state.model.profileSetting
                .selfSovereignIdentityOptions.customOidc4vcProfile.clientSecret,
          ),
        );
      // case ProfileType.ebsiV4:
      //   await update(
      //     ProfileModel.ebsiV4(
      //       walletProtectionType: state.model.walletProtectionType,
      //       isDeveloperMode: state.model.isDeveloperMode,
      //       walletType: state.model.walletType,
      //       enterpriseWalletName: state.model.enterpriseWalletName,
      //       clientId: state.model.profileSetting.selfSovereignIdentityOptions
      //           .customOidc4vcProfile.clientId,
      //       clientSecret: state.model.profileSetting
      //           .selfSovereignIdentityOptions.customOidc4vcProfile.clientSecret,
      //     ),
      //   );
      case ProfileType.defaultOne:
        await update(
          ProfileModel.defaultOne(
            walletProtectionType: state.model.walletProtectionType,
            isDeveloperMode: state.model.isDeveloperMode,
            walletType: state.model.walletType,
            enterpriseWalletName: state.model.enterpriseWalletName,
            clientId: state.model.profileSetting.selfSovereignIdentityOptions
                .customOidc4vcProfile.clientId,
            clientSecret: state.model.profileSetting
                .selfSovereignIdentityOptions.customOidc4vcProfile.clientSecret,
          ),
        );

      case ProfileType.diipv3:
        await update(
          ProfileModel.diipv3(
            walletProtectionType: state.model.walletProtectionType,
            isDeveloperMode: state.model.isDeveloperMode,
            walletType: state.model.walletType,
            enterpriseWalletName: state.model.enterpriseWalletName,
            clientId: state.model.profileSetting.selfSovereignIdentityOptions
                .customOidc4vcProfile.clientId,
            clientSecret: state.model.profileSetting
                .selfSovereignIdentityOptions.customOidc4vcProfile.clientSecret,
          ),
        );
      case ProfileType.custom:
        final String? customProfileSettingBackup =
            await secureStorageProvider.get(
          SecureStorageKeys.customProfileSettings,
        );

        late ProfileSetting customProfileSetting;

        if (customProfileSettingBackup == null) {
          customProfileSetting = ProfileSetting.initial();
        } else {
          final profileJson =
              json.decode(customProfileSettingBackup) as Map<String, dynamic>;

          customProfileSetting = ProfileSetting.fromJson(profileJson);
        }

        await update(
          state.model.copyWith(
            profileType: profileType,
            profileSetting: customProfileSetting,
          ),
        );
      case ProfileType.enterprise:
        final String enterpriseProfileSettingData =
            await secureStorageProvider.get(
                  SecureStorageKeys.enterpriseProfileSetting,
                ) ??
                jsonEncode(state.model.profileSetting);
        final enterpriseProfileSetting = ProfileSetting.fromJson(
          json.decode(enterpriseProfileSettingData) as Map<String, dynamic>,
        );

        await update(
          state.model.copyWith(
            isDeveloperMode:
                enterpriseProfileSetting.settingsMenu.displayDeveloperMode &&
                    state.model.isDeveloperMode,
            profileType: profileType,
            profileSetting: enterpriseProfileSetting,
            enterpriseWalletName:
                enterpriseProfileSetting.generalOptions.profileName,
          ),
        );
      case ProfileType.europeanWallet:
        final profileSetting = await _setupWalletProfile(
          email: 'guest@EWC',
          password: 'guest',
          storageKey: SecureStorageKeys.europeanWalletProfileSetting,
          loggerTag: 'loadEuropeanWallet',
        );
        await update(
          state.model.copyWith(
            profileType: profileType,
            profileSetting: profileSetting,
          ),
        );
        emit(state.copyWith(status: AppStatus.addEuropeanProfile));

      case ProfileType.inji:
        final profileSetting = await _setupWalletProfile(
          email: 'guest@Mosip',
          password: 'guest',
          storageKey: SecureStorageKeys.injiProfileSetting,
          loggerTag: 'loadInjiWallet',
        );
        await update(
          state.model.copyWith(
            profileType: profileType,
            profileSetting: profileSetting,
          ),
        );
        emit(state.copyWith(status: AppStatus.addInjiProfile));
    }
  }

  Future<void> resetProfile() async {
    final profileModel = ProfileModel.empty();
    await update(profileModel);
  }

  void addOidc4VCI(Oidc4VCIState data) {
    final list = List<Oidc4VCIState>.from(state.model.oidc4VCIStack!.stack);
    final stackLength = list.length;
    if (stackLength > 4) {
      list.removeAt(0);
    }
    list.add(data);
    update(state.model.copyWith(oidc4VCIStack: Oidc4VCIStack(stack: list)));
  }

  Oidc4VCIState? getOidc4VCIStateFromJWT(String? key) {
    if (key == null) {
      return null;
    }
    final jwt = decodePayload(
      jwtDecode: JWTDecode(),
      token: key,
    );
    final challenge = jwt['challenge'] as String;
    return getOidc4VCIState(challenge);
  }

  Oidc4VCIState? getOidc4VCIState(String? key) {
    if (key == null) {
      return null;
    }
    final candidates = state.model.oidc4VCIStack!.stack
        .where((element) => element.challenge == key)
        .toList();
    return candidates[0];
  }

  Future<void> deleteOidc4VCIState(String? key) async {
    if (key == null) {
      return Future.value();
    }

    final Oidc4VCIStack oidc4VCIStack = state.model.oidc4VCIStack!;
    oidc4VCIStack.stack.removeWhere((element) => element.challenge == key);
    final profilModel = state.model.copyWith(oidc4VCIStack: oidc4VCIStack);
    await update(profilModel);
    return Future.value();
  }

  /// Helper method to setup wallet profile configuration
  Future<ProfileSetting> _setupWalletProfile({
    required String email,
    required String password,
    required String storageKey,
    required String loggerTag,
  }) async {
    late ProfileSetting profileSetting;
    try {
      const url = 'https://wallet-provider.talao.co';
      final walletAttestationData = await getWalletAttestationData(
        url: url,
        secureStorageProvider: secureStorageProvider,
        profileModel: state.model,
        client: DioClient(
          secureStorageProvider: secureStorageProvider,
          dio: Dio(),
        ),
        jwtDecode: JWTDecode(),
      );

      final profileSettingJson = await getProfileFromProvider(
        email: email,
        password: password,
        jwtVc: walletAttestationData,
        url: url,
        client: DioClient(
          secureStorageProvider: secureStorageProvider,
          dio: Dio(),
        ),
      );
      profileSetting = ProfileSetting.fromJson(
        json.decode(profileSettingJson) as Map<String, dynamic>,
      );
      profileSetting = profileSetting.copyWith(
        settingsMenu: profileSetting.settingsMenu.copyWith(
          displayProfile: true,
        ),
      );
      await secureStorageProvider.set(
        storageKey,
        jsonEncode(profileSetting.toJson()),
      );
    } catch (e, s) {
      final log = getLogger('ProfileCubit - $loggerTag');
      log.e(
        'Failed to load $loggerTag configuration',
        error: e,
        stackTrace: s,
      );
      throw Exception('Failed to load $loggerTag configuration');
    }
    return profileSetting;
  }
}
