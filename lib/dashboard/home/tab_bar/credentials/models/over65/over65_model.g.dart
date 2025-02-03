// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over65_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over65Model _$Over65ModelFromJson(Map<String, dynamic> json) => Over65Model(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$Over65ModelToJson(Over65Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
