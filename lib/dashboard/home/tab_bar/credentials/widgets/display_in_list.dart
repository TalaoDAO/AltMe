import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class DisplayInList extends StatelessWidget {
  const DisplayInList({
    Key? key,
    required this.credentialModel,
  }) : super(key: key);

  final CredentialModel credentialModel;

  @override
  Widget build(BuildContext context) {
    switch (credentialModel
        .credentialPreview.credentialSubjectModel.credentialSubjectType) {
      case CredentialSubjectType.deviceInfo:
        return DeviceInfoDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.bloometaPass:
        return BloometaPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezotopiaMembership:
        return TezotopiaMemberShipDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.chainbornMembership:
        return ChainbornMemberShipDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.bunnyPass:
        return BunnyPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.dogamiPass:
        return DogamiPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.matterlightPass:
        return MatterlightPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.pigsPass:
        return PigsPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.troopezPass:
        return TrooperzPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tzlandPass:
        return TzlandPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezoniaPass:
        return TezoniaPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.ageRange:
        return AgeRangeDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.nationality:
        return NationalityDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.gender:
        return GenderDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezosAssociatedWallet:
        return TezosAssociatedAddressDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.certificateOfEmployment:
        return CertificateOfEmploymentDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.defaultCredential:
        return DefaultCredentialSubjectDisplayInList(
          credentialModel: credentialModel,
          showBgDecoration: false,
        );
      case CredentialSubjectType.ecole42LearningAchievement:
        return Ecole42LearningAchievementDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.emailPass:
        return EmailPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.identityPass:
        return IdentityPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.verifiableIdCard:
        return VerifiableIdCardDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.learningAchievement:
        return LearningAchievementDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.loyaltyCard:
        return LoyaltyCardDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.over18:
        return Over18DisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.over13:
        return Over13DisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.passportFootprint:
        return PassportFootprintDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.phonePass:
        return PhonePassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalExperienceAssessment:
        return ProfessionalExperienceAssessmentDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalSkillAssessment:
        return ProfessionalSkillAssessmentDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.professionalStudentCard:
        return ProfessionalStudentCardDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.residentCard:
        return ResidentCardDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.selfIssued:
        return SelfIssuedDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.studentCard:
        return StudentCardDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.voucher:
        return VoucherDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezVoucher:
        return TezotopiaVoucherDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.talaoCommunityCard:
        return TalaoCommunityCardDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.diplomaCard:
        return DiplomaCardDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoPass:
        return AragoPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoEmailPass:
        return AragoEmailPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoIdentityCard:
        return AragoIdentityCardDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoLearningAchievement:
        return AragoLearningAchievementDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoOver18:
        return AragoOver18DisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.ethereumAssociatedWallet:
        return EthereumAssociatedAddressDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.pcdsAgentCertificate:
        return PcdsAgentCertificateDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.fantomAssociatedWallet:
        return FantomAssociatedAddressDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.polygonAssociatedWallet:
        return PolygonAssociatedAddressDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.binanceAssociatedWallet:
        return BinanceAssociatedAddressDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.twitterCard:
        return TwitterCardDisplayInList(credentialModel: credentialModel);
    }
  }
}
