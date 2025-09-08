// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pcds_agent_certificate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PcdsAgentCertificateModel _$PcdsAgentCertificateModelFromJson(
        Map<String, dynamic> json) =>
    PcdsAgentCertificateModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      identifier: json['identifier'] as String? ?? '',
    );

Map<String, dynamic> _$PcdsAgentCertificateModelToJson(
        PcdsAgentCertificateModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'identifier': instance.identifier,
    };
