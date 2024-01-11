import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'discover_dummy_credential.g.dart';

@JsonSerializable(explicitToJson: true)
class DiscoverDummyCredential extends Equatable {
  const DiscoverDummyCredential({
    required this.credentialSubjectType,
    this.link,
    this.image,
    this.websiteLink,
    this.whyGetThisCard,
    this.expirationDateDetails,
    this.howToGetIt,
    this.longDescription,
  });

  factory DiscoverDummyCredential.fromJson(Map<String, dynamic> json) =>
      _$DiscoverDummyCredentialFromJson(json);

  factory DiscoverDummyCredential.fromSubjectType(
    CredentialSubjectType credentialSubjectType,
  ) {
    String? image;
    String? link;
    String? websiteLink;
    ResponseString? whyGetThisCard;
    ResponseString? expirationDateDetails;
    ResponseString? howToGetIt;
    ResponseString? longDescription;

    switch (credentialSubjectType) {
      case CredentialSubjectType.defiCompliance:
        image = ImageStrings.dummyDefiComplianceCard;
        link = Urls.ageRangeUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_defiComplianceWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_defiComplianceExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_defiComplianceHowToGetIt;
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.ageRange:
        image = ImageStrings.dummyAgeRangeCard;
        link = Urls.ageRangeUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_ageRangeWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_ageRangeExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_ageRangeHowToGetIt;

      case CredentialSubjectType.nationality:
        image = ImageStrings.dummyNationalityCard;
        link = Urls.nationalityUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_nationalityWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_nationalityExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_nationalityHowToGetIt;

      case CredentialSubjectType.gender:
        image = ImageStrings.dummyGenderCard;
        link = Urls.genderUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_genderWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_genderExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_genderHowToGetIt;

      case CredentialSubjectType.emailPass:
        image = ImageStrings.dummyEmailPassCard;
        link = Urls.emailPassUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_emailPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_emailPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_emailPassHowToGetIt;

      case CredentialSubjectType.over13:
        image = ImageStrings.dummyOver13Card;
        link = Urls.over13Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over13WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over13ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over13HowToGetIt;

      case CredentialSubjectType.over15:
        image = ImageStrings.dummyOver15Card;
        link = Urls.over15Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over15WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over15ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over15HowToGetIt;

      case CredentialSubjectType.over18:
        image = ImageStrings.dummyOver18Card;
        link = Urls.over18Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;

      case CredentialSubjectType.over21:
        image = ImageStrings.dummyOver18Card;
        link = Urls.over18Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;

      case CredentialSubjectType.over50:
        image = ImageStrings.dummyOver18Card;
        link = Urls.over18Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;

      case CredentialSubjectType.over65:
        image = ImageStrings.dummyOver18Card;
        link = Urls.over18Url;
        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;

      case CredentialSubjectType.passportFootprint:
        image = ImageStrings.dummyPassportFootprintCard;
        link = Urls.passportFootprintUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_passportFootprintWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_passportFootprintExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_passportFootprintHowToGetIt;

      case CredentialSubjectType.tezVoucher:
        image = ImageStrings.dummyTezotopiaVoucherCard;
        link = Urls.tezotopiaVoucherUrl;
        websiteLink = 'https://tezotopia.com';
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_tezVoucherWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_tezVoucherExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_tezVoucherHowToGetIt;

      case CredentialSubjectType.talaoCommunityCard:
        image = ImageStrings.dummyTalaoCommunityCardCard;
        link = Urls.talaoCommunityCardUrl;

      case CredentialSubjectType.verifiableIdCard:
        image = ImageStrings.dummyVerifiableIdCard;
        link = Urls.identityCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_verifiableIdCardWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_verifiableIdCardExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_verifiableIdCardHowToGetIt;

      case CredentialSubjectType.linkedInCard:
        image = ImageStrings.dummyLinkedinCard;
        link = Urls.linkedinCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_linkedinCardWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_linkedinCardExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_linkedinCardHowToGetIt;

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

      case CredentialSubjectType.twitterCard:
        image = ImageStrings.twitterCardDummy;
        link = Urls.twitterCardUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_twitterWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_twitterExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_twitterHowToGetIt;

      case CredentialSubjectType.bunnyPass:
        image = ImageStrings.bunnyPassDummy;
        link = Urls.bunnyPassCardUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_bunnyPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_bunnyPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_bunnyPassHowToGetIt;

      case CredentialSubjectType.dogamiPass:
        image = ImageStrings.dogamiPassDummy;
        link = Urls.dogamiPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_dogamiPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_dogamiPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_dogamiPassHowToGetIt;

      case CredentialSubjectType.matterlightPass:
        image = ImageStrings.matterlightPassDummy;
        link = Urls.matterlightPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_matterlightPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_matterlightPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_matterlightPassHowToGetIt;

      case CredentialSubjectType.pigsPass:
        image = ImageStrings.pigsPassDummy;
        link = Urls.pigsPassCardUrl;
        whyGetThisCard = ResponseString.RESPONSE_STRING_pigsPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_pigsPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_pigsPassHowToGetIt;

      case CredentialSubjectType.troopezPass:
        image = ImageStrings.trooperzPassDummy;
        link = Urls.trooperzPassCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_trooperzPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_trooperzPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_trooperzPassHowToGetIt;

      case CredentialSubjectType.phonePass:
        image = ImageStrings.dummyPhonePassCard;
        link = Urls.phonePassUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_phoneProofWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_phoneProofExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_phoneProofHowToGetIt;

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

      case CredentialSubjectType.livenessCard:
        image = ImageStrings.livenessDummy;
        link = Urls.livenessCardUrl;
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_livenessCardWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_livenessCardExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_livenessCardHowToGetIt;
        longDescription =
            ResponseString.RESPONSE_STRING_livenessCardLongDescription;

      case CredentialSubjectType.ethereumAssociatedWallet:
        image = ImageStrings.ethereumOwnershipCard;
      case CredentialSubjectType.fantomAssociatedWallet:
        image = ImageStrings.fantomOwnershipCard;
      case CredentialSubjectType.polygonAssociatedWallet:
        image = ImageStrings.polygonOwnershipCard;
      case CredentialSubjectType.binanceAssociatedWallet:
        image = ImageStrings.binanceOwnershipCard;
      case CredentialSubjectType.tezosAssociatedWallet:
        image = ImageStrings.tezosOwnershipCard;

      case CredentialSubjectType.employeeCredential:
        image = ImageStrings.dummyEmployeeCard;

      case CredentialSubjectType.voucher:
      case CredentialSubjectType.selfIssued:
      case CredentialSubjectType.defaultCredential:
      case CredentialSubjectType.residentCard:
      case CredentialSubjectType.professionalExperienceAssessment:
      case CredentialSubjectType.professionalSkillAssessment:
      case CredentialSubjectType.professionalStudentCard:
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
      case CredentialSubjectType.kycAgeCredential:
      case CredentialSubjectType.kycCountryOfResidence:
      case CredentialSubjectType.proofOfTwitterStats:
      case CredentialSubjectType.civicPassCredential:
      case CredentialSubjectType.legalPersonalCredential:
        break;
    }

    return DiscoverDummyCredential(
      image: image,
      link: link,
      credentialSubjectType: credentialSubjectType,
      whyGetThisCard: whyGetThisCard == null
          ? null
          : ResponseMessage(message: whyGetThisCard),
      expirationDateDetails: expirationDateDetails == null
          ? null
          : ResponseMessage(message: expirationDateDetails),
      howToGetIt:
          howToGetIt == null ? null : ResponseMessage(message: howToGetIt),
      websiteLink: websiteLink,
      longDescription: longDescription == null
          ? null
          : ResponseMessage(message: longDescription),
    );
  }

  final String? link;
  final String? image;
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

  Map<String, dynamic> toJson() => _$DiscoverDummyCredentialToJson(this);

  @override
  List<Object?> get props => [
        link,
        image,
        credentialSubjectType,
        websiteLink,
        whyGetThisCard,
        expirationDateDetails,
        howToGetIt,
        longDescription,
      ];
}
