// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beacon_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeaconState _$BeaconStateFromJson(Map<String, dynamic> json) => BeaconState(
  status:
      $enumDecodeNullable(_$BeaconStatusEnumMap, json['status']) ??
      BeaconStatus.init,
  isBeaconStarted: json['isBeaconStarted'] as bool? ?? false,
  beaconRequest: json['beaconRequest'] == null
      ? null
      : BeaconRequest.fromJson(json['beaconRequest'] as Map<String, dynamic>),
  message: json['message'] == null
      ? null
      : StateMessage.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$BeaconStateToJson(BeaconState instance) =>
    <String, dynamic>{
      'status': _$BeaconStatusEnumMap[instance.status],
      'message': instance.message,
      'beaconRequest': instance.beaconRequest,
      'isBeaconStarted': instance.isBeaconStarted,
    };

const _$BeaconStatusEnumMap = {
  BeaconStatus.init: 'init',
  BeaconStatus.loading: 'loading',
  BeaconStatus.error: 'error',
  BeaconStatus.success: 'success',
  BeaconStatus.idle: 'idle',
  BeaconStatus.permission: 'permission',
  BeaconStatus.signPayload: 'signPayload',
  BeaconStatus.operation: 'operation',
  BeaconStatus.broadcast: 'broadcast',
};
