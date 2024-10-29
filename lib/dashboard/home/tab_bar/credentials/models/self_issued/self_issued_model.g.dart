// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'self_issued_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SelfIssuedModel _$SelfIssuedModelFromJson(Map<String, dynamic> json) =>
    SelfIssuedModel(
      id: json['id'] as String,
      address: json['address'] as String?,
      familyName: json['familyName'] as String?,
      givenName: json['givenName'] as String?,
      type: json['type'] as String? ?? 'SelfIssued',
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      workFor: json['workFor'] as String?,
      companyWebsite: json['companyWebsite'] as String?,
      jobTitle: json['jobTitle'] as String?,
    );

Map<String, dynamic> _$SelfIssuedModelToJson(SelfIssuedModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('type', instance.type);
  writeNotNull('address', instance.address);
  writeNotNull('familyName', instance.familyName);
  writeNotNull('givenName', instance.givenName);
  writeNotNull('telephone', instance.telephone);
  writeNotNull('email', instance.email);
  writeNotNull('workFor', instance.workFor);
  writeNotNull('companyWebsite', instance.companyWebsite);
  writeNotNull('jobTitle', instance.jobTitle);
  return val;
}
