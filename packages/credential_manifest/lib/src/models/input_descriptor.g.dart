// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_descriptor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InputDescriptor _$InputDescriptorFromJson(Map<String, dynamic> json) =>
    InputDescriptor(
      id: json['id'] as String?,
      group:
          (json['group'] as List<dynamic>?)?.map((e) => e as String).toList(),
      constraints: json['constraints'] == null
          ? null
          : Constraints.fromJson(json['constraints'] as Map<String, dynamic>),
      purpose: json['purpose'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$InputDescriptorToJson(InputDescriptor instance) =>
    <String, dynamic>{
      'constraints': instance.constraints?.toJson(),
      'group': instance.group,
      'purpose': instance.purpose,
      'id': instance.id,
      'name': instance.name,
    };
