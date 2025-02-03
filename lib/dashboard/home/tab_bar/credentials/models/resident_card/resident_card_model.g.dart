// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentCardModel _$ResidentCardModelFromJson(Map<String, dynamic> json) =>
    ResidentCardModel(
      id: json['id'] as String?,
      gender: json['gender'] as String? ?? '',
      maritalStatus: json['maritalStatus'] as String? ?? '',
      type: json['type'],
      birthPlace: json['birthPlace'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      address: json['address'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      familyName: json['familyName'] as String? ?? '',
      image: json['image'] as String? ?? '',
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      birthDate: json['birthDate'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
    );

Map<String, dynamic> _$ResidentCardModelToJson(ResidentCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'gender': instance.gender,
      'maritalStatus': instance.maritalStatus,
      'birthPlace': instance.birthPlace,
      'nationality': instance.nationality,
      'address': instance.address,
      'identifier': instance.identifier,
      'familyName': instance.familyName,
      'image': instance.image,
      'birthDate': instance.birthDate,
      'givenName': instance.givenName,
    };
