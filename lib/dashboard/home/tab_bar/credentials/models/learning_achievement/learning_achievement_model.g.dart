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
) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('type', instance.type);
  writeNotNull('issuedBy', instance.issuedBy?.toJson());
  writeNotNull('offeredBy', instance.offeredBy?.toJson());
  writeNotNull('familyName', instance.familyName);
  writeNotNull('givenName', instance.givenName);
  writeNotNull('email', instance.email);
  writeNotNull('birthDate', instance.birthDate);
  writeNotNull('hasCredential', instance.hasCredential?.toJson());
  return val;
}
