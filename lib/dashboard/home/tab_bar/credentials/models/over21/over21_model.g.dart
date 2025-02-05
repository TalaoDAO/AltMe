// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over21_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over21Model _$Over21ModelFromJson(Map<String, dynamic> json) => Over21Model(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$Over21ModelToJson(Over21Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
