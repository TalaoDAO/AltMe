// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'evidence.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Evidence _$EvidenceFromJson(Map<String, dynamic> json) => Evidence(
      json['id'] as String? ?? '',
      (json['type'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
    );

Map<String, dynamic> _$EvidenceToJson(Evidence instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
    };
