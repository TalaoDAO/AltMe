import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eu_verifiable_id_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EUVerifiableIdModel extends CredentialSubjectModel {
  EUVerifiableIdModel({
    this.expires = '',
    this.awardingOpportunity,
    this.dateOfBirth = '',
    this.familyName = '',
    this.givenNames = '',
    this.gradingScheme,
    this.identifier = '',
    this.learningAchievement,
    this.learningSpecification,
    super.id,
    super.type,
    super.issuedBy,
  }) : super(
          credentialSubjectType: CredentialSubjectType.euVerifiableId,
          credentialCategory: CredentialCategory.educationCards,
        );

  factory EUVerifiableIdModel.fromJson(Map<String, dynamic> json) =>
      _$EUVerifiableIdModelFromJson(json);

  final String expires;
  final AwardingOpportunity? awardingOpportunity;
  final String dateOfBirth;
  final String familyName;
  final String givenNames;
  final GradingScheme? gradingScheme;
  final String identifier;
  final LearningAchievement? learningAchievement;
  final LearningSpecification? learningSpecification;

  @override
  Map<String, dynamic> toJson() => _$EUVerifiableIdModelToJson(this);
}
