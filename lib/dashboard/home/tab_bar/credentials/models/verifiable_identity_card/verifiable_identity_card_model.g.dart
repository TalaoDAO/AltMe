// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verifiable_identity_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifiableIdCardModel _$VerifiableIdCardModelFromJson(
        Map<String, dynamic> json) =>
    VerifiableIdCardModel(
      familyName: json['familyName'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      bithPlace: json['bithPlace'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      addressCountry: json['addressCountry'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      id: json['id'] as String?,
      type: json['type'],
    );

Map<String, dynamic> _$VerifiableIdCardModelToJson(
        VerifiableIdCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'familyName': instance.familyName,
      'firstName': instance.firstName,
      'birthDate': instance.birthDate,
      'dateOfBirth': instance.dateOfBirth,
      'bithPlace': instance.bithPlace,
      'addressCountry': instance.addressCountry,
    };
