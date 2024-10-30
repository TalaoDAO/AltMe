// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Example _$ExampleFromJson(Map<String, dynamic> json) => Example(
      type: json['type'] as String?,
      trustedIssuer: (json['trustedIssuer'] as List<dynamic>?)
          ?.map((e) => ExampleIssuer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExampleToJson(Example instance) => <String, dynamic>{
      'type': instance.type,
      'trustedIssuer': instance.trustedIssuer?.map((e) => e.toJson()).toList(),
    };
