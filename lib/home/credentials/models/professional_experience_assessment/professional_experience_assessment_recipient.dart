import 'package:json_annotation/json_annotation.dart';

part 'professional_experience_assessment_recipient.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalExperienceAssessmentRecipient {
  ProfessionalExperienceAssessmentRecipient(this.name, this.type);

  factory ProfessionalExperienceAssessmentRecipient.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProfessionalExperienceAssessmentRecipientFromJson(json);

  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String type;

  Map<String, dynamic> toJson() =>
      _$ProfessionalExperienceAssessmentRecipientToJson(this);
}
