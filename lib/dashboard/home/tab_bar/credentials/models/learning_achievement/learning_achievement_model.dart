import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/dashboard/home/tab_bar/credentials/models/learning_achievement/has_credential.dart';
import 'package:json_annotation/json_annotation.dart';

part 'learning_achievement_model.g.dart';

@JsonSerializable(includeIfNull: false, explicitToJson: true)
class LearningAchievementModel extends CredentialSubjectModel {
  LearningAchievementModel({
    String? id,
    String? type,
    this.familyName,
    this.givenName,
    this.email,
    this.birthDate,
    this.hasCredential,
    Author? issuedBy,
  }) : super(
          id: id,
          type: type,
          issuedBy: issuedBy,
          credentialSubjectType: CredentialSubjectType.learningAchievement,
          credentialCategory: CredentialCategory.identityCards,
        );

  factory LearningAchievementModel.fromJson(Map<String, dynamic> json) =>
      _$LearningAchievementModelFromJson(json);

  @JsonKey(defaultValue: '')
  String? familyName;
  @JsonKey(defaultValue: '')
  String? givenName;
  @JsonKey(defaultValue: '')
  String? email;
  @JsonKey(defaultValue: '')
  String? birthDate;
  HasCredential? hasCredential;

  @override
  Map<String, dynamic> toJson() => _$LearningAchievementModelToJson(this);
}
