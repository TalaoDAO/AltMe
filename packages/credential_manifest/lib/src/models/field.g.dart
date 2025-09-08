// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Field _$FieldFromJson(Map<String, dynamic> json) => Field(
  path: (json['path'] as List<dynamic>).map((e) => e as String).toList(),
  filter: json['filter'] == null
      ? null
      : Filter.fromJson(json['filter'] as Map<String, dynamic>),
  optional: json['optional'] as bool? ?? false,
);

Map<String, dynamic> _$FieldToJson(Field instance) => <String, dynamic>{
  'path': instance.path,
  'filter': instance.filter?.toJson(),
  'optional': instance.optional,
};
