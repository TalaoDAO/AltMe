// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arago_over18_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AragoOver18Model _$AragoOver18ModelFromJson(Map<String, dynamic> json) =>
    AragoOver18Model(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$AragoOver18ModelToJson(AragoOver18Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
