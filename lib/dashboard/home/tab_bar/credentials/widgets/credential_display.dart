import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class CredentialDisplay extends StatelessWidget {
  const CredentialDisplay({
    Key? key,
    required this.credentialModel,
    required this.credDisplayType,
    this.fromCredentialOffer,
  }) : super(key: key);

  final CredentialModel credentialModel;
  final bool? fromCredentialOffer;
  final CredDisplayType credDisplayType;

  @override
  Widget build(BuildContext context) {
    switch (credentialModel
        .credentialPreview.credentialSubjectModel.credentialSubjectType) {
      case CredentialSubjectType.walletCredential:
        return WalletCredentialWidget(credentialModel: credentialModel);

      case CredentialSubjectType.bloometaPass:
        return BloometaPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.tezotopiaMembership:
        return TezotopiaMemberShipWidget(credentialModel: credentialModel);

      case CredentialSubjectType.chainbornMembership:
        return ChainbornMemberShipWidget(credentialModel: credentialModel);

      case CredentialSubjectType.tezoniaPass:
        return TezoniaPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.tzlandPass:
        return TzlandPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.troopezPass:
        return TrooperzPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.pigsPass:
        return PigsPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.matterlightPass:
        return MatterlightPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.dogamiPass:
        return DogamiPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.bunnyPass:
        return BunnyPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.ageRange:
        return AgeRangeWidget(credentialModel: credentialModel);

      case CredentialSubjectType.nationality:
        return NationalityWidget(credentialModel: credentialModel);

      case CredentialSubjectType.gender:
        return GenderWidget(credentialModel: credentialModel);

      case CredentialSubjectType.certificateOfEmployment:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return CertificateOfEmploymentRecto(
              credentialModel: credentialModel,
            );
          case CredDisplayType.Detail:
            return CertificateOfEmploymentWidget(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.defaultCredential:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
              showBgDecoration: false,
            );
          case CredDisplayType.Detail:
            return DefaultCredentialDetailWidget(
              credentialModel: credentialModel,
              showBgDecoration: false,
              fromCredentialOffer: fromCredentialOffer!,
            );
        }

      case CredentialSubjectType.ecole42LearningAchievement:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
            );
          case CredDisplayType.Detail:
            return Ecole42LearningAchievementWidget(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.emailPass:
        return EmailPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.identityPass:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
              descriptionMaxLine: 4,
            );
          case CredDisplayType.Detail:
            return IdentityPassWidget(credentialModel: credentialModel);
        }

      case CredentialSubjectType.verifiableIdCard:
        return VerifiableIdCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.linkedInCard:
        return LinkedinCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.learningAchievement:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return LearningAchievementRecto(credentialModel: credentialModel);
          case CredDisplayType.Detail:
            return LearningAchievementDisplayDetail(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.loyaltyCard:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
            );
          case CredDisplayType.Detail:
            return LoyaltyCardDisplayDetail(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.over18:
        return Over18Widget(credentialModel: credentialModel);

      case CredentialSubjectType.over13:
        return Over13Widget(credentialModel: credentialModel);

      case CredentialSubjectType.passportFootprint:
        return PassportFootprintWidget(credentialModel: credentialModel);

      case CredentialSubjectType.phonePass:
        return PhonePassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.professionalExperienceAssessment:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
              descriptionMaxLine: 3,
            );
          case CredDisplayType.Detail:
            return ProfessionalExperienceAssessmentWidget(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.professionalSkillAssessment:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
              descriptionMaxLine: 5,
            );
          case CredDisplayType.Detail:
            return ProfessionalSkillAssessmentWidget(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.professionalStudentCard:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
            );
          case CredDisplayType.Detail:
            return ProfessionalStudentCardWidget(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.residentCard:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
              descriptionMaxLine: 3,
            );
          case CredDisplayType.Detail:
            return ResidentCardWidget(credentialModel: credentialModel);
        }

      case CredentialSubjectType.selfIssued:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialListWidget(
              credentialModel: credentialModel,
            );
          case CredDisplayType.Detail:
            return SelfIssuedWidget(credentialModel: credentialModel);
        }

      case CredentialSubjectType.studentCard:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return StudentCardRecto(credentialModel: credentialModel);
          case CredDisplayType.Detail:
            return StudentCardWidget(credentialModel: credentialModel);
        }

      case CredentialSubjectType.voucher:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return const VoucherRecto();
          case CredDisplayType.Detail:
            return VoucherWidget(credentialModel: credentialModel);
        }

      case CredentialSubjectType.tezVoucher:
        return TezotopiaVoucherWidget(credentialModel: credentialModel);

      case CredentialSubjectType.talaoCommunityCard:
        return TalaoCommunityCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.diplomaCard:
        return DiplomaCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.aragoPass:
        return AragoPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.aragoEmailPass:
        return AragoEmailPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.aragoIdentityCard:
        return AragoIdentityCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.aragoLearningAchievement:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return AragoLearningAchievementRecto(
              credentialModel: credentialModel,
            );
          case CredDisplayType.Detail:
            return AragoLearningAchievementWidget(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.aragoOver18:
        return AragoOver18Widget(credentialModel: credentialModel);

      case CredentialSubjectType.pcdsAgentCertificate:
        return PcdsAgentCertificateWidget(credentialModel: credentialModel);

      case CredentialSubjectType.twitterCard:
        return TwitterCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.ethereumAssociatedWallet:
        return EthereumAssociatedAddressWidget(
          credentialModel: credentialModel,
        );

      case CredentialSubjectType.tezosAssociatedWallet:
        return TezosAssociatedAddressWidget(credentialModel: credentialModel);

      case CredentialSubjectType.fantomAssociatedWallet:
        return FantomAssociatedAddressWidget(credentialModel: credentialModel);

      case CredentialSubjectType.polygonAssociatedWallet:
        return PolygonAssociatedAddressWidget(credentialModel: credentialModel);

      case CredentialSubjectType.binanceAssociatedWallet:
        return BinanceAssociatedAddressWidget(credentialModel: credentialModel);

      case CredentialSubjectType.ethereumPooAddress:
        return EthereumPooAddressWidget(
          credentialModel: credentialModel,
        );

      case CredentialSubjectType.tezosPooAddress:
        return TezosPooAddressWidget(credentialModel: credentialModel);

      case CredentialSubjectType.fantomPooAddress:
        return FantomPooAddressWidget(credentialModel: credentialModel);

      case CredentialSubjectType.polygonPooAddress:
        return PolygonPooAddressWidget(credentialModel: credentialModel);

      case CredentialSubjectType.binancePooAddress:
        return BinancePooAddressWidget(credentialModel: credentialModel);
    }
  }
}
