// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display_mapping_path.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DisplayMappingPath _$DisplayMappingPathFromJson(Map<String, dynamic> json) =>
    DisplayMappingPath(
      (json['path'] as List<dynamic>).map((e) => e as String).toList(),
      Schema.fromJson(json['schema'] as Map<String, dynamic>),
      json['fallback'] as String?,
    );

Map<String, dynamic> _$DisplayMappingPathToJson(DisplayMappingPath instance) =>
    <String, dynamic>{
      'path': instance.path,
      'schema': instance.schema.toJson(),
      'fallback': instance.fallback,
    };
