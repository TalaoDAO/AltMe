import 'package:altme/app/shared/constants/image_strings.dart';
import 'package:altme/app/shared/enum/type/type.dart';
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
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.defaultCredential:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.ecole42LearningAchievement:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.emailPass:
        image = ImageStrings.dummyEmailPassCard;
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.identityPass:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.learningAchievement:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.loyaltyCard:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.over18:
        image = ImageStrings.dummyOver18Card;
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.phonePass:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.professionalExperienceAssessment:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.professionalSkillAssessment:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.professionalStudentCard:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.residentCard:
        image = ImageStrings.dummyResidentCard;
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.selfIssued:
        image = '';
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.studentCard:
        image = ImageStrings.dummyStudentCard;
        link = 'https://www.altme.io/';
        break;
      case CredentialSubjectType.voucher:
        image = ImageStrings.dummyVoucherCard;
        link = 'https://www.altme.io/';
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
