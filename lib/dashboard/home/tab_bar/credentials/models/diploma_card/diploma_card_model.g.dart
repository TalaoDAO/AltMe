// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diploma_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiplomaCardModel _$DiplomaCardModelFromJson(Map<String, dynamic> json) =>
    DiplomaCardModel(
      familyName: json['familyName'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
      programName: json['programName'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      identifier: json['identifier'] as String? ?? '',
    );

Map<String, dynamic> _$DiplomaCardModelToJson(DiplomaCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'identifier': instance.identifier,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'programName': instance.programName,
    };
