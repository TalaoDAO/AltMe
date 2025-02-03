// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_skill_assessment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalSkillAssessmentModel _$ProfessionalSkillAssessmentModelFromJson(
        Map<String, dynamic> json) =>
    ProfessionalSkillAssessmentModel(
      id: json['id'] as String?,
      type: json['type'],
      skills: (json['skills'] as List<dynamic>?)
          ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
          .toList(),
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      signatureLines: ProfessionalSkillAssessmentModel._signatureLinesFromJson(
          json['signatureLines']),
      familyName: json['familyName'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
    );

Map<String, dynamic> _$ProfessionalSkillAssessmentModelToJson(
        ProfessionalSkillAssessmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'skills': instance.skills?.map((e) => e.toJson()).toList(),
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'signatureLines':
          instance.signatureLines?.map((e) => e.toJson()).toList(),
    };
