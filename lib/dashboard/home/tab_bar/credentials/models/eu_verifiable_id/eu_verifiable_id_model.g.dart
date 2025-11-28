// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eu_verifiable_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EUVerifiableIdModel _$EUVerifiableIdModelFromJson(Map<String, dynamic> json) =>
    EUVerifiableIdModel(
      expires: json['expires'] as String? ?? '',
      awardingOpportunity: json['awardingOpportunity'] == null
          ? null
          : AwardingOpportunity.fromJson(
              json['awardingOpportunity'] as Map<String, dynamic>),
      dateOfBirth: json['dateOfBirth'] as String? ?? '',
      familyName: json['familyName'] as String? ?? '',
      givenNames: json['givenNames'] as String? ?? '',
      gradingScheme: json['gradingScheme'] == null
          ? null
          : GradingScheme.fromJson(
              json['gradingScheme'] as Map<String, dynamic>),
      identifier: json['identifier'] as String? ?? '',
      learningAchievement: json['learningAchievement'] == null
          ? null
          : LearningAchievement.fromJson(
              json['learningAchievement'] as Map<String, dynamic>),
      learningSpecification: json['learningSpecification'] == null
          ? null
          : LearningSpecification.fromJson(
              json['learningSpecification'] as Map<String, dynamic>),
      id: json['id'] as String?,
      type: json['type'],
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$EUVerifiableIdModelToJson(EUVerifiableIdModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'issuedBy': instance.issuedBy?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('offeredBy', instance.offeredBy?.toJson());
  val['expires'] = instance.expires;
  val['awardingOpportunity'] = instance.awardingOpportunity?.toJson();
  val['dateOfBirth'] = instance.dateOfBirth;
  val['familyName'] = instance.familyName;
  val['givenNames'] = instance.givenNames;
  val['gradingScheme'] = instance.gradingScheme?.toJson();
  val['identifier'] = instance.identifier;
  val['learningAchievement'] = instance.learningAchievement?.toJson();
  val['learningSpecification'] = instance.learningSpecification?.toJson();
  return val;
}
