import 'package:altme/app/app.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/professional_student_card/professional_student_card_recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class StudentCardModel extends CredentialSubjectModel {
  StudentCardModel({
    this.recipient,
    this.expires,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.studentCard,
          credentialCategory: CredentialCategory.communityCards,
        );

  factory StudentCardModel.fromJson(Map<String, dynamic> json) =>
      _$StudentCardModelFromJson(json);

  @JsonKey(fromJson: _fromJsonProfessionalStudentCardRecipient)
  final ProfessionalStudentCardRecipient? recipient;
  @JsonKey(defaultValue: '')
  final String? expires;

  @override
  Map<String, dynamic> toJson() => _$StudentCardModelToJson(this);

  static ProfessionalStudentCardRecipient
      _fromJsonProfessionalStudentCardRecipient(dynamic json) {
    if (json == null || json == '') {
      return ProfessionalStudentCardRecipient.empty();
    }
    return ProfessionalStudentCardRecipient.fromJson(
      json as Map<String, dynamic>,
    );
  }
}
