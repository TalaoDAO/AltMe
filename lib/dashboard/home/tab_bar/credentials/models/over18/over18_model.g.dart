// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over18_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over18Model _$Over18ModelFromJson(Map<String, dynamic> json) => Over18Model(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$Over18ModelToJson(Over18Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
