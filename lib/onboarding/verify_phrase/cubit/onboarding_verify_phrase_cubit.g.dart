// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_verify_phrase_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OnBoardingVerifyPhraseState _$OnBoardingVerifyPhraseStateFromJson(
        Map<String, dynamic> json) =>
    OnBoardingVerifyPhraseState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      isVerified: json['isVerified'] as bool? ?? false,
      mnemonicStates: (json['mnemonicStates'] as List<dynamic>?)
          ?.map((e) => MnemonicState.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$OnBoardingVerifyPhraseStateToJson(
        OnBoardingVerifyPhraseState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'isVerified': instance.isVerified,
      'mnemonicStates': instance.mnemonicStates,
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
  AppStatus.addInjiProfile: 'addInjiProfile',
};

MnemonicState _$MnemonicStateFromJson(Map<String, dynamic> json) =>
    MnemonicState(
      mnemonicStatus: $enumDecodeNullable(
              _$MnemonicStatusEnumMap, json['mnemonicStatus']) ??
          MnemonicStatus.unselected,
      order: (json['order'] as num).toInt(),
      userSelectedOrder: (json['userSelectedOrder'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MnemonicStateToJson(MnemonicState instance) =>
    <String, dynamic>{
      'mnemonicStatus': _$MnemonicStatusEnumMap[instance.mnemonicStatus]!,
      'order': instance.order,
      'userSelectedOrder': instance.userSelectedOrder,
    };

const _$MnemonicStatusEnumMap = {
  MnemonicStatus.unselected: 'unselected',
  MnemonicStatus.selected: 'selected',
};
