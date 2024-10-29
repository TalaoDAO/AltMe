// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_country_of_residence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KYCCountryOfResidenceModel _$KYCCountryOfResidenceModelFromJson(
        Map<String, dynamic> json) =>
    KYCCountryOfResidenceModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      countryCode: (json['countryCode'] as num?)?.toInt(),
      documentType: (json['documentType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$KYCCountryOfResidenceModelToJson(
    KYCCountryOfResidenceModel instance) {
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
  val['countryCode'] = instance.countryCode;
  val['documentType'] = instance.documentType;
  return val;
}
