// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arago_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AragoPassModel _$AragoPassModelFromJson(Map<String, dynamic> json) =>
    AragoPassModel(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      identifier: json['identifier'] as String? ?? '',
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$AragoPassModelToJson(AragoPassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'identifier': instance.identifier,
    };
