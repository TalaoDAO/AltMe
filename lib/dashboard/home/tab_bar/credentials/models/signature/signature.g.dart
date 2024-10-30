// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Signature _$SignatureFromJson(Map<String, dynamic> json) => Signature(
      json['image'] as String? ?? '',
      json['jobTitle'] as String? ?? '',
      json['name'] as String? ?? '',
    );

Map<String, dynamic> _$SignatureToJson(Signature instance) => <String, dynamic>{
      'image': instance.image,
      'jobTitle': instance.jobTitle,
      'name': instance.name,
    };
