// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'format_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormatType _$FormatTypeFromJson(Map<String, dynamic> json) => FormatType(
      proofType: (json['proof_type'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$FormatTypeToJson(FormatType instance) =>
    <String, dynamic>{
      'proof_type': instance.proofType,
    };
