// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nationality_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NationalityModel _$NationalityModelFromJson(Map<String, dynamic> json) =>
    NationalityModel(
      expires: json['expires'] as String? ?? '',
      nationality: json['nationality'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
    );

Map<String, dynamic> _$NationalityModelToJson(NationalityModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      'expires': instance.expires,
      'nationality': instance.nationality,
    };
