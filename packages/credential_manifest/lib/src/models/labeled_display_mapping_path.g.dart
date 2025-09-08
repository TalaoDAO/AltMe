// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labeled_display_mapping_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabeledDisplayMappingPath _$LabeledDisplayMappingPathFromJson(
        Map<String, dynamic> json) =>
    LabeledDisplayMappingPath(
      (json['path'] as List<dynamic>).map((e) => e as String).toList(),
      Schema.fromJson(json['schema'] as Map<String, dynamic>),
      json['fallback'] as String?,
      json['label'] as String,
    );

Map<String, dynamic> _$LabeledDisplayMappingPathToJson(
        LabeledDisplayMappingPath instance) =>
    <String, dynamic>{
      'label': instance.label,
      'path': instance.path,
      'schema': instance.schema.toJson(),
      'fallback': instance.fallback,
    };
