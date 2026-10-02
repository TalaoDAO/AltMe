// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'camera_cubit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CameraState _$CameraStateFromJson(Map<String, dynamic> json) => CameraState(
  status:
      $enumDecodeNullable(_$CameraStatusEnumMap, json['status']) ??
      CameraStatus.initializing,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => (e as num).toInt())
      .toList(),
  acquiredCredentialsQuantity:
      (json['acquiredCredentialsQuantity'] as num?)?.toInt() ?? 0,
  ageEstimate: json['ageEstimate'] as String? ?? '',
);

Map<String, dynamic> _$CameraStateToJson(CameraState instance) =>
    <String, dynamic>{
      'status': _$CameraStatusEnumMap[instance.status]!,
      'data': instance.data,
      'acquiredCredentialsQuantity': instance.acquiredCredentialsQuantity,
      'ageEstimate': instance.ageEstimate,
    };

const _$CameraStatusEnumMap = {
  CameraStatus.initializing: 'initializing',
  CameraStatus.intialized: 'intialized',
  CameraStatus.initializeFailed: 'initializeFailed',
  CameraStatus.loading: 'loading',
  CameraStatus.imageCaptured: 'imageCaptured',
  CameraStatus.error: 'error',
};
