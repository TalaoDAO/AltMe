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
      'id': ?instance.id,
      'type': ?instance.type,
      'address': ?instance.address,
      'familyName': ?instance.familyName,
      'givenName': ?instance.givenName,
      'telephone': ?instance.telephone,
      'email': ?instance.email,
      'workFor': ?instance.workFor,
      'companyWebsite': ?instance.companyWebsite,
      'jobTitle': ?instance.jobTitle,
    };
