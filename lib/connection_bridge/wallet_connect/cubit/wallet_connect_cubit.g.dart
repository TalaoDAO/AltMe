// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_connect_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletConnectState _$WalletConnectStateFromJson(Map<String, dynamic> json) =>
    WalletConnectState(
      status:
          $enumDecodeNullable(_$WalletConnectStatusEnumMap, json['status']) ??
          WalletConnectStatus.init,
      message: json['message'] == null
          ? null
          : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
      sessionTopic: json['sessionTopic'] as String?,
      parameters: json['parameters'],
      signType: json['signType'] as String?,
      operationDetails: (json['operationDetails'] as List<dynamic>?)
          ?.map((e) => OperationDetails.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WalletConnectStateToJson(WalletConnectState instance) =>
    <String, dynamic>{
      'status': _$WalletConnectStatusEnumMap[instance.status],
      'message': instance.message,
      'sessionTopic': instance.sessionTopic,
      'parameters': instance.parameters,
      'signType': instance.signType,
      'operationDetails': instance.operationDetails,
    };

const _$WalletConnectStatusEnumMap = {
  WalletConnectStatus.init: 'init',
  WalletConnectStatus.loading: 'loading',
  WalletConnectStatus.error: 'error',
  WalletConnectStatus.success: 'success',
  WalletConnectStatus.idle: 'idle',
  WalletConnectStatus.permission: 'permission',
  WalletConnectStatus.signPayload: 'signPayload',
  WalletConnectStatus.operation: 'operation',
};
