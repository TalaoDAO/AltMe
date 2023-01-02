import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DisplayDetail extends StatelessWidget {
  const DisplayDetail({
    Key? key,
    required this.credentialModel,
    this.fromCredentialOffer = false,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final bool fromCredentialOffer;

  @override
  Widget build(BuildContext context) {
    switch (credentialModel
        .credentialPreview.credentialSubjectModel.credentialSubjectType) {
      case CredentialSubjectType.deviceInfo:
        return DeviceInfoWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.bloometaPass:
        return BloometaPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezotopiaMembership:
        return TezotopiaMemberShipWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.chainbornMembership:
        return ChainbornMemberShipWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezoniaPass:
        return TezoniaPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tzlandPass:
        return TzlandPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.troopezPass:
        return TrooperzPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.pigsPass:
        return PigsPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.matterlightPass:
        return MatterlightPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.dogamiPass:
        return DogamiPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.bunnyPass:
        return BunnyPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.ageRange:
        return AgeRangeWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.nationality:
        return NationalityWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.gender:
        return GenderWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezosAssociatedWallet:
        return TezosAssociatedAddressWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.certificateOfEmployment:
        return CertificateOfEmploymentDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.defaultCredential:
        return DefaultCredentialSubjectDisplayDetail(
          credentialModel: credentialModel,
          showBgDecoration: false,
          fromCredentialOffer: fromCredentialOffer,
        );
      case CredentialSubjectType.ecole42LearningAchievement:
        return Ecole42LearningAchievementDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.emailPass:
        return EmailPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.identityPass:
        return IdentityPassDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.verifiableIdCard:
        return VerifiableIdCardWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.learningAchievement:
        return LearningAchievementDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.loyaltyCard:
        return LoyaltyCardDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.over18:
        return Over18Widget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.over13:
        return Over13Widget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.passportFootprint:
        return PassportFootprintWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.phonePass:
        return PhonePassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalExperienceAssessment:
        return ProfessionalExperienceAssessmentDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalSkillAssessment:
        return ProfessionalSkillAssessmentDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalStudentCard:
        return ProfessionalStudentCardDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.residentCard:
        return ResidentCardDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.selfIssued:
        return SelfIssuedDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.studentCard:
        return StudentCardDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.voucher:
        return VoucherDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezVoucher:
        return TezotopiaVoucherWidget(credentialModel: credentialModel);

      case CredentialSubjectType.talaoCommunityCard:
        return TalaoCommunityCardWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.diplomaCard:
        return DiplomaCardWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoPass:
        return AragoPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoEmailPass:
        return AragoEmailPassWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoIdentityCard:
        return AragoIdentityCardWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoLearningAchievement:
        return AragoLearningAchievementDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoOver18:
        return AragoOver18Widget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.ethereumAssociatedWallet:
        return EthereumAssociatedAddressWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.pcdsAgentCertificate:
        return PcdsAgentCertificateWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.fantomAssociatedWallet:
        return FantomAssociatedAddressWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.polygonAssociatedWallet:
        return PolygonAssociatedAddressWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.binanceAssociatedWallet:
        return BinanceAssociatedAddressWidget(
          credentialModel: credentialModel,
        );

      case CredentialSubjectType.twitterCard:
        return TwitterCardWidget(
          credentialModel: credentialModel,
        );
    }
  }
}
