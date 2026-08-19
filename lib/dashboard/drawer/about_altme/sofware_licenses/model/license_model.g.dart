// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'license_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LicenseModel _$LicenseModelFromJson(Map<String, dynamic> json) => LicenseModel(
  json['title'] as String,
  (json['description'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$LicenseModelToJson(LicenseModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };
