// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'phone_pass_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhonePassModel _$PhonePassModelFromJson(Map<String, dynamic> json) =>
    PhonePassModel(
      expires: json['expires'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$PhonePassModelToJson(PhonePassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'expires': instance.expires,
      'phone': instance.phone,
    };
