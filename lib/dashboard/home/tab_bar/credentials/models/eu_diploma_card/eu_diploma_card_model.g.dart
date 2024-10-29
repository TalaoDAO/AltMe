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
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
    );

Map<String, dynamic> _$EUDiplomaCardModelToJson(EUDiplomaCardModel instance) {
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
