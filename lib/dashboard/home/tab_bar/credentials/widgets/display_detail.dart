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
      case CredentialSubjectType.bloometaPass:
        return BloometaPassDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezotopiaMembership:
        return TezotopiaMemberShipDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.ageRange:
        return AgeRangeDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.nationality:
        return NationalityDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.gender:
        return GenderDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.tezosAssociatedWallet:
        return TezosAssociatedAddressDisplayDetail(
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
        return EmailPassDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.identityPass:
        return IdentityPassDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.identityCard:
        return IdentityCardDisplayDetail(
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
        return Over18DisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.over13:
        return Over13DisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.passportFootprint:
        return PassportFootprintDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.phonePass:
        return PhonePassDisplayDetail(
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
        return TezotopiaVoucherDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.talaoCommunityCard:
        return TalaoCommunityCardDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.diplomaCard:
        return DiplomaCardDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoPass:
        return AragoPassDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoEmailPass:
        return AragoEmailPassDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoIdentityCard:
        return AragoIdentityCardDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoLearningAchievement:
        return AragoLearningAchievementDisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.aragoOver18:
        return AragoOver18DisplayDetail(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.ethereumAssociatedWallet:
        return EthereumAssociatedAddressDisplayDetail(
          credentialModel: credentialModel,
        );
    }
  }
}
