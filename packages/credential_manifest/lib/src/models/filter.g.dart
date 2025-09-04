// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Filter _$FilterFromJson(Map<String, dynamic> json) => Filter(
  type: json['type'] as String,
  pattern: json['pattern'] as String?,
  contains: json['contains'] == null
      ? null
      : Contains.fromJson(json['contains'] as Map<String, dynamic>),
  containsConst: json['const'] as String?,
);

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
  'type': instance.type,
  'pattern': instance.pattern,
  'contains': instance.contains?.toJson(),
  'const': instance.containsConst,
};
