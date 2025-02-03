// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'learning_achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LearningAchievementModel _$LearningAchievementModelFromJson(
        Map<String, dynamic> json) =>
    LearningAchievementModel(
      id: json['id'] as String?,
      type: json['type'],
      familyName: json['familyName'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      birthDate: json['birthDate'] as String? ?? '',
      hasCredential: json['hasCredential'] == null
          ? null
          : HasCredential.fromJson(
              json['hasCredential'] as Map<String, dynamic>),
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$LearningAchievementModelToJson(
        LearningAchievementModel instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.type case final value?) 'type': value,
      if (instance.issuedBy?.toJson() case final value?) 'issuedBy': value,
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      if (instance.familyName case final value?) 'familyName': value,
      if (instance.givenName case final value?) 'givenName': value,
      if (instance.email case final value?) 'email': value,
      if (instance.birthDate case final value?) 'birthDate': value,
      if (instance.hasCredential?.toJson() case final value?)
        'hasCredential': value,
    };
