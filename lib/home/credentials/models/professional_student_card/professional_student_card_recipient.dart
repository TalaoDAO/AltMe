import 'package:json_annotation/json_annotation.dart';

part 'professional_student_card_recipient.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalStudentCardRecipient {
  ProfessionalStudentCardRecipient(
    this.email,
    this.image,
    this.telephone,
    this.familyName,
    this.address,
    this.birthDate,
    this.givenName,
    this.gender,
    this.jobTitle,
  );

  factory ProfessionalStudentCardRecipient.empty() =>
      ProfessionalStudentCardRecipient('', '', '', '', '', '', '', '', '');

  factory ProfessionalStudentCardRecipient.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ProfessionalStudentCardRecipientFromJson(json);

  @JsonKey(defaultValue: '')
  final String email;
  @JsonKey(defaultValue: '')
  final String image;
  @JsonKey(defaultValue: '')
  final String telephone;
  @JsonKey(defaultValue: '')
  final String familyName;
  @JsonKey(defaultValue: '')
  final String address;
  @JsonKey(defaultValue: '')
  final String birthDate;
  @JsonKey(defaultValue: '')
  final String givenName;
  @JsonKey(defaultValue: '')
  final String gender;
  @JsonKey(defaultValue: '')
  final String jobTitle;

  Map<String, dynamic> toJson() =>
      _$ProfessionalStudentCardRecipientToJson(this);
}
