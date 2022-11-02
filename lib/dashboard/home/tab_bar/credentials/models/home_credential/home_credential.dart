import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
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
    required this.credentialSubjectType,
  });

  factory HomeCredential.fromJson(Map<String, dynamic> json) =>
      _$HomeCredentialFromJson(json);

  factory HomeCredential.isNotDummy(CredentialModel credentialModel) {
    return HomeCredential(
      credentialModel: credentialModel,
      isDummy: false,
      credentialSubjectType: credentialModel
          .credentialPreview.credentialSubjectModel.credentialSubjectType,
    );
  }

  factory HomeCredential.isDummy(CredentialSubjectType credentialSubjectType) {
    String image = '';
    String link = '';
    switch (credentialSubjectType) {
      case CredentialSubjectType.ageRange:
        image = ImageStrings.dummyAgeRangeCard;
        link = Urls.ageRangeUrl;
        break;
      case CredentialSubjectType.nationality:
        image = ImageStrings.dummyNationalityCard;
        link = Urls.nationalityUrl;
        break;
      case CredentialSubjectType.gender:
        image = ImageStrings.dummyGenderCard;
        link = Urls.genderUrl;
        break;
      case CredentialSubjectType.emailPass:
        image = ImageStrings.dummyEmailPassCard;
        link = Urls.emailPassUrl;
        break;
      case CredentialSubjectType.over18:
        image = ImageStrings.dummyOver18Card;
        link = Urls.over18Url;
        break;
      case CredentialSubjectType.tezVoucher:
        image = ImageStrings.dummyTezotopiaVoucherCard;
        link = Urls.tezotopiaVoucherUrl;
        break;
      case CredentialSubjectType.talaoCommunityCard:
        image = ImageStrings.dummyTalaoCommunityCardCard;
        link = Urls.talaoCommunityCardUrl;
        break;
      case CredentialSubjectType.identityCard:
        image = ImageStrings.dummyIdentityCard;
        link = Urls.identityCardUrl;
        break;
      case CredentialSubjectType.tezotopiaMembership:
        image = ImageStrings.tezotopiaMemberShipDummy;
        link = Urls.tezotopiaMembershipCardUrl;
        break;
      case CredentialSubjectType.voucher:
      case CredentialSubjectType.selfIssued:
      case CredentialSubjectType.defaultCredential:
      case CredentialSubjectType.residentCard:
      case CredentialSubjectType.professionalExperienceAssessment:
      case CredentialSubjectType.professionalSkillAssessment:
      case CredentialSubjectType.professionalStudentCard:
      case CredentialSubjectType.loyaltyCard:
      case CredentialSubjectType.identityPass:
      case CredentialSubjectType.ecole42LearningAchievement:
      case CredentialSubjectType.phonePass:
      case CredentialSubjectType.studentCard:
      case CredentialSubjectType.tezosAssociatedWallet:
      case CredentialSubjectType.learningAchievement:
      case CredentialSubjectType.certificateOfEmployment:
        break;
      case CredentialSubjectType.aragoEmailPass:
        break;
      case CredentialSubjectType.aragoIdentityCard:
        break;
      case CredentialSubjectType.aragoLearningAchievement:
        break;
      case CredentialSubjectType.aragoOver18:
        break;
      case CredentialSubjectType.aragoPass:
        image = ImageStrings.aragoPass;
        link = Urls.aragoPassUrl;
        break;
    }
    return HomeCredential(
      isDummy: true,
      image: image,
      link: link,
      credentialSubjectType: credentialSubjectType,
    );
  }

  final CredentialModel? credentialModel;
  final String? link;
  final String? image;
  final bool isDummy;
  final CredentialSubjectType credentialSubjectType;

  Map<String, dynamic> toJson() => _$HomeCredentialToJson(this);

  @override
  List<Object?> get props =>
      [credentialModel, link, image, isDummy, credentialSubjectType];
}
