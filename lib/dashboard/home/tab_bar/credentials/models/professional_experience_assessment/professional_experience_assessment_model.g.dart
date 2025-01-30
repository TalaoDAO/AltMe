// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_experience_assessment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalExperienceAssessmentModel
    _$ProfessionalExperienceAssessmentModelFromJson(
            Map<String, dynamic> json) =>
        ProfessionalExperienceAssessmentModel(
          expires: json['expires'] as String? ?? '',
          email: json['email'] as String? ?? '',
          id: json['id'] as String?,
          type: json['type'],
          skills: (json['skills'] as List<dynamic>?)
              ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
              .toList(),
          title: json['title'] as String? ?? '',
          endDate: json['endDate'] as String? ?? '',
          startDate: json['startDate'] as String? ?? '',
          issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
          offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
          review: (json['review'] as List<dynamic>?)
                  ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
                  .toList() ??
              [],
          signatureLines:
              ProfessionalExperienceAssessmentModel._signatureLinesFromJson(
                  json['signatureLines']),
          familyName: json['familyName'] as String? ?? '',
          givenName: json['givenName'] as String? ?? '',
          description: json['description'] as String? ?? '',
        );

Map<String, dynamic> _$ProfessionalExperienceAssessmentModelToJson(
        ProfessionalExperienceAssessmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'issuedBy': instance.issuedBy?.toJson(),
      if (instance.offeredBy?.toJson() case final value?) 'offeredBy': value,
      'skills': instance.skills?.map((e) => e.toJson()).toList(),
      'title': instance.title,
      'description': instance.description,
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'endDate': instance.endDate,
      'startDate': instance.startDate,
      'expires': instance.expires,
      'email': instance.email,
      'review': instance.review?.map((e) => e.toJson()).toList(),
      'signatureLines':
          instance.signatureLines?.map((e) => e.toJson()).toList(),
    };
