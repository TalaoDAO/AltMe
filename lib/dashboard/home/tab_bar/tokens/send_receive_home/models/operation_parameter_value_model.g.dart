// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_parameter_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationParameterValueModel _$OperationParameterValueModelFromJson(
        Map<String, dynamic> json) =>
    OperationParameterValueModel(
      to: json['to'] as String?,
      from: json['from'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$OperationParameterValueModelToJson(
        OperationParameterValueModel instance) =>
    <String, dynamic>{
      'to': instance.to,
      'from': instance.from,
      'value': instance.value,
    };
