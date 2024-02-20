import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';

class CredentialDisplay extends StatelessWidget {
  const CredentialDisplay({
    super.key,
    required this.credentialModel,
    required this.credDisplayType,
    required this.vcFormatType,
    this.displyalDescription = true,
  });

  final CredentialModel credentialModel;
  final CredDisplayType credDisplayType;
  final VCFormatType vcFormatType;
  final bool displyalDescription;

  @override
  Widget build(BuildContext context) {
    switch (credentialModel
        .credentialPreview.credentialSubjectModel.credentialSubjectType) {
      case CredentialSubjectType.defiCompliance:
        return DefiComplianceCredentialWidget(
          credentialModel: credentialModel,
        );
      case CredentialSubjectType.walletCredential:
        return WalletCredentialWidget(credentialModel: credentialModel);

      case CredentialSubjectType.livenessCard:
        return LivenessCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.tezotopiaMembership:
        return TezotopiaMemberShipWidget(credentialModel: credentialModel);

      case CredentialSubjectType.chainbornMembership:
        return ChainbornMemberShipWidget(credentialModel: credentialModel);

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
        if (credentialModel.isPolygonIdCard) {
          return DefaultPolygonIdCardWidget(credentialModel: credentialModel);
        } else if (credentialModel.pendingInfo != null) {
          final credentialName = credentialModel.credentialPreview.type[0];
          final CredentialSubjectType credentialSubjectType =
              getCredTypeFromName(credentialName) ??
                  CredentialSubjectType.defaultCredential;

          final DiscoverDummyCredential discoverDummyCredential =
              credentialSubjectType.dummyCredential(vcFormatType);

          return Opacity(
            opacity: 0.5,
            child: DummyCredentialImage(
              credentialSubjectType:
                  discoverDummyCredential.credentialSubjectType,
              image: discoverDummyCredential.image,
              credentialName: credentialName,
            ),
          );
        } else {
          switch (credDisplayType) {
            case CredDisplayType.List:
              return DefaultCredentialWidget(
                credentialModel: credentialModel,
                showBgDecoration: false,
                displyalDescription: displyalDescription,
              );
            case CredDisplayType.Detail:
              return DefaultCredentialWidget(
                credentialModel: credentialModel,
                showBgDecoration: false,
                descriptionMaxLine: 5,
              );
          }
        }

      case CredentialSubjectType.emailPass:
        return EmailPassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.identityPass:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialWidget(
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

      case CredentialSubjectType.euDiplomaCard:
        return EUDiplomaCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.euVerifiableId:
        return EUVerifiableIdWidget(credentialModel: credentialModel);

      case CredentialSubjectType.learningAchievement:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return LearningAchievementRecto(credentialModel: credentialModel);
          case CredDisplayType.Detail:
            return LearningAchievementDisplayDetail(
              credentialModel: credentialModel,
            );
        }

      case CredentialSubjectType.over13:
        return Over13Widget(credentialModel: credentialModel);
      case CredentialSubjectType.over15:
        return Over15Widget(credentialModel: credentialModel);
      case CredentialSubjectType.over18:
        return Over18Widget(credentialModel: credentialModel);
      case CredentialSubjectType.over21:
        return Over21Widget(credentialModel: credentialModel);
      case CredentialSubjectType.over50:
        return Over50Widget(credentialModel: credentialModel);
      case CredentialSubjectType.over65:
        return Over65Widget(credentialModel: credentialModel);

      case CredentialSubjectType.passportFootprint:
        return PassportFootprintWidget(credentialModel: credentialModel);

      case CredentialSubjectType.phonePass:
        return PhonePassWidget(credentialModel: credentialModel);

      case CredentialSubjectType.professionalExperienceAssessment:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialWidget(
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
            return DefaultCredentialWidget(
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
            return DefaultCredentialWidget(
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
            return DefaultCredentialWidget(
              credentialModel: credentialModel,
              descriptionMaxLine: 3,
            );
          case CredDisplayType.Detail:
            return ResidentCardWidget(credentialModel: credentialModel);
        }

      case CredentialSubjectType.employeeCredential:
        return EmployeeCredentialWidget(credentialModel: credentialModel);

      case CredentialSubjectType.legalPersonalCredential:
        return DefaultCredentialWidget(credentialModel: credentialModel);

      case CredentialSubjectType.selfIssued:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return DefaultCredentialWidget(
              credentialModel: credentialModel,
            );
          case CredDisplayType.Detail:
            return SelfIssuedWidget(credentialModel: credentialModel);
        }

      case CredentialSubjectType.studentCard:
        return StudentCardWidget(credentialModel: credentialModel);

      case CredentialSubjectType.voucher:
        switch (credDisplayType) {
          case CredDisplayType.List:
            return const VoucherRecto();
          case CredDisplayType.Detail:
            return VoucherWidget(credentialModel: credentialModel);
        }

      case CredentialSubjectType.tezVoucher:
        return TezotopiaVoucherWidget(credentialModel: credentialModel);

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

      case CredentialSubjectType.kycAgeCredential:
        return KYCAgeCredentialWidget(credentialModel: credentialModel);

      case CredentialSubjectType.kycCountryOfResidence:
        return KYCCountryOfResidenceWidget(credentialModel: credentialModel);

      case CredentialSubjectType.proofOfTwitterStats:
        return ProofOfTwitterStatsWidget(credentialModel: credentialModel);

      case CredentialSubjectType.civicPassCredential:
        return CivicPassCredentialWidget(credentialModel: credentialModel);
    }
  }
}
