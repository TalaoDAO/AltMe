// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'professional_skill_assessment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfessionalSkillAssessmentModel _$ProfessionalSkillAssessmentModelFromJson(
  Map<String, dynamic> json,
) => ProfessionalSkillAssessmentModel(
  id: json['id'] as String?,
  type: json['type'],
  skills: (json['skills'] as List<dynamic>?)
      ?.map((e) => Skill.fromJson(e as Map<String, dynamic>))
      .toList(),
  issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
  offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
  signatureLines: ProfessionalSkillAssessmentModel._signatureLinesFromJson(
    json['signatureLines'],
  ),
  familyName: json['familyName'] as String? ?? '',
  givenName: json['givenName'] as String? ?? '',
);

Map<String, dynamic> _$ProfessionalSkillAssessmentModelToJson(
  ProfessionalSkillAssessmentModel instance,
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
  val['familyName'] = instance.familyName;
  val['givenName'] = instance.givenName;
  val['signatureLines'] = instance.signatureLines
      ?.map((e) => e.toJson())
      .toList();
  return val;
}
