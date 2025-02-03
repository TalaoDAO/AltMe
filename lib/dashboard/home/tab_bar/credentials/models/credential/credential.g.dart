// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Credential _$CredentialFromJson(Map<String, dynamic> json) => Credential(
      Credential.fromJsonId(json['id']),
      json['@context'] as List<dynamic>?,
      (json['type'] as List<dynamic>).map((e) => e as String).toList(),
      json['issuer'],
      json['expirationDate'] as String? ?? '',
      json['issuanceDate'] as String? ?? '',
      Credential._fromJsonProofs(json['proof']),
      CredentialSubjectModel.fromJson(
          json['credentialSubject'] as Map<String, dynamic>),
      Credential._fromJsonTranslations(json['description']),
      json['name'] == null
          ? []
          : Credential._fromJsonTranslations(json['name']),
      json['credentialStatus'],
      Credential._fromJsonEvidence(json['evidence']),
    );

Map<String, dynamic> _$CredentialToJson(Credential instance) =>
    <String, dynamic>{
      'id': instance.id,
      '@context': instance.context,
      'type': instance.type,
      'issuer': instance.issuer,
      'description': instance.description.map((e) => e.toJson()).toList(),
      'name': instance.name.map((e) => e.toJson()).toList(),
      'expirationDate': instance.expirationDate,
      'issuanceDate': instance.issuanceDate,
      'proof': instance.proof.map((e) => e.toJson()).toList(),
      'credentialSubject': instance.credentialSubjectModel.toJson(),
      'evidence': instance.evidence.map((e) => e.toJson()).toList(),
      'credentialStatus': instance.credentialStatus,
    };
