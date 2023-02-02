import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/ecole_42_learning_achievement/has_credential_ecole_42.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ecole_42_learning_achievement_model.g.dart';

@JsonSerializable(explicitToJson: true)
class Ecole42LearningAchievementModel extends CredentialSubjectModel {
  Ecole42LearningAchievementModel({
    super.id,
    super.type,
    super.issuedBy,
    this.givenName,
    this.signatureLines,
    this.birthDate,
    this.familyName,
    this.hasCredential,
  }) : super(
          credentialSubjectType:
              CredentialSubjectType.ecole42LearningAchievement,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory Ecole42LearningAchievementModel.fromJson(Map<String, dynamic> json) =>
      _$Ecole42LearningAchievementModelFromJson(json);

  @JsonKey(defaultValue: '')
  final String? givenName;
  @JsonKey(fromJson: _signatureLinesFromJson)
  final Signature? signatureLines;
  @JsonKey(defaultValue: '')
  final String? birthDate;
  @JsonKey(fromJson: _hasCredentialEcole42FromJson)
  HasCredentialEcole42? hasCredential;
  @JsonKey(defaultValue: '')
  final String? familyName;

  @override
  Map<String, dynamic> toJson() =>
      _$Ecole42LearningAchievementModelToJson(this);

  static Signature _signatureLinesFromJson(dynamic json) {
    if (json == null || json == '') {
      return Signature.emptySignature();
    }
    return Signature.fromJson(json as Map<String, dynamic>);
  }

  static HasCredentialEcole42 _hasCredentialEcole42FromJson(dynamic json) {
    if (json == null || json == '') {
      return HasCredentialEcole42.emptyCredential();
    }
    return HasCredentialEcole42.fromJson(json as Map<String, dynamic>);
  }
}
