import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DisplayInSelectionList extends StatelessWidget {
  const DisplayInSelectionList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    switch (credentialModel
        .credentialPreview.credentialSubjectModel.credentialSubjectType) {
      case CredentialSubjectType.deviceInfo:
        return DeviceInfoDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.bloometaPass:
        return BloometaPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezotopiaMembership:
        return TezotopiaMemberShipDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.chainbornMembership:
        return ChainbornMemberShipDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezoniaPass:
        return TezoniaPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tzlandPass:
        return TzlandPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.troopezPass:
        return TrooperzPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.pigsPass:
        return PigsPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.matterlightPass:
        return MatterlightPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.dogamiPass:
        return DogamiPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.bunnyPass:
        return BunnyPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.ageRange:
        return AgeRangeDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.nationality:
        return NationalityDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.gender:
        return GenderDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezosAssociatedWallet:
        return TezosAssociatedAddressDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.certificateOfEmployment:
        return CertificateOfEmploymentDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.defaultCredential:
        return DefaultCredentialSubjectDisplayInSelectionList(
          credentialModel: credentialModel,
          showBgDecoration: false,
        );
      case CredentialSubjectType.ecole42LearningAchievement:
        return Ecole42LearningAchievementDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.emailPass:
        return EmailPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.identityPass:
        return IdentityPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.identityCard:
        return IdentityCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.learningAchievement:
        return LearningAchievementDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.loyaltyCard:
        return LoyaltyCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.over18:
        return Over18DisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.over13:
        return Over13DisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.passportFootprint:
        return PassportFootprintDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.phonePass:
        return PhonePassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalExperienceAssessment:
        return ProfessionalExperienceAssessmentDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalSkillAssessment:
        return ProfessionalSkillAssessmentDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalStudentCard:
        return ProfessionalStudentCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.residentCard:
        return ResidentCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.selfIssued:
        return SelfIssuedDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.studentCard:
        return StudentCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.voucher:
        return VoucherDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezVoucher:
        return TezotopiaVoucherDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.talaoCommunityCard:
        return TalaoCommunityCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.diplomaCard:
        return DiplomaCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoPass:
        return AragoPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoEmailPass:
        return AragoEmailPassDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoIdentityCard:
        return AragoIdentityCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoLearningAchievement:
        return AragoLearningAchievementDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoOver18:
        return AragoOver18DisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.ethereumAssociatedWallet:
        return EthereumAssociatedAddressDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.pcdsAgentCertificate:
        return PcdsAgentCertificateDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.fantomAssociatedWallet:
        return FantomAssociatedAddressDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.polygonAssociatedWallet:
        return PolygonAssociatedAddressDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.binanceAssociatedWallet:
        return BinanceAssociatedAddressDisplayInSelectionList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.twitterCard:
        return TwitterCardDisplayInSelectionList(
          credentialModel: credentialModel,
        );
    }
  }
}
