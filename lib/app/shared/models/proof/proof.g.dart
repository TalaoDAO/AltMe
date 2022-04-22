// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proof.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Proof _$ProofFromJson(Map<String, dynamic> json) => Proof(
      json['type'] as String,
      json['proofPurpose'] as String,
      json['verificationMethod'] as String,
      json['created'] as String,
      json['jws'] as String,
    );

Map<String, dynamic> _$ProofToJson(Proof instance) => <String, dynamic>{
      'type': instance.type,
      'proofPurpose': instance.proofPurpose,
      'verificationMethod': instance.verificationMethod,
      'created': instance.created,
      'jws': instance.jws,
    };
