import 'package:arago_wallet/app/app.dart';
import 'package:arago_wallet/dashboard/dashboard.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/arago_email_pass_widget.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/arago_identity_card_widget.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/arago_learning_achievement_widget.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/arago_over18_widget.dart';
import 'package:arago_wallet/dashboard/home/tab_bar/credentials/widgets/credential_widget/arago_pass_widget.dart';
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
      case CredentialSubjectType.tezotopiaMembership:
        return TezotopiaMemberShipDisplayInList(
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
      case CredentialSubjectType.identityCard:
        return IdentityCardDisplayInList(
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
      case CredentialSubjectType.aragoPass:
        return AragoPassDisplayInList(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.defaultCredential:
        return DefaultCredentialSubjectDisplayInList(
          credentialModel: credentialModel,
          showBgDecoration: false,
        );
    }
  }
}
