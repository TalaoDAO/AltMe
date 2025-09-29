// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_experience_assessment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalExperienceAssessmentModel
_$ProfessionalExperienceAssessmentModelFromJson(Map<String, dynamic> json) =>
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
      review:
          (json['review'] as List<dynamic>?)
              ?.map((e) => Review.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      signatureLines:
          ProfessionalExperienceAssessmentModel._signatureLinesFromJson(
            json['signatureLines'],
          ),
      familyName: json['familyName'] as String? ?? '',
      givenName: json['givenName'] as String? ?? '',
      description: json['description'] as String? ?? '',
    );

Map<String, dynamic> _$ProfessionalExperienceAssessmentModelToJson(
  ProfessionalExperienceAssessmentModel instance,
) {
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
  val['skills'] = instance.skills?.map((e) => e.toJson()).toList();
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['familyName'] = instance.familyName;
  val['givenName'] = instance.givenName;
  val['endDate'] = instance.endDate;
  val['startDate'] = instance.startDate;
  val['expires'] = instance.expires;
  val['email'] = instance.email;
  val['review'] = instance.review?.map((e) => e.toJson()).toList();
  val['signatureLines'] = instance.signatureLines
      ?.map((e) => e.toJson())
      .toList();
  return val;
}
