// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'confirm_connection_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfirmConnectionState _$ConfirmConnectionStateFromJson(
  Map<String, dynamic> json,
) => ConfirmConnectionState(
  status:
      $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ?? AppStatus.init,
  message: json['message'] == null
      ? null
      : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ConfirmConnectionStateToJson(
  ConfirmConnectionState instance,
) => <String, dynamic>{
  'status': _$AppStatusEnumMap[instance.status]!,
  'message': instance.message,
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
