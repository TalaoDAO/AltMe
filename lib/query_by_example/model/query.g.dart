// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Query _$QueryFromJson(Map<String, dynamic> json) => Query(
      type: json['type'] as String? ?? '',
      credentialQuery: (json['credentialQuery'] as List<dynamic>?)
              ?.map((e) => CredentialQuery.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{
      'type': instance.type,
      'credentialQuery':
          instance.credentialQuery.map((e) => e.toJson()).toList(),
    };
