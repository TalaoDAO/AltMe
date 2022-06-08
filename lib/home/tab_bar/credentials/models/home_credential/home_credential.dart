import 'package:altme/app/app.dart';
import 'package:altme/home/home.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class HomeCredential extends Equatable {
  const HomeCredential({
    this.credentialModel,
    this.link,
    this.image,
    required this.isDummy,
  });

  factory HomeCredential.fromJson(Map<String, dynamic> json) =>
      _$HomeCredentialFromJson(json);

  factory HomeCredential.isNotDummy(CredentialModel credentialModel) {
    return HomeCredential(
      credentialModel: credentialModel,
      isDummy: false,
    );
  }

  factory HomeCredential.isDummy(CredentialSubjectType credentialSubjectType) {
    String image = '';
    String link = '';
    switch (credentialSubjectType) {
      case CredentialSubjectType.certificateOfEmployment:
        image = ImageStrings.dummyCertificateOfEmploymentCard;
        link = Urls.certificateOfEmploymentUrl;
        break;
      case CredentialSubjectType.emailPass:
        image = ImageStrings.dummyEmailPassCard;
        link = Urls.emailPassUrl;
        break;
      case CredentialSubjectType.learningAchievement:
        image = ImageStrings.dummyLearningAchievementCard;
        link = Urls.learningAchievementUrl;
        break;
      case CredentialSubjectType.over18:
        image = ImageStrings.dummyOver18Card;
        link = Urls.over18Url;
        break;
      case CredentialSubjectType.phonePass:
        image = ImageStrings.dummyPhonePassCard;
        link = Urls.phonePassUrl;
        break;
      case CredentialSubjectType.studentCard:
        image = ImageStrings.dummyStudentCard;
        link = Urls.studentCardUrl;
        break;
      case CredentialSubjectType.voucher:
        image = ImageStrings.dummyVoucherCard;
        link = Urls.voucherUrl;
        break;
      case CredentialSubjectType.selfIssued:
      case CredentialSubjectType.defaultCredential:
      case CredentialSubjectType.residentCard:
      case CredentialSubjectType.professionalExperienceAssessment:
      case CredentialSubjectType.professionalSkillAssessment:
      case CredentialSubjectType.professionalStudentCard:
      case CredentialSubjectType.loyaltyCard:
      case CredentialSubjectType.identityPass:
      case CredentialSubjectType.ecole42LearningAchievement:
        break;
    }
    return HomeCredential(
      isDummy: true,
      image: image,
      link: link,
    );
  }

  final CredentialModel? credentialModel;
  final String? link;
  final String? image;
  final bool isDummy;

  Map<String, dynamic> toJson() => _$HomeCredentialToJson(this);

  @override
  List<Object?> get props => [credentialModel, link, image, isDummy];
}
