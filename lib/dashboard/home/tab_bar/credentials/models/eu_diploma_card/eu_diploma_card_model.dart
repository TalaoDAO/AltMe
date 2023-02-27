import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:json_annotation/json_annotation.dart';

part 'eu_diploma_card_model.g.dart';

@JsonSerializable(explicitToJson: true)
class EUDiplomaCardModel extends CredentialSubjectModel {
  EUDiplomaCardModel({
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
          credentialSubjectType: CredentialSubjectType.euDiplomaCard,
          credentialCategory: CredentialCategory.educationCards,
        );

  factory EUDiplomaCardModel.fromJson(Map<String, dynamic> json) =>
      _$EUDiplomaCardModelFromJson(json);

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
  Map<String, dynamic> toJson() => _$EUDiplomaCardModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AwardingOpportunity {
  AwardingOpportunity({
    this.awardingBody,
    this.endedAtTime = '',
    this.id = '',
    this.identifier = '',
    this.location = '',
    this.startedAtTime = '',
  });

  factory AwardingOpportunity.fromJson(Map<String, dynamic> json) =>
      _$AwardingOpportunityFromJson(json);

  final AwardingBody? awardingBody;
  final String endedAtTime;
  final String id;
  final String identifier;
  final String location;
  final String startedAtTime;

  Map<String, dynamic> toJson() => _$AwardingOpportunityToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AwardingBody {
  AwardingBody({
    this.eidasLegalIdentifier = '',
    this.homepage = '',
    this.id = '',
    this.preferredName = '',
    this.registration = '',
  });

  factory AwardingBody.fromJson(Map<String, dynamic> json) =>
      _$AwardingBodyFromJson(json);

  final String eidasLegalIdentifier;
  final String homepage;
  final String id;
  final String preferredName;
  final String registration;

  Map<String, dynamic> toJson() => _$AwardingBodyToJson(this);
}

@JsonSerializable(explicitToJson: true)
class GradingScheme {
  GradingScheme({
    this.id = '',
    this.title = '',
  });

  factory GradingScheme.fromJson(Map<String, dynamic> json) =>
      _$GradingSchemeFromJson(json);

  final String id;
  final String title;

  Map<String, dynamic> toJson() => _$GradingSchemeToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LearningAchievement {
  LearningAchievement({
    this.additionalNote,
    this.description = '',
    this.id = '',
    this.title = '',
  });

  factory LearningAchievement.fromJson(Map<String, dynamic> json) =>
      _$LearningAchievementFromJson(json);

  final List<String>? additionalNote;
  final String description;
  final String id;
  final String title;

  Map<String, dynamic> toJson() => _$LearningAchievementToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LearningSpecification {
  LearningSpecification({
    this.ectsCreditPoints,
    this.eqfLevel,
    this.id = '',
    this.iscedfCode,
    this.nqfLevel,
  });

  factory LearningSpecification.fromJson(Map<String, dynamic> json) =>
      _$LearningSpecificationFromJson(json);

  dynamic ectsCreditPoints;
  dynamic eqfLevel;
  String id;
  List<dynamic>? iscedfCode;
  List<dynamic>? nqfLevel;

  Map<String, dynamic> toJson() => _$LearningSpecificationToJson(this);
}
