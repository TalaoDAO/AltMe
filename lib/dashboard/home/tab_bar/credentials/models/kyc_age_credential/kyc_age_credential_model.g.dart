// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_age_credential_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KYCAgeCredentialModel _$KYCAgeCredentialModelFromJson(
        Map<String, dynamic> json) =>
    KYCAgeCredentialModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      birthday: (json['birthday'] as num?)?.toInt(),
      documentType: (json['documentType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KYCAgeCredentialModelToJson(
    KYCAgeCredentialModel instance) {
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
  val['birthday'] = instance.birthday;
  val['documentType'] = instance.documentType;
  return val;
}
