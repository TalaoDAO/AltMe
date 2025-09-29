// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_code_scan_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRCodeScanState _$QRCodeScanStateFromJson(Map<String, dynamic> json) =>
    QRCodeScanState(
      status:
          $enumDecodeNullable(_$QrScanStatusEnumMap, json['status']) ??
          QrScanStatus.init,
      uri: json['uri'] == null ? null : Uri.parse(json['uri'] as String),
      isScan: json['isScan'] as bool? ?? false,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      dialogData: json['dialogData'] as String?,
    );

Map<String, dynamic> _$QRCodeScanStateToJson(QRCodeScanState instance) =>
    <String, dynamic>{
      'status': _$QrScanStatusEnumMap[instance.status]!,
      'uri': instance.uri?.toString(),
      'isScan': instance.isScan,
      'message': instance.message,
      'dialogData': instance.dialogData,
    };

const _$QrScanStatusEnumMap = {
  QrScanStatus.init: 'init',
  QrScanStatus.idle: 'idle',
  QrScanStatus.loading: 'loading',
  QrScanStatus.acceptHost: 'acceptHost',
  QrScanStatus.authorizationFlow: 'authorizationFlow',
  QrScanStatus.siopV2: 'siopV2',
  QrScanStatus.error: 'error',
  QrScanStatus.success: 'success',
  QrScanStatus.goBack: 'goBack',
  QrScanStatus.pauseForDialog: 'pauseForDialog',
  QrScanStatus.pauseForDisplay: 'pauseForDisplay',
};
