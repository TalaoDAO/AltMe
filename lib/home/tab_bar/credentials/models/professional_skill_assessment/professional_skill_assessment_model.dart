import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:altme/home/tab_bar/credentials/models/professional_experience_assessment/skill.dart';
import 'package:altme/home/tab_bar/credentials/models/signature/signature.dart';
import 'package:json_annotation/json_annotation.dart';

part 'professional_skill_assessment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalSkillAssessmentModel extends CredentialSubjectModel {
  ProfessionalSkillAssessmentModel({
    String? id,
    String? type,
    this.skills,
    Author? issuedBy,
    this.signatureLines,
    this.familyName,
    this.givenName,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType:
              CredentialSubjectType.professionalSkillAssessment,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory ProfessionalSkillAssessmentModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProfessionalSkillAssessmentModelFromJson(json);

  final List<Skill>? skills;
  @JsonKey(defaultValue: '')
  @JsonKey(defaultValue: '')
  final String? familyName;
  @JsonKey(defaultValue: '')
  final String? givenName;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final List<Signature>? signatureLines;

  @override
  Map<String, dynamic> toJson() =>
      _$ProfessionalSkillAssessmentModelToJson(this);

  static List<Signature> _signatureLinesFromJson(dynamic json) {
    if (json == null || json == '') {
      return [];
    }
    if (json is List) {
      return json
          .map((dynamic e) => Signature.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [Signature.fromJson(json as Map<String, dynamic>)];
  }
}
