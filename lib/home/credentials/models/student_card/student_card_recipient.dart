import 'package:json_annotation/json_annotation.dart';

part 'student_card_recipient.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentCardRecipient {
  StudentCardRecipient(
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

  factory StudentCardRecipient.fromJson(Map<String, dynamic> json) =>
      _$StudentCardRecipientFromJson(json);

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

  Map<String, dynamic> toJson() => _$StudentCardRecipientToJson(this);
}
