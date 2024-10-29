// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'output_descriptor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OutputDescriptor _$OutputDescriptorFromJson(Map<String, dynamic> json) =>
    OutputDescriptor(
      json['id'] as String,
      json['schema'] as String,
      json['name'] as String?,
      json['description'] as String?,
      json['styles'] == null
          ? null
          : Styles.fromJson(json['styles'] as Map<String, dynamic>),
      json['display'] == null
          ? null
          : DisplayObject.fromJson(json['display'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OutputDescriptorToJson(OutputDescriptor instance) =>
    <String, dynamic>{
      'id': instance.id,
      'schema': instance.schema,
      'name': instance.name,
      'description': instance.description,
      'styles': instance.styles?.toJson(),
      'display': instance.display?.toJson(),
    };
