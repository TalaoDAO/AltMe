// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanState _$ScanStateFromJson(Map<String, dynamic> json) => ScanState(
  status:
      $enumDecodeNullable(_$ScanStatusEnumMap, json['status']) ??
      ScanStatus.init,
  message: json['message'] == null
      ? null
      : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
  uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
  keyId: json['keyId'] as String?,
  challenge: json['challenge'] as String?,
  domain: json['domain'] as String?,
  transactionData: json['transactionData'] as List<dynamic>?,
);

Map<String, dynamic> _$ScanStateToJson(ScanState instance) => <String, dynamic>{
  'status': _$ScanStatusEnumMap[instance.status]!,
  'message': instance.message,
  'uri': instance.uri?.toString(),
  'keyId': instance.keyId,
  'challenge': instance.challenge,
  'domain': instance.domain,
  'transactionData': instance.transactionData,
};

const _$ScanStatusEnumMap = {
  ScanStatus.init: 'init',
  ScanStatus.loading: 'loading',
  ScanStatus.askPermissionDidAuth: 'askPermissionDidAuth',
  ScanStatus.error: 'error',
  ScanStatus.warning: 'warning',
  ScanStatus.success: 'success',
  ScanStatus.goBack: 'goBack',
};
