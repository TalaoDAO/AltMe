// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restore_credential_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestoreCredentialState _$RestoreCredentialStateFromJson(
        Map<String, dynamic> json) =>
    RestoreCredentialState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      recoveredCredentialLength:
          (json['recoveredCredentialLength'] as num?)?.toInt(),
      backupFilePath: json['backupFilePath'] as String?,
    );

Map<String, dynamic> _$RestoreCredentialStateToJson(
        RestoreCredentialState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'recoveredCredentialLength': instance.recoveredCredentialLength,
      'backupFilePath': instance.backupFilePath,
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
