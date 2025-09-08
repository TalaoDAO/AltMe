// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eu_diploma_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EUDiplomaCardModel _$EUDiplomaCardModelFromJson(Map<String, dynamic> json) =>
    EUDiplomaCardModel(
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

Map<String, dynamic> _$EUDiplomaCardModelToJson(EUDiplomaCardModel instance) =>
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

AwardingOpportunity _$AwardingOpportunityFromJson(Map<String, dynamic> json) =>
    AwardingOpportunity(
      awardingBody: json['awardingBody'] == null
          ? null
          : AwardingBody.fromJson(json['awardingBody'] as Map<String, dynamic>),
      endedAtTime: json['endedAtTime'] as String? ?? '',
      id: json['id'] as String? ?? '',
      identifier: json['identifier'] as String? ?? '',
      location: json['location'] as String? ?? '',
      startedAtTime: json['startedAtTime'] as String? ?? '',
    );

Map<String, dynamic> _$AwardingOpportunityToJson(
        AwardingOpportunity instance) =>
    <String, dynamic>{
      'awardingBody': instance.awardingBody?.toJson(),
      'endedAtTime': instance.endedAtTime,
      'id': instance.id,
      'identifier': instance.identifier,
      'location': instance.location,
      'startedAtTime': instance.startedAtTime,
    };

AwardingBody _$AwardingBodyFromJson(Map<String, dynamic> json) => AwardingBody(
      eidasLegalIdentifier: json['eidasLegalIdentifier'] as String? ?? '',
      homepage: json['homepage'] as String? ?? '',
      id: json['id'] as String? ?? '',
      preferredName: json['preferredName'] as String? ?? '',
      registration: json['registration'] as String? ?? '',
    );

Map<String, dynamic> _$AwardingBodyToJson(AwardingBody instance) =>
    <String, dynamic>{
      'eidasLegalIdentifier': instance.eidasLegalIdentifier,
      'homepage': instance.homepage,
      'id': instance.id,
      'preferredName': instance.preferredName,
      'registration': instance.registration,
    };

GradingScheme _$GradingSchemeFromJson(Map<String, dynamic> json) =>
    GradingScheme(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );

Map<String, dynamic> _$GradingSchemeToJson(GradingScheme instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
    };

LearningAchievement _$LearningAchievementFromJson(Map<String, dynamic> json) =>
    LearningAchievement(
      additionalNote: (json['additionalNote'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      description: json['description'] as String? ?? '',
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );

Map<String, dynamic> _$LearningAchievementToJson(
        LearningAchievement instance) =>
    <String, dynamic>{
      'additionalNote': instance.additionalNote,
      'description': instance.description,
      'id': instance.id,
      'title': instance.title,
    };

LearningSpecification _$LearningSpecificationFromJson(
        Map<String, dynamic> json) =>
    LearningSpecification(
      ectsCreditPoints: json['ectsCreditPoints'],
      eqfLevel: json['eqfLevel'],
      id: json['id'] as String? ?? '',
      iscedfCode: json['iscedfCode'] as List<dynamic>?,
      nqfLevel: json['nqfLevel'] as List<dynamic>?,
    );

Map<String, dynamic> _$LearningSpecificationToJson(
        LearningSpecification instance) =>
    <String, dynamic>{
      'ectsCreditPoints': instance.ectsCreditPoints,
      'eqfLevel': instance.eqfLevel,
      'id': instance.id,
      'iscedfCode': instance.iscedfCode,
      'nqfLevel': instance.nqfLevel,
    };
