// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'protocol_trace_logs_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProtocolTraceLogsState _$ProtocolTraceLogsStateFromJson(
  Map<String, dynamic> json,
) => ProtocolTraceLogsState(
  status:
      $enumDecodeNullable(_$AppStatusEnumMap, json['status']) ?? AppStatus.init,
  filePaths:
      (json['filePaths'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ProtocolTraceLogsStateToJson(
  ProtocolTraceLogsState instance,
) => <String, dynamic>{
  'status': _$AppStatusEnumMap[instance.status]!,
  'filePaths': instance.filePaths,
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
