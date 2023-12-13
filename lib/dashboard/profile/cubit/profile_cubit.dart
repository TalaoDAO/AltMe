import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/profile/models/models.dart';
import 'package:altme/polygon_id/cubit/polygon_id_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

import 'package:secure_storage/secure_storage.dart';

part 'profile_cubit.g.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required this.secureStorageProvider})
      : super(ProfileState(model: ProfileModel.empty())) {
    load();
  }

  final SecureStorageProvider secureStorageProvider;

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
    emit(state.loading());

    final log = getLogger('ProfileCubit - load');
    try {
      final polygonIdNetwork = (await secureStorageProvider
              .get(SecureStorageKeys.polygonIdNetwork)) ??
          PolygonIdNetwork.PolygonMainnet.toString();

      final walletType =
          (await secureStorageProvider.get(SecureStorageKeys.walletType)) ??
              WalletType.personal.toString();

      final walletProtectionType = (await secureStorageProvider
              .get(SecureStorageKeys.walletProtectionType)) ??
          WalletProtectionType.pinCode.toString();

      final isDeveloperModeValue =
          await secureStorageProvider.get(SecureStorageKeys.isDeveloperMode);

      final isDeveloperMode =
          isDeveloperModeValue != null && isDeveloperModeValue == 'true';

      final profileSettingJsonString =
          await secureStorageProvider.get(SecureStorageKeys.profileSettings);

      final ProfileSetting profileSetting = profileSettingJsonString == null
          ? ProfileSetting.initial()
          : ProfileSetting.fromJson(
              jsonDecode(profileSettingJsonString) as Map<String, dynamic>,
            );

      final userConsentForIssuerAccess = (await secureStorageProvider
              .get(SecureStorageKeys.userConsentForIssuerAccess)) ==
          'true';

      final userConsentForVerifierAccess = (await secureStorageProvider
              .get(SecureStorageKeys.userConsentForVerifierAccess)) ==
          'true';

      final enableJWKThumbprintValue = await secureStorageProvider
          .get(SecureStorageKeys.enableJWKThumbprint);

      final enableJWKThumbprint = enableJWKThumbprintValue != null &&
          enableJWKThumbprintValue == 'true';

      final userPINCodeForAuthenticationValue = await secureStorageProvider
          .get(SecureStorageKeys.userPINCodeForAuthentication);
      final userPINCodeForAuthentication =
          userPINCodeForAuthenticationValue == null ||
              userPINCodeForAuthenticationValue == 'true';

      final profileType =
          (await secureStorageProvider.get(SecureStorageKeys.profileType)) ??
              ProfileType.custom.toString();

      final draftType =
          (await secureStorageProvider.get(SecureStorageKeys.draftType)) ??
              OIDC4VCIDraftType.draft11.toString();

      final profileModel = ProfileModel(
        polygonIdNetwork: polygonIdNetwork,
        walletType: walletType,
        walletProtectionType: walletProtectionType,
        userConsentForIssuerAccess: userConsentForIssuerAccess,
        userConsentForVerifierAccess: userConsentForVerifierAccess,
        userPINCodeForAuthentication: userPINCodeForAuthentication,
        isDeveloperMode: isDeveloperMode,
        enableJWKThumbprint: enableJWKThumbprint,
        profileType: profileType,
        draftType: draftType,
        profileSetting: profileSetting,
      );
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
        profileModel.polygonIdNetwork,
      );

      await secureStorageProvider.set(
        SecureStorageKeys.walletType,
        profileModel.walletType,
      );

      await secureStorageProvider.set(
        SecureStorageKeys.walletProtectionType,
        profileModel.walletProtectionType,
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isDeveloperMode,
        profileModel.isDeveloperMode.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.profileSettings,
        jsonEncode(profileModel.profileSetting.toJson()),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.userConsentForIssuerAccess,
        profileModel.userConsentForIssuerAccess.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.userConsentForVerifierAccess,
        profileModel.userConsentForVerifierAccess.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.userPINCodeForAuthentication,
        profileModel.userPINCodeForAuthentication.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.enableJWKThumbprint,
        profileModel.enableJWKThumbprint.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.profileType,
        profileModel.profileType,
      );

      await secureStorageProvider.set(
        SecureStorageKeys.draftType,
        profileModel.draftType,
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
    final profileModel = state.model
        .copyWith(walletProtectionType: walletProtectionType.toString());
    await update(profileModel);
  }

  Future<void> updatePolygonIdNetwork({
    required PolygonIdNetwork polygonIdNetwork,
    required PolygonIdCubit polygonIdCubit,
  }) async {
    emit(state.copyWith(status: AppStatus.loading));
    final profileModel =
        state.model.copyWith(polygonIdNetwork: polygonIdNetwork.toString());

    await polygonIdCubit.setEnv(polygonIdNetwork);

    await update(profileModel);
  }

  Future<void> setWalletType({
    required WalletType walletType,
  }) async {
    final profileModel =
        state.model.copyWith(walletType: walletType.toString());
    await update(profileModel);
  }

  Future<void> updateProfileSetting({
    DidKeyType? didKeyType,
    SecurityLevel? securityLevel,
    UserPinDigits? userPinDigits,
    bool? scope,
    bool? cryptoHolderBinding,
    bool? credentialManifestSupport,
    ClientAuthentication? clientAuthentication,
    String? clientId,
    String? clientSecret,
  }) async {
    final profileModel = state.model.copyWith(
      profileSetting: state.model.profileSetting.copyWith(
        selfSovereignIdentityOptions:
            state.model.profileSetting.selfSovereignIdentityOptions.copyWith(
          customOidc4vcProfile: state.model.profileSetting
              .selfSovereignIdentityOptions.customOidc4vcProfile
              .copyWith(
            defaultDid: didKeyType,
            securityLevel: securityLevel,
            scope: scope,
            cryptoHolderBinding: cryptoHolderBinding,
            credentialManifestSupport: credentialManifestSupport,
            clientAuthentication: clientAuthentication,
            clientId: clientId,
            clientSecret: clientSecret,
          ),
        ),
      ),
    );

    await update(profileModel);
  }

  Future<void> setDeveloperModeStatus({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isDeveloperMode: enabled);
    await update(profileModel);
  }

  Future<void> setProfileSetting(ProfileSetting profileSetting) async {
    final profileModel = state.model.copyWith(profileSetting: profileSetting);
    await update(profileModel);
  }

  Future<void> setUserConsentForIssuerAccess({bool enabled = false}) async {
    final profileModel =
        state.model.copyWith(userConsentForIssuerAccess: enabled);
    await update(profileModel);
  }

  Future<void> setUserConsentForVerifierAccess({bool enabled = false}) async {
    final profileModel =
        state.model.copyWith(userConsentForVerifierAccess: enabled);
    await update(profileModel);
  }

  Future<void> setUserPINCodeForAuthentication({bool enabled = false}) async {
    final profileModel =
        state.model.copyWith(userPINCodeForAuthentication: enabled);
    await update(profileModel);
  }

  Future<void> updateJWKThumbprintStatus({bool enabled = false}) async {
    final profileModel = state.model.copyWith(enableJWKThumbprint: enabled);
    await update(profileModel);
  }

  Future<void> updateDraftType(OIDC4VCIDraftType draftType) async {
    final profileModel = state.model.copyWith(draftType: draftType.toString());
    await update(profileModel);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }

  Future<void> setProfile(ProfileType profile) async {
    if (profile != ProfileType.custom) {
      // we save current custom settings
      // Warning when will get multiple profile this backup won't be automatic
      final customProfileBackup = jsonEncode(state.model);
      await secureStorageProvider.set(
        SecureStorageKeys.customProfileBackup,
        customProfileBackup,
      );
    }

    switch (profile) {
      case ProfileType.ebsiV3:
        await update(ProfileModel.ebsiV3(state.model));
      case ProfileType.dutch:
        await update(ProfileModel.dutch(state.model));
      case ProfileType.custom:
        final String customProfileBackupValue = await secureStorageProvider.get(
              SecureStorageKeys.customProfileBackup,
            ) ??
            jsonEncode(state.model);
        final customProfileBackup = ProfileModel.fromJson(
          json.decode(customProfileBackupValue) as Map<String, dynamic>,
        );
        final profileModel = state.model.copyWith(
          profileType: profile.toString(),
          // enableSecurity: customProfileBackup.enableSecurity,
          // enable4DigitPINCode: customProfileBackup.enable4DigitPINCode,
          enableJWKThumbprint: customProfileBackup.enableJWKThumbprint,
          // enableCryptographicHolderBinding:
          //     customProfileBackup.enableCryptographicHolderBinding,
          // enableCredentialManifestSupport:
          //     customProfileBackup.enableCredentialManifestSupport,
          // // didKeyType: customProfileBackup.didKeyType,
          // // enableScopeParameter: customProfileBackup.enableScopeParameter,
          // useBasicClientAuthentication:
          //     customProfileBackup.useBasicClientAuthentication,
          // clientId: customProfileBackup.clientId,
          // clientSecret: customProfileBackup.clientSecret,
        );
        await update(profileModel);
    }
  }

  Future<void> resetProfile() async {
    final profileModel = ProfileModel.empty();
    await update(profileModel);
  }
}
