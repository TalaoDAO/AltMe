// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnboardingState _$OnboardingStateFromJson(Map<String, dynamic> json) =>
    OnboardingState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
    );

Map<String, dynamic> _$OnboardingStateToJson(OnboardingState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
    };

const _$AppStatusEnumMap = {
  AppStatus.init: 'init',
  AppStatus.fetching: 'fetching',
  AppStatus.loading: 'loading',
  AppStatus.populate: 'populate',
  AppStatus.error: 'error',
  AppStatus.errorWhileFetching: 'errorWhileFetching',
  AppStatus.success: 'success',
  AppStatus.idle: 'idle',
  AppStatus.goBack: 'goBack',
  AppStatus.revoked: 'revoked',
  AppStatus.addEnterpriseAccount: 'addEnterpriseAccount',
  AppStatus.updateEnterpriseAccount: 'updateEnterpriseAccount',
  AppStatus.replaceEnterpriseAccount: 'replaceEnterpriseAccount',
  AppStatus.restoreWallet: 'restoreWallet',
  AppStatus.successAdd: 'successAdd',
  AppStatus.successUpdate: 'successUpdate',
  AppStatus.addEuropeanProfile: 'addEuropeanProfile',
};
