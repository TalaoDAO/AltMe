import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
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
    this.dummyDescription,
    required this.credentialSubjectType,
    this.websiteLink,
    this.whyGetThisCard,
    this.expirationDateDetails,
    this.howToGetIt,
    this.longDescription,
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
    String? image;
    String? link;
    String? websiteLink;
    ResponseString? whyGetThisCard;
    ResponseString? expirationDateDetails;
    ResponseString? howToGetIt;
    ResponseString? dummyDesc;
    ResponseString? longDescription;

    switch (credentialSubjectType) {
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.ageRange:
        image = ImageStrings.dummyAgeRangeCard;
        link = Urls.ageRangeUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_ageRangeWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_ageRangeExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_ageRangeHowToGetIt;
        dummyDesc =
            ResponseString.RESPONSE_STRING_ageRangeProofDummyDescription;
        break;

      case CredentialSubjectType.nationality:
        image = ImageStrings.dummyNationalityCard;
        link = Urls.nationalityUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_nationalityWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_nationalityExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_nationalityHowToGetIt;
        dummyDesc =
            ResponseString.RESPONSE_STRING_nationalityProofDummyDescription;
        break;

      case CredentialSubjectType.gender:
        image = ImageStrings.dummyGenderCard;
        link = Urls.genderUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_genderWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_genderExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_genderHowToGetIt;
        dummyDesc = ResponseString.RESPONSE_STRING_genderProofDummyDescription;
        break;

      case CredentialSubjectType.emailPass:
        image = ImageStrings.dummyEmailPassCard;
        dummyDesc = ResponseString.RESPONSE_STRING_emailProofDummyDescription;
        link = Urls.emailPassUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_emailPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_emailPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_emailPassHowToGetIt;
        break;

      case CredentialSubjectType.over18:
        image = ImageStrings.dummyOver18Card;
        link = Urls.over18Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;
        dummyDesc = ResponseString.RESPONSE_STRING_over18DummyDescription;
        break;

      case CredentialSubjectType.over13:
        image = ImageStrings.dummyOver13Card;
        link = Urls.over13Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over13WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over13ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over13HowToGetIt;
        dummyDesc = ResponseString.RESPONSE_STRING_over13DummyDescription;
        break;

      case CredentialSubjectType.passportFootprint:
        image = ImageStrings.dummyPassportFootprintCard;
        link = Urls.passportFootprintUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_passportFootprintWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_passportFootprintExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_passportFootprintHowToGetIt;
        dummyDesc =
            ResponseString.RESPONSE_STRING_passportFootprintDummyDescription;
        break;

      case CredentialSubjectType.tezVoucher:
        image = ImageStrings.dummyTezotopiaVoucherCard;
        link = Urls.tezotopiaVoucherUrl;
        websiteLink = 'https://tezotopia.com';
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_tezVoucherWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_tezVoucherExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_tezVoucherHowToGetIt;
        break;

      case CredentialSubjectType.talaoCommunityCard:
        image = ImageStrings.dummyTalaoCommunityCardCard;
        link = Urls.talaoCommunityCardUrl;
        break;

      case CredentialSubjectType.verifiableIdCard:
        image = ImageStrings.dummyVerifiableIdCard;
        link = Urls.identityCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_verifiableIdCardWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_verifiableIdCardExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_verifiableIdCardHowToGetIt;
        dummyDesc = ResponseString.RESPONSE_STRING_verifiableIdCardDummyDesc;
        break;

      case CredentialSubjectType.linkedInCard:
        image = ImageStrings.dummyLinkedinCard;
        link = Urls.linkedinCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_linkedinCardWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_linkedinCardExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_linkedinCardHowToGetIt;
        break;

      case CredentialSubjectType.tezotopiaMembership:
        image = ImageStrings.tezotopiaMemberShipDummy;
        link = Urls.tezotopiaMembershipCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_tezotopiaMembershipWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_tezotopiaMembershipExpirationDate;
        howToGetIt =
            ResponseString.RESPONSE_STRING_tezotopiaMembershipHowToGetIt;
        longDescription =
            ResponseString.RESPONSE_STRING_tezotopiaMembershipLongDescription;
        break;

      case CredentialSubjectType.chainbornMembership:
        image = ImageStrings.chainbornMemberShipDummy;
        link = Urls.chainbornMembershipCardUrl;
        websiteLink = 'https://chainborn.xyz/';
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_chainbornMembershipWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_chainbornMembershipExpirationDate;
        howToGetIt =
            ResponseString.RESPONSE_STRING_chainbornMembershipHowToGetIt;
        longDescription =
            ResponseString.RESPONSE_STRING_chainbornMembershipLongDescription;
        break;

      case CredentialSubjectType.twitterCard:
        image = ImageStrings.twitterCardDummy;
        link = Urls.twitterCardUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_twitterWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_twitterExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_twitterHowToGetIt;
        dummyDesc = ResponseString.RESPONSE_STRING_twitterDummyDesc;
        break;

      case CredentialSubjectType.bunnyPass:
        image = ImageStrings.bunnyPassDummy;
        link = Urls.bunnyPassCardUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_bunnyPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_bunnyPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_bunnyPassHowToGetIt;
        break;

      case CredentialSubjectType.dogamiPass:
        image = ImageStrings.dogamiPassDummy;
        link = Urls.dogamiPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_dogamiPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_dogamiPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_dogamiPassHowToGetIt;
        break;

      case CredentialSubjectType.matterlightPass:
        image = ImageStrings.matterlightPassDummy;
        link = Urls.matterlightPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_matterlightPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_matterlightPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_matterlightPassHowToGetIt;
        break;

      case CredentialSubjectType.pigsPass:
        image = ImageStrings.pigsPassDummy;
        link = Urls.pigsPassCardUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_pigsPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_pigsPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_pigsPassHowToGetIt;
        break;

      case CredentialSubjectType.troopezPass:
        image = ImageStrings.trooperzPassDummy;
        link = Urls.trooperzPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_trooperzPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_trooperzPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_trooperzPassHowToGetIt;
        break;

      case CredentialSubjectType.phonePass:
        image = ImageStrings.dummyPhonePassCard;
        dummyDesc = ResponseString.RESPONSE_STRING_phoneProofDummyDescription;
        link = Urls.phonePassUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_phoneProofWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_phoneProofExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_phoneProofHowToGetIt;
        break;

      case CredentialSubjectType.bloometaPass:
        image = ImageStrings.bloometaDummy;
        websiteLink = 'https://bloometa.com';
        link = Urls.bloometaCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_bloometaPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_bloometaPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_bloometaPassHowToGetIt;
        longDescription =
            ResponseString.RESPONSE_STRING_bloometaPassLongDescription;
        break;

      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
      case CredentialSubjectType.tezosAssociatedWallet:
        image = ImageStrings.myAccountCard;
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
      case CredentialSubjectType.studentCard:
      case CredentialSubjectType.learningAchievement:
      case CredentialSubjectType.certificateOfEmployment:
      case CredentialSubjectType.diplomaCard:
      case CredentialSubjectType.aragoEmailPass:
      case CredentialSubjectType.aragoIdentityCard:
      case CredentialSubjectType.aragoLearningAchievement:
      case CredentialSubjectType.aragoOver18:
      case CredentialSubjectType.aragoPass:
      case CredentialSubjectType.pcdsAgentCertificate:
      case CredentialSubjectType.tezosPooAddress:
      case CredentialSubjectType.ethereumPooAddress:
      case CredentialSubjectType.fantomPooAddress:
      case CredentialSubjectType.polygonPooAddress:
      case CredentialSubjectType.binancePooAddress:
      case CredentialSubjectType.euDiplomaCard:
      case CredentialSubjectType.euVerifiableId:
        break;
    }

    return HomeCredential(
      isDummy: true,
      image: image,
      link: link,
      credentialSubjectType: credentialSubjectType,
      whyGetThisCard:
          whyGetThisCard == null ? null : ResponseMessage(whyGetThisCard),
      expirationDateDetails: expirationDateDetails == null
          ? null
          : ResponseMessage(expirationDateDetails),
      howToGetIt: howToGetIt == null ? null : ResponseMessage(howToGetIt),
      websiteLink: websiteLink,
      dummyDescription: dummyDesc == null ? null : ResponseMessage(dummyDesc),
      longDescription:
          longDescription == null ? null : ResponseMessage(longDescription),
    );
  }

  final CredentialModel? credentialModel;
  final String? link;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? dummyDescription;
  final String? image;
  final bool isDummy;
  final CredentialSubjectType credentialSubjectType;
  final String? websiteLink;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? whyGetThisCard;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? expirationDateDetails;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? howToGetIt;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? longDescription;

  Map<String, dynamic> toJson() => _$HomeCredentialToJson(this);

  @override
  List<Object?> get props => [
        credentialModel,
        link,
        image,
        isDummy,
        credentialSubjectType,
        websiteLink,
        whyGetThisCard,
        expirationDateDetails,
        howToGetIt,
        dummyDescription,
        longDescription,
      ];
}
