// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arago_identity_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AragoIdentityCardModel _$AragoIdentityCardModelFromJson(
        Map<String, dynamic> json) =>
    AragoIdentityCardModel(
      familyName: json['familyName'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
      bithPlace: json['bithPlace'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      addressCountry: json['addressCountry'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      id: json['id'] as String?,
      type: json['type'],
    );

Map<String, dynamic> _$AragoIdentityCardModelToJson(
        AragoIdentityCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'birthDate': instance.birthDate,
      'bithPlace': instance.bithPlace,
      'addressCountry': instance.addressCountry,
    };
