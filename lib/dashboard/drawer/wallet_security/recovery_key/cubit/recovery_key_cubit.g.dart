// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recovery_key_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecoveryKeyState _$RecoveryKeyStateFromJson(Map<String, dynamic> json) =>
    RecoveryKeyState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      mnemonics: (json['mnemonics'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      hasVerifiedMnemonics: json['hasVerifiedMnemonics'] as bool? ?? false,
    );

Map<String, dynamic> _$RecoveryKeyStateToJson(RecoveryKeyState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'mnemonics': instance.mnemonics,
      'hasVerifiedMnemonics': instance.hasVerifiedMnemonics,
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
