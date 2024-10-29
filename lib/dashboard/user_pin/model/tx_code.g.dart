// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tx_code.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TxCode _$TxCodeFromJson(Map<String, dynamic> json) => TxCode(
      length: (json['length'] as num).toInt(),
      inputMode: json['input_mode'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$TxCodeToJson(TxCode instance) => <String, dynamic>{
      'length': instance.length,
      'input_mode': instance.inputMode,
      'description': instance.description,
    };
