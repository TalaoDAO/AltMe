// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_student_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalStudentCardModel _$ProfessionalStudentCardModelFromJson(
        Map<String, dynamic> json) =>
    ProfessionalStudentCardModel(
      recipient: json['recipient'] == null
          ? null
          : ProfessionalStudentCardRecipient.fromJson(
              json['recipient'] as Map<String, dynamic>),
      expires: json['expires'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$ProfessionalStudentCardModelToJson(
        ProfessionalStudentCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'recipient': instance.recipient?.toJson(),
      'expires': instance.expires,
    };
