// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trusted_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrustedList _$TrustedListFromJson(Map<String, dynamic> json) => TrustedList(
      ecosystem: json['ecosystem'] as String,
      lastUpdated: json['lastUpdated'] as String,
      entities: (json['entities'] as List<dynamic>)
          .map((e) => TrustedEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      uploadDateTime: json['uploadDateTime'] == null
          ? null
          : DateTime.parse(json['uploadDateTime'] as String),
    );

Map<String, dynamic> _$TrustedListToJson(TrustedList instance) =>
    <String, dynamic>{
      'ecosystem': instance.ecosystem,
      'lastUpdated': instance.lastUpdated,
      'entities': instance.entities.map((e) => e.toJson()).toList(),
      'uploadDateTime': instance.uploadDateTime?.toIso8601String(),
    };
