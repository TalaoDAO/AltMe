// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningAchievementModel _$LearningAchievementModelFromJson(
  Map<String, dynamic> json,
) => LearningAchievementModel(
  id: json['id'] as String?,
  type: json['type'],
  familyName: json['familyName'] as String? ?? '',
  givenName: json['givenName'] as String? ?? '',
  email: json['email'] as String? ?? '',
  birthDate: json['birthDate'] as String? ?? '',
  hasCredential: json['hasCredential'] == null
      ? null
      : HasCredential.fromJson(json['hasCredential'] as Map<String, dynamic>),
  issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
  offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
);

Map<String, dynamic> _$LearningAchievementModelToJson(
  LearningAchievementModel instance,
) => <String, dynamic>{
  'id': ?instance.id,
  'type': ?instance.type,
  'issuedBy': ?instance.issuedBy?.toJson(),
  'offeredBy': ?instance.offeredBy?.toJson(),
  'familyName': ?instance.familyName,
  'givenName': ?instance.givenName,
  'email': ?instance.email,
  'birthDate': ?instance.birthDate,
  'hasCredential': ?instance.hasCredential?.toJson(),
};
