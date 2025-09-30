// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'state_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StateMessage _$StateMessageFromJson(Map<String, dynamic> json) => StateMessage(
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.error,
      stringMessage: json['stringMessage'] as String?,
      injectedMessage: json['injectedMessage'] as String?,
      showDialog: json['showDialog'] as bool? ?? false,
      duration: json['duration'] == null
          ? const Duration(milliseconds: 2 * 800)
          : Duration(microseconds: (json['duration'] as num).toInt()),
    );

Map<String, dynamic> _$StateMessageToJson(StateMessage instance) =>
    <String, dynamic>{
      'type': _$MessageTypeEnumMap[instance.type]!,
      'stringMessage': instance.stringMessage,
      'injectedMessage': instance.injectedMessage,
      'showDialog': instance.showDialog,
      'duration': instance.duration.inMicroseconds,
    };

const _$MessageTypeEnumMap = {
  MessageType.error: 'error',
  MessageType.warning: 'warning',
  MessageType.info: 'info',
  MessageType.success: 'success',
};
