// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over13_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over13Model _$Over13ModelFromJson(Map<String, dynamic> json) => Over13Model(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$Over13ModelToJson(Over13Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
