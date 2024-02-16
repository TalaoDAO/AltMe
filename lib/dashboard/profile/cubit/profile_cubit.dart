import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/profile/models/models.dart';
import 'package:altme/polygon_id/cubit/polygon_id_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:did_kit/did_kit.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
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
  }) : super(ProfileState(model: ProfileModel.empty())) {
    load();
  }

  final SecureStorageProvider secureStorageProvider;
  final OIDC4VC oidc4vc;
  final DIDKitProvider didKitProvider;

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
    final ssiKey = await getSecureStorage.get(SecureStorageKeys.ssiKey);
    if (ssiKey == null) {
      return emit(state.copyWith(status: AppStatus.success));
    }

    emit(state.loading());

    final log = getLogger('ProfileCubit - load');
    try {
      /// polygon id network
      var polygonIdNetwork = PolygonIdNetwork.PolygonMainnet;

      final polygonIdNetworkString =
          await secureStorageProvider.get(SecureStorageKeys.polygonIdNetwork);

      if (polygonIdNetworkString != null) {
        final enumVal = PolygonIdNetwork.values.firstWhereOrNull(
          (ele) => ele.toString() == polygonIdNetworkString,
        );
        if (enumVal != null) {
          polygonIdNetwork = enumVal;
        }
      }

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

      /// polygon id network
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

      final isDeveloperMode =
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

            if (customProfileSettingMap['selfSovereignIdentityOptions']
                    ['customOidc4vcProfile']['client_id'] ==
                null) {
              customProfileSettingMap['selfSovereignIdentityOptions']
                  ['customOidc4vcProfile']['client_id'] = Parameters.clientId;
            }
            if (customProfileSettingMap['selfSovereignIdentityOptions']
                    ['customOidc4vcProfile']['client_secret'] ==
                null) {
              customProfileSettingMap['selfSovereignIdentityOptions']
                  ['customOidc4vcProfile']['client_secret'] = randomString(12);
            }

            profileSetting = ProfileSetting.fromJson(customProfileSettingMap);
          } else {
            profileSetting = ProfileSetting.initial();
          }

          profileModel = ProfileModel(
            polygonIdNetwork: polygonIdNetwork,
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            profileType: profileType,
            profileSetting: profileSetting,
          );

        case ProfileType.defaultOne:
          final privateKey = await getPrivateKey(
            secureStorage: secureStorageProvider,
            didKeyType: Parameters.didKeyTypeForDefault,
            oidc4vc: oidc4vc,
          );

          final (did, _) = await getDidAndKid(
            didKeyType: Parameters.didKeyTypeForDefault,
            privateKey: privateKey,
            secureStorage: secureStorageProvider,
            didKitProvider: didKitProvider,
          );

          profileModel = ProfileModel.defaultOne(
            polygonIdNetwork: polygonIdNetwork,
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            clientId: did,
            clientSecret: randomString(12),
          );

        case ProfileType.ebsiV3:
          final privateKey = await getPrivateKey(
            secureStorage: secureStorageProvider,
            didKeyType: Parameters.didKeyTypeForEbsiV3,
            oidc4vc: oidc4vc,
          );

          final (did, _) = await getDidAndKid(
            didKeyType: Parameters.didKeyTypeForEbsiV3,
            privateKey: privateKey,
            secureStorage: secureStorageProvider,
            didKitProvider: didKitProvider,
          );

          profileModel = ProfileModel.ebsiV3(
            polygonIdNetwork: polygonIdNetwork,
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            clientId: did,
            clientSecret: randomString(12),
          );

        case ProfileType.dutch:
          final privateKey = await getPrivateKey(
            secureStorage: secureStorageProvider,
            didKeyType: Parameters.didKeyTypeForDutch,
            oidc4vc: oidc4vc,
          );

          final (did, _) = await getDidAndKid(
            didKeyType: Parameters.didKeyTypeForDutch,
            privateKey: privateKey,
            secureStorage: secureStorageProvider,
            didKitProvider: didKitProvider,
          );

          profileModel = ProfileModel.dutch(
            polygonIdNetwork: polygonIdNetwork,
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            clientId: did,
            clientSecret: randomString(12),
          );

        case ProfileType.owfBaselineProfile:
          final privateKey = await getPrivateKey(
            secureStorage: secureStorageProvider,
            didKeyType: Parameters.didKeyTypeForOwfBaselineProfile,
            oidc4vc: oidc4vc,
          );

          final (did, _) = await getDidAndKid(
            didKeyType: Parameters.didKeyTypeForOwfBaselineProfile,
            privateKey: privateKey,
            secureStorage: secureStorageProvider,
            didKitProvider: didKitProvider,
          );

          profileModel = ProfileModel.owfBaselineProfile(
            polygonIdNetwork: polygonIdNetwork,
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            clientId: did,
            clientSecret: randomString(12),
          );

        case ProfileType.enterprise:
          final enterpriseProfileSettingJsonString =
              await secureStorageProvider.get(
            SecureStorageKeys.enterpriseProfileSetting,
          );

          if (enterpriseProfileSettingJsonString != null) {
            profileSetting = ProfileSetting.fromJson(
              json.decode(enterpriseProfileSettingJsonString)
                  as Map<String, dynamic>,
            );
          } else {
            profileSetting = ProfileSetting.initial();
          }

          profileModel = ProfileModel(
            polygonIdNetwork: polygonIdNetwork,
            walletType: walletType,
            walletProtectionType: walletProtectionType,
            isDeveloperMode: isDeveloperMode,
            profileType: profileType,
            profileSetting: profileSetting,
            enterpriseWalletName: profileSetting.generalOptions.profileName,
          );
      }
      await update(profileModel);
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
        SecureStorageKeys.polygonIdNetwork,
        profileModel.polygonIdNetwork.toString(),
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

  Future<void> updatePolygonIdNetwork({
    required PolygonIdNetwork polygonIdNetwork,
    required PolygonIdCubit polygonIdCubit,
  }) async {
    emit(state.copyWith(status: AppStatus.loading));
    final profileModel =
        state.model.copyWith(polygonIdNetwork: polygonIdNetwork);

    await polygonIdCubit.setEnv(polygonIdNetwork);

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
    ClientType? clientType,
    VCFormatType? vcFormatType,
    ProofHeaderType? proofHeaderType,
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
            clientType: clientType,
            vcFormatType: vcFormatType,
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
    final profileModel = state.model.copyWith(
      profileSetting: profileSetting,
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
            polygonIdNetwork: state.model.polygonIdNetwork,
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
      case ProfileType.defaultOne:
        await update(
          ProfileModel.defaultOne(
            polygonIdNetwork: state.model.polygonIdNetwork,
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
      case ProfileType.dutch:
        await update(
          ProfileModel.dutch(
            polygonIdNetwork: state.model.polygonIdNetwork,
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
      case ProfileType.owfBaselineProfile:
        await update(
          ProfileModel.owfBaselineProfile(
            polygonIdNetwork: state.model.polygonIdNetwork,
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
        final String customProfileSettingBackup =
            await secureStorageProvider.get(
                  SecureStorageKeys.customProfileSettings,
                ) ??
                jsonEncode(state.model.profileSetting);
        final customProfileSetting = ProfileSetting.fromJson(
          json.decode(customProfileSettingBackup) as Map<String, dynamic>,
        );

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
            profileType: profileType,
            profileSetting: enterpriseProfileSetting,
            enterpriseWalletName:
                enterpriseProfileSetting.generalOptions.profileName,
          ),
        );
    }
  }

  Future<void> resetProfile() async {
    final profileModel = ProfileModel.empty();
    await update(profileModel);
  }
}
