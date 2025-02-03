// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'over15_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Over15Model _$Over15ModelFromJson(Map<String, dynamic> json) => Over15Model(
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$Over15ModelToJson(Over15Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
    };
