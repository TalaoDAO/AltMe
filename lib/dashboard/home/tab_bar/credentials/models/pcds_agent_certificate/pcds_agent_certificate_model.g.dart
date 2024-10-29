// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pcds_agent_certificate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PcdsAgentCertificateModel _$PcdsAgentCertificateModelFromJson(
        Map<String, dynamic> json) =>
    PcdsAgentCertificateModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      identifier: json['identifier'] as String? ?? '',
    );

Map<String, dynamic> _$PcdsAgentCertificateModelToJson(
    PcdsAgentCertificateModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'issuedBy': instance.issuedBy?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('offeredBy', instance.offeredBy?.toJson());
  val['identifier'] = instance.identifier;
  return val;
}
