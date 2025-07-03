// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_credential_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackupCredentialState _$BackupCredentialStateFromJson(
        Map<String, dynamic> json) =>
    BackupCredentialState(
      status: $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ??
          AppStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      filePath: json['filePath'] as String? ?? '',
    );

Map<String, dynamic> _$BackupCredentialStateToJson(
        BackupCredentialState instance) =>
    <String, dynamic>{
      'status': _$AppStatusEnumMap[instance.status]!,
      'message': instance.message,
      'filePath': instance.filePath,
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
