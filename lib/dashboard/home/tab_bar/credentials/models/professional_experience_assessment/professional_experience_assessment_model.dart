import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/professional_experience_assessment/review.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/professional_experience_assessment/skill.dart';
import 'package:json_annotation/json_annotation.dart';

part 'professional_experience_assessment_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalExperienceAssessmentModel extends CredentialSubjectModel {
  ProfessionalExperienceAssessmentModel({
    this.expires,
    this.email,
    super.id,
    super.type,
    this.skills,
    this.title,
    this.endDate,
    this.startDate,
    super.issuedBy,
    this.review,
    this.signatureLines,
    this.familyName,
    this.givenName,
    this.description,
  }) : super(
          credentialSubjectType:
              CredentialSubjectType.professionalExperienceAssessment,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory ProfessionalExperienceAssessmentModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProfessionalExperienceAssessmentModelFromJson(json);

  final List<Skill>? skills;
  @JsonKey(defaultValue: '')
  final String? title;
  @JsonKey(defaultValue: '')
  final String? description;
  @JsonKey(defaultValue: '')
  final String? familyName;
  @JsonKey(defaultValue: '')
  final String? givenName;
  @JsonKey(defaultValue: '')
  final String? endDate;
  @JsonKey(defaultValue: '')
  final String? startDate;
  @JsonKey(defaultValue: '')
  final String? expires;
  @JsonKey(defaultValue: '')
  final String? email;
  @JsonKey(defaultValue: <Review>[])
  final List<Review>? review;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final List<Signature>? signatureLines;

  @override
  Map<String, dynamic> toJson() =>
      _$ProfessionalExperienceAssessmentModelToJson(this);

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
