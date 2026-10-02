// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation_parameter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OperationParameterModel _$OperationParameterModelFromJson(
  Map<String, dynamic> json,
) => OperationParameterModel(
  entrypoint: json['entrypoint'] as String,
  value: json['value'] == null
      ? null
      : OperationParameterValueModel.fromJson(
          json['value'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$OperationParameterModelToJson(
  OperationParameterModel instance,
) => <String, dynamic>{
  'entrypoint': instance.entrypoint,
  'value': instance.value,
};
