import 'package:altme/app/app.dart';
import 'package:altme/home/tab_bar/credentials/models/author/author.dart';
import 'package:altme/home/tab_bar/credentials/models/credential_subject/credential_subject_model.dart';
import 'package:altme/home/tab_bar/credentials/models/professional_student_card/professional_student_card_recipient.dart';
import 'package:json_annotation/json_annotation.dart';

part 'professional_student_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfessionalStudentCardModel extends CredentialSubjectModel {
  ProfessionalStudentCardModel({
    this.recipient,
    this.expires,
    String? id,
    String? type,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.professionalStudentCard,
          credentialCategory: CredentialCategory.communityCards,
        );

  factory ProfessionalStudentCardModel.fromJson(Map<String, dynamic> json) =>
      _$ProfessionalStudentCardModelFromJson(json);

  final ProfessionalStudentCardRecipient? recipient;
  @JsonKey(defaultValue: '')
  final String? expires;

  @override
  Map<String, dynamic> toJson() => _$ProfessionalStudentCardModelToJson(this);
}
