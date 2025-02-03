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

Map<String, dynamic> _$EUVerifiableIdModelToJson(
        EUVerifiableIdModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'expires': instance.expires,
      'awardingOpportunity': instance.awardingOpportunity?.toJson(),
      'dateOfBirth': instance.dateOfBirth,
      'familyName': instance.familyName,
      'givenNames': instance.givenNames,
      'gradingScheme': instance.gradingScheme?.toJson(),
      'identifier': instance.identifier,
      'learningAchievement': instance.learningAchievement?.toJson(),
      'learningSpecification': instance.learningSpecification?.toJson(),
    };
