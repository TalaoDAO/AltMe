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
      type: json['type'] ?? 'SelfIssued',
      telephone: json['telephone'] as String?,
      email: json['email'] as String?,
      workFor: json['workFor'] as String?,
      companyWebsite: json['companyWebsite'] as String?,
      jobTitle: json['jobTitle'] as String?,
    );

Map<String, dynamic> _$SelfIssuedModelToJson(SelfIssuedModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.type case final value?) 'type': value,
      if (instance.address case final value?) 'address': value,
      if (instance.familyName case final value?) 'familyName': value,
      if (instance.givenName case final value?) 'givenName': value,
      if (instance.telephone case final value?) 'telephone': value,
      if (instance.email case final value?) 'email': value,
      if (instance.workFor case final value?) 'workFor': value,
      if (instance.companyWebsite case final value?) 'companyWebsite': value,
      if (instance.jobTitle case final value?) 'jobTitle': value,
    };
