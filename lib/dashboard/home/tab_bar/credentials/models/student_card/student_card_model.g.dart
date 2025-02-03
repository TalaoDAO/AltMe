// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCardModel _$StudentCardModelFromJson(Map<String, dynamic> json) =>
    StudentCardModel(
      recipient: StudentCardModel._fromJsonProfessionalStudentCardRecipient(
          json['recipient']),
      expires: json['expires'] as String? ?? '',
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$StudentCardModelToJson(StudentCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'recipient': instance.recipient?.toJson(),
      'expires': instance.expires,
    };
