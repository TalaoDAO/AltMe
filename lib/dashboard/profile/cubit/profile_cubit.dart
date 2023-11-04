import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/polygon_id/cubit/polygon_id_cubit.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

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
      final firstName =
          await secureStorageProvider.get(SecureStorageKeys.firstNameKey) ?? '';
      final lastName =
          await secureStorageProvider.get(SecureStorageKeys.lastNameKey) ?? '';
      final phone =
          await secureStorageProvider.get(SecureStorageKeys.phoneKey) ?? '';
      final location =
          await secureStorageProvider.get(SecureStorageKeys.locationKey) ?? '';
      final email =
          await secureStorageProvider.get(SecureStorageKeys.emailKey) ?? '';
      final companyName =
          await secureStorageProvider.get(SecureStorageKeys.companyName) ?? '';
      final companyWebsite =
          await secureStorageProvider.get(SecureStorageKeys.companyWebsite) ??
              '';
      final jobTitle =
          await secureStorageProvider.get(SecureStorageKeys.jobTitle) ?? '';

      final polygonIdNetwork = (await secureStorageProvider
              .get(SecureStorageKeys.polygonIdNetwork)) ??
          PolygonIdNetwork.PolygonMainnet.toString();

      final didKeyType =
          (await secureStorageProvider.get(SecureStorageKeys.didKeyType)) ??
              DidKeyType.ebsiv3.toString();

      final tezosNetworkJson = await secureStorageProvider
          .get(SecureStorageKeys.blockchainNetworkKey);
      final tezosNetwork = tezosNetworkJson != null
          ? TezosNetwork.fromJson(
              json.decode(tezosNetworkJson) as Map<String, dynamic>,
            )
          : TezosNetwork.mainNet();
      final isEnterprise = (await secureStorageProvider
              .get(SecureStorageKeys.isEnterpriseUser)) ==
          'true';

      final isBiometricEnabled = (await secureStorageProvider
              .get(SecureStorageKeys.isBiometricEnabled)) ==
          'true';

      final userConsentForIssuerAccess = (await secureStorageProvider
              .get(SecureStorageKeys.userConsentForIssuerAccess)) ==
          'true';

      final userConsentForVerifierAccess = (await secureStorageProvider
              .get(SecureStorageKeys.userConsentForVerifierAccess)) ==
          'true';

      final enableSecurityValue =
          await secureStorageProvider.get(SecureStorageKeys.enableSecurity);

      final enableSecurity =
          enableSecurityValue != null && enableSecurityValue == 'true';

      final isDeveloperModeValue =
          await secureStorageProvider.get(SecureStorageKeys.isDeveloperMode);

      final isDeveloperMode =
          isDeveloperModeValue != null && isDeveloperModeValue == 'true';

      final enableJWKThumbprintValue = await secureStorageProvider
          .get(SecureStorageKeys.enableJWKThumbprint);

      final enableJWKThumbprint = enableJWKThumbprintValue != null &&
          enableJWKThumbprintValue == 'true';

      final enableCryptographicHolderBindingValue = await secureStorageProvider
          .get(SecureStorageKeys.enableCryptographicHolderBinding);

      final enableCryptographicHolderBinding =
          enableCryptographicHolderBindingValue == null ||
              enableCryptographicHolderBindingValue == 'true';

      final enableScopeParameterValue = await secureStorageProvider
          .get(SecureStorageKeys.enableScopeParameter);

      final enableScopeParameter = enableScopeParameterValue != null &&
          enableScopeParameterValue == 'true';

      final isPreRegisteredWalletValue = await secureStorageProvider
          .get(SecureStorageKeys.isPreRegisteredWallet);

      final clientSecret =
          await secureStorageProvider.get(SecureStorageKeys.clientSecret) ?? '';

      final clientId =
          await secureStorageProvider.get(SecureStorageKeys.clientId) ?? '';

      final isPreRegisteredWallet = isPreRegisteredWalletValue != null &&
          isPreRegisteredWalletValue == 'true';

      final userPINCodeForAuthenticationValue = await secureStorageProvider
          .get(SecureStorageKeys.userPINCodeForAuthentication);
      final userPINCodeForAuthentication =
          userPINCodeForAuthenticationValue == null ||
              userPINCodeForAuthenticationValue == 'true';

      final enable4DigitPINCodeValue = await secureStorageProvider
          .get(SecureStorageKeys.enable4DigitPINCode);

      final enable4DigitPINCode = enable4DigitPINCodeValue != null &&
          enable4DigitPINCodeValue == 'true';

      final profileModel = ProfileModel(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        location: location,
        email: email,
        polygonIdNetwork: polygonIdNetwork,
        didKeyType: didKeyType,
        tezosNetwork: tezosNetwork,
        companyName: companyName,
        companyWebsite: companyWebsite,
        jobTitle: jobTitle,
        isEnterprise: isEnterprise,
        isBiometricEnabled: isBiometricEnabled,
        userConsentForIssuerAccess: userConsentForIssuerAccess,
        userConsentForVerifierAccess: userConsentForVerifierAccess,
        userPINCodeForAuthentication: userPINCodeForAuthentication,
        enableSecurity: enableSecurity,
        isDeveloperMode: isDeveloperMode,
        enable4DigitPINCode: enable4DigitPINCode,
        enableJWKThumbprint: enableJWKThumbprint,
        enableCryptographicHolderBinding: enableCryptographicHolderBinding,
        enableScopeParameter: enableScopeParameter,
        isPreRegisteredWallet: isPreRegisteredWallet,
        clientSecret: clientSecret,
        clientId: clientId,
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
        SecureStorageKeys.firstNameKey,
        profileModel.firstName,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.lastNameKey,
        profileModel.lastName,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.phoneKey,
        profileModel.phone,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.locationKey,
        profileModel.location,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.emailKey,
        profileModel.email,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.companyName,
        profileModel.companyName,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.companyWebsite,
        profileModel.companyWebsite,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.jobTitle,
        profileModel.jobTitle,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.polygonIdNetwork,
        profileModel.polygonIdNetwork,
      );
      await secureStorageProvider.set(
        SecureStorageKeys.didKeyType,
        profileModel.didKeyType,
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isEnterpriseUser,
        profileModel.isEnterprise.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isBiometricEnabled,
        profileModel.isBiometricEnabled.toString(),
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
        SecureStorageKeys.enableSecurity,
        profileModel.enableSecurity.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isDeveloperMode,
        profileModel.isDeveloperMode.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.enable4DigitPINCode,
        profileModel.enable4DigitPINCode.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.enableJWKThumbprint,
        profileModel.enableJWKThumbprint.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.enableCryptographicHolderBinding,
        profileModel.enableCryptographicHolderBinding.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.enableScopeParameter,
        profileModel.enableScopeParameter.toString(),
      );

      await secureStorageProvider.set(
        SecureStorageKeys.isPreRegisteredWallet,
        profileModel.isPreRegisteredWallet.toString(),
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

  Future<void> setFingerprintEnabled({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isBiometricEnabled: enabled);
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

  Future<void> updateDidKeyType(DidKeyType didKeyType) async {
    final profileModel =
        state.model.copyWith(didKeyType: didKeyType.toString());
    await update(profileModel);
  }

  Future<void> enableSecurity({bool enabled = false}) async {
    final profileModel = state.model.copyWith(enableSecurity: enabled);
    await update(profileModel);
  }

  Future<void> setDeveloperModeStatus({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isDeveloperMode: enabled);
    await update(profileModel);
  }

  Future<void> updateJWKThumbprintStatus({bool enabled = false}) async {
    final profileModel = state.model.copyWith(enableJWKThumbprint: enabled);
    await update(profileModel);
  }

  Future<void> updateCryptographicHolderBindingStatus({
    bool enabled = false,
  }) async {
    final profileModel =
        state.model.copyWith(enableCryptographicHolderBinding: enabled);
    await update(profileModel);
  }

  Future<void> updateScopeParameterStatus({bool enabled = false}) async {
    final profileModel = state.model.copyWith(enableScopeParameter: enabled);
    await update(profileModel);
  }

  Future<void> updatePreRegisteredWalletStatus({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isPreRegisteredWallet: enabled);
    await update(profileModel);
  }

  Future<void> updatePreRegisteredWalletSettings({
    String clientId = '',
    String clientSecret = '',
  }) async {
    final profileModel = state.model.copyWith(
      clientId: clientId,
      clientSecret: clientSecret,
    );
    await update(profileModel);
  }

  Future<void> enable4DigitPINCode({bool enabled = false}) async {
    final profileModel = state.model.copyWith(enable4DigitPINCode: enabled);
    await update(profileModel);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
