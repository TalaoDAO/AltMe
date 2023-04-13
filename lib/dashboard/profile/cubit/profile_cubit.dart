import 'dart:async';
import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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

      // by default none is chosen (empty url means none)
      final issuerVerificationUrls = (await secureStorageProvider
                  .get(SecureStorageKeys.issuerVerificationUrlKey) ??
              '${Urls.checkIssuerPolygonTestnetUrl},${Urls.checkIssuerEbsiUrl}')
          .split(',')
          .toSet();
      // check if at least two issuer is selected from our issuer urls
      if (issuerVerificationUrls.length < 2 ||
          !Urls.issuerUrls.containsAll(issuerVerificationUrls)) {
        issuerVerificationUrls.clear();
        issuerVerificationUrls.addAll(
          [Urls.checkIssuerPolygonTestnetUrl, Urls.checkIssuerEbsiUrl],
        );
      }
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

      final isAlertEnabled =
          (await secureStorageProvider.get(SecureStorageKeys.alertEnabled)) ==
              'true';

      final profileModel = ProfileModel(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        location: location,
        email: email,
        issuerVerificationUrls: issuerVerificationUrls,
        tezosNetwork: tezosNetwork,
        companyName: companyName,
        companyWebsite: companyWebsite,
        jobTitle: jobTitle,
        isEnterprise: isEnterprise,
        isBiometricEnabled: isBiometricEnabled,
        isAlertEnabled: isAlertEnabled,
      );

      emit(
        state.copyWith(
          model: profileModel,
          status: AppStatus.success,
        ),
      );
    } catch (e) {
      log.e('something went wrong', e);
      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_FAILED_TO_LOAD_PROFILE,
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
        SecureStorageKeys.issuerVerificationUrlKey,
        profileModel.issuerVerificationUrls.join(','),
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
        SecureStorageKeys.alertEnabled,
        profileModel.isAlertEnabled.toString(),
      );

      emit(
        state.copyWith(
          model: profileModel,
          status: AppStatus.success,
        ),
      );
    } catch (e) {
      log.e('something went wrong', e);

      emit(
        state.error(
          messageHandler: ResponseMessage(
            ResponseString.RESPONSE_STRING_FAILED_TO_SAVE_PROFILE,
          ),
        ),
      );
    }
  }

  Future<void> setFingerprintEnabled({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isBiometricEnabled: enabled);
    await update(profileModel);
  }

  Future<void> setAlertEnabled({bool enabled = false}) async {
    final profileModel = state.model.copyWith(isAlertEnabled: enabled);
    await update(profileModel);
  }

  Future<void> updateIssuerVerificationUrl(
    IssuerVerificationRegistry registry,
  ) async {
    final selectedIssuerUrls = state.model.issuerVerificationUrls;
    switch (registry) {
      case IssuerVerificationRegistry.PolygonMainnet:
        selectedIssuerUrls.remove(Urls.checkIssuerPolygonTestnetUrl);
        selectedIssuerUrls.add(Urls.checkIssuerPolygonUrl);
        break;
      case IssuerVerificationRegistry.EBSI:
        selectedIssuerUrls.add(Urls.checkIssuerEbsiUrl);
        break;
      case IssuerVerificationRegistry.PolygonTestnet:
        selectedIssuerUrls.remove(Urls.checkIssuerPolygonUrl);
        selectedIssuerUrls.add(Urls.checkIssuerPolygonTestnetUrl);
        break;
    }
    final profileModel =
        state.model.copyWith(issuerVerificationUrls: selectedIssuerUrls);
    await update(profileModel);
  }

  @override
  Future<void> close() async {
    _timer?.cancel();
    return super.close();
  }
}
