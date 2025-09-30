// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_card_recipient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentCardRecipient _$StudentCardRecipientFromJson(
        Map<String, dynamic> json) =>
    StudentCardRecipient(
      json['email'] as String? ?? '',
      json['image'] as String? ?? '',
      json['telephone'] as String? ?? '',
      json['familyName'] as String? ?? '',
      json['address'] as String? ?? '',
      json['birthDate'] as String? ?? '',
      json['givenName'] as String? ?? '',
      json['gender'] as String? ?? '',
      json['jobTitle'] as String? ?? '',
    );

Map<String, dynamic> _$StudentCardRecipientToJson(
        StudentCardRecipient instance) =>
    <String, dynamic>{
      'email': instance.email,
      'image': instance.image,
      'telephone': instance.telephone,
      'familyName': instance.familyName,
      'address': instance.address,
      'birthDate': instance.birthDate,
      'givenName': instance.givenName,
      'gender': instance.gender,
      'jobTitle': instance.jobTitle,
    };
