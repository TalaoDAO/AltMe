// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defi_compliance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DefiComplianceModel _$DefiComplianceModelFromJson(Map<String, dynamic> json) =>
    DefiComplianceModel(
      expires: json['expires'] as String? ?? '',
      ageCheck: json['ageCheck'] as String? ?? '',
      amlComplianceCheck: json['amlComplianceCheck'] as String? ?? '',
      sanctionListCheck: json['sanctionListCheck'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$DefiComplianceModelToJson(DefiComplianceModel instance) {
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
  val['expires'] = instance.expires;
  val['ageCheck'] = instance.ageCheck;
  val['amlComplianceCheck'] = instance.amlComplianceCheck;
  val['sanctionListCheck'] = instance.sanctionListCheck;
  return val;
}
