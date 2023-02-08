part of 'credential_subject_type.dart';

extension CredentialSubjectTypeExtension on CredentialSubjectType {
  Color backgroundColor(CredentialModel credentialModel) {
    final Color backgroundColor;
    if (credentialModel.display.backgroundColor != '') {
      backgroundColor = Color(
        int.parse('FF${credentialModel.display.backgroundColor}', radix: 16),
      );
    } else {
      backgroundColor = defaultBackgroundColor;
    }
    return backgroundColor;
  }

  Color get defaultBackgroundColor {
    switch (this) {
      case CredentialSubjectType.identityPass:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.professionalExperienceAssessment:
        return const Color(0xFFFFADAD);
      case CredentialSubjectType.professionalSkillAssessment:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.residentCard:
        return Colors.white;
      case CredentialSubjectType.selfIssued:
        return const Color(0xffEFF0F6);
      case CredentialSubjectType.defaultCredential:
        return Colors.white;
      case CredentialSubjectType.ecole42LearningAchievement:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.loyaltyCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.professionalStudentCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.bloometaPass:
      case CredentialSubjectType.nationality:
      case CredentialSubjectType.tezotopiaMembership:
      case CredentialSubjectType.chainbornMembership:
      case CredentialSubjectType.twitterCard:
      case CredentialSubjectType.troopezPass:
      case CredentialSubjectType.pigsPass:
      case CredentialSubjectType.matterlightPass:
      case CredentialSubjectType.dogamiPass:
      case CredentialSubjectType.bunnyPass:
      case CredentialSubjectType.gender:
      case CredentialSubjectType.tezosAssociatedWallet:
      case CredentialSubjectType.verifiableIdCard:
      case CredentialSubjectType.linkedInCard:
      case CredentialSubjectType.over18:
      case CredentialSubjectType.over13:
      case CredentialSubjectType.passportFootprint:
      case CredentialSubjectType.certificateOfEmployment:
      case CredentialSubjectType.emailPass:
      case CredentialSubjectType.ageRange:
      case CredentialSubjectType.phonePass:
      case CredentialSubjectType.learningAchievement:
      case CredentialSubjectType.studentCard:
      case CredentialSubjectType.voucher:
      case CredentialSubjectType.tezVoucher:
      case CredentialSubjectType.diplomaCard:
      case CredentialSubjectType.talaoCommunityCard:
      case CredentialSubjectType.aragoPass:
      case CredentialSubjectType.aragoIdentityCard:
      case CredentialSubjectType.aragoLearningAchievement:
      case CredentialSubjectType.aragoEmailPass:
      case CredentialSubjectType.aragoOver18:
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
      case CredentialSubjectType.ethereumPooAddress:
      case CredentialSubjectType.fantomPooAddress:
      case CredentialSubjectType.polygonPooAddress:
      case CredentialSubjectType.binancePooAddress:
      case CredentialSubjectType.tezosPooAddress:
      case CredentialSubjectType.pcdsAgentCertificate:
        return Colors.white;
    }
  }

  IconData get iconData {
    switch (this) {
      case CredentialSubjectType.identityPass:
        return Icons.perm_identity;
      case CredentialSubjectType.professionalExperienceAssessment:
        return Icons.add_road_outlined;
      case CredentialSubjectType.professionalSkillAssessment:
        return Icons.assessment_outlined;
      case CredentialSubjectType.residentCard:
        return Icons.home;
      case CredentialSubjectType.selfIssued:
        return Icons.perm_identity;
      case CredentialSubjectType.defaultCredential:
        return Icons.fact_check_outlined;
      case CredentialSubjectType.ecole42LearningAchievement:
        return Icons.perm_identity;
      case CredentialSubjectType.loyaltyCard:
        return Icons.loyalty;
      case CredentialSubjectType.professionalStudentCard:
        return Icons.perm_identity;
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.bloometaPass:
      case CredentialSubjectType.nationality:
      case CredentialSubjectType.tezotopiaMembership:
      case CredentialSubjectType.chainbornMembership:
      case CredentialSubjectType.twitterCard:
      case CredentialSubjectType.troopezPass:
      case CredentialSubjectType.pigsPass:
      case CredentialSubjectType.matterlightPass:
      case CredentialSubjectType.dogamiPass:
      case CredentialSubjectType.bunnyPass:
      case CredentialSubjectType.gender:
      case CredentialSubjectType.tezosAssociatedWallet:
      case CredentialSubjectType.verifiableIdCard:
      case CredentialSubjectType.linkedInCard:
      case CredentialSubjectType.over18:
      case CredentialSubjectType.over13:
      case CredentialSubjectType.passportFootprint:
      case CredentialSubjectType.certificateOfEmployment:
      case CredentialSubjectType.emailPass:
      case CredentialSubjectType.ageRange:
      case CredentialSubjectType.phonePass:
      case CredentialSubjectType.learningAchievement:
      case CredentialSubjectType.studentCard:
      case CredentialSubjectType.voucher:
      case CredentialSubjectType.tezVoucher:
      case CredentialSubjectType.diplomaCard:
      case CredentialSubjectType.talaoCommunityCard:
      case CredentialSubjectType.aragoPass:
      case CredentialSubjectType.aragoIdentityCard:
      case CredentialSubjectType.aragoLearningAchievement:
      case CredentialSubjectType.aragoEmailPass:
      case CredentialSubjectType.aragoOver18:
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
      case CredentialSubjectType.ethereumPooAddress:
      case CredentialSubjectType.fantomPooAddress:
      case CredentialSubjectType.polygonPooAddress:
      case CredentialSubjectType.binancePooAddress:
      case CredentialSubjectType.tezosPooAddress:
      case CredentialSubjectType.pcdsAgentCertificate:
        return Icons.perm_identity;
    }
  }

  bool get isDisabled {
    if (this == CredentialSubjectType.dogamiPass ||
        this == CredentialSubjectType.pigsPass ||
        this == CredentialSubjectType.bunnyPass ||
        this == CredentialSubjectType.troopezPass ||
        this == CredentialSubjectType.matterlightPass) {
      return true;
    }
    return false;
  }

  String get name {
    switch (this) {
      case CredentialSubjectType.bloometaPass:
        return 'BloometaPass';
      case CredentialSubjectType.troopezPass:
        return 'TroopezPass';
      case CredentialSubjectType.pigsPass:
        return 'PigsPass';
      case CredentialSubjectType.matterlightPass:
        return 'MatterlightPass';
      case CredentialSubjectType.dogamiPass:
        return 'DogamiPass';
      case CredentialSubjectType.bunnyPass:
        return 'BunnyPass';
      case CredentialSubjectType.tezotopiaMembership:
        return 'MembershipCard_1';
      case CredentialSubjectType.chainbornMembership:
        return 'Chainborn_MembershipCard';
      case CredentialSubjectType.twitterCard:
        return 'TwitterAccountProof';
      case CredentialSubjectType.ageRange:
        return 'AgeRange';
      case CredentialSubjectType.nationality:
        return 'Nationality';
      case CredentialSubjectType.gender:
        return 'Gender';
      case CredentialSubjectType.walletCredential:
        return 'WalletCredential';
      case CredentialSubjectType.tezosAssociatedWallet:
        return 'TezosAssociatedAddress';
      case CredentialSubjectType.ethereumAssociatedWallet:
        return 'EthereumAssociatedAddress';
      case CredentialSubjectType.fantomAssociatedWallet:
        return 'FantomAssociatedAddress';
      case CredentialSubjectType.polygonAssociatedWallet:
        return 'PolygonAssociatedAddress';
      case CredentialSubjectType.binanceAssociatedWallet:
        return 'BinanceAssociatedAddress';
      case CredentialSubjectType.ethereumPooAddress:
        return 'EthereumPooAddress';
      case CredentialSubjectType.fantomPooAddress:
        return 'FantomPooAddress';
      case CredentialSubjectType.polygonPooAddress:
        return 'PolygonPooAddress';
      case CredentialSubjectType.binancePooAddress:
        return 'BinancePooAddress';
      case CredentialSubjectType.tezosPooAddress:
        return 'TezosPooAddress';
      case CredentialSubjectType.certificateOfEmployment:
        return 'CertificateOfEmployment';
      case CredentialSubjectType.ecole42LearningAchievement:
        return 'Ecole42LearningAchievement';
      case CredentialSubjectType.emailPass:
        return 'EmailPass';
      case CredentialSubjectType.identityPass:
        return 'IdentityPass';
      case CredentialSubjectType.verifiableIdCard:
        return 'VerifiableId';
      case CredentialSubjectType.linkedInCard:
        return 'LinkedinCard';
      case CredentialSubjectType.learningAchievement:
        return 'LearningAchievement';
      case CredentialSubjectType.loyaltyCard:
        return 'LoyaltyCard';
      case CredentialSubjectType.over18:
        return 'Over18';
      case CredentialSubjectType.over13:
        return 'Over13';
      case CredentialSubjectType.passportFootprint:
        return 'PassportNumber';
      case CredentialSubjectType.phonePass:
        return 'PhoneProof';
      case CredentialSubjectType.professionalExperienceAssessment:
        return 'ProfessionalExperienceAssessment';
      case CredentialSubjectType.professionalSkillAssessment:
        return 'ProfessionalSkillAssessment';
      case CredentialSubjectType.professionalStudentCard:
        return 'ProfessionalStudentCard';
      case CredentialSubjectType.residentCard:
        return 'ResidentCard';
      case CredentialSubjectType.selfIssued:
        return 'SelfIssued';
      case CredentialSubjectType.studentCard:
        return 'StudentCard';
      case CredentialSubjectType.voucher:
        return 'Voucher';
      case CredentialSubjectType.tezVoucher:
        return 'TezVoucher_1';
      case CredentialSubjectType.talaoCommunityCard:
        return 'TalaoCommunity';
      case CredentialSubjectType.diplomaCard:
        return 'VerifiableDiploma';
      case CredentialSubjectType.aragoPass:
        return 'AragoPass';
      case CredentialSubjectType.aragoEmailPass:
        return 'AragoEmailPass';
      case CredentialSubjectType.aragoIdentityCard:
        return 'AragoIdCard';
      case CredentialSubjectType.aragoLearningAchievement:
        return 'AragoLearningAchievement';
      case CredentialSubjectType.aragoOver18:
        return 'AragoOver18';
      case CredentialSubjectType.pcdsAgentCertificate:
        return 'PCDSAgentCertificate';
      case CredentialSubjectType.defaultCredential:
        return '';
    }
  }

  CredentialSubjectModel modelFromJson(Map<String, dynamic> json) {
    switch (this) {
      case CredentialSubjectType.bloometaPass:
        return BloometaPassModel.fromJson(json);
      case CredentialSubjectType.troopezPass:
        return TroopezPassModel.fromJson(json);
      case CredentialSubjectType.pigsPass:
        return PigsPassModel.fromJson(json);
      case CredentialSubjectType.matterlightPass:
        return MatterlightPassModel.fromJson(json);
      case CredentialSubjectType.dogamiPass:
        return DogamiPassModel.fromJson(json);
      case CredentialSubjectType.bunnyPass:
        return BunnyPassModel.fromJson(json);
      case CredentialSubjectType.tezotopiaMembership:
        return TezotopiaMembershipModel.fromJson(json);
      case CredentialSubjectType.chainbornMembership:
        return ChainbornMembershipModel.fromJson(json);
      case CredentialSubjectType.twitterCard:
        return TwitterCardModel.fromJson(json);
      case CredentialSubjectType.ageRange:
        return AgeRangeModel.fromJson(json);
      case CredentialSubjectType.nationality:
        return NationalityModel.fromJson(json);
      case CredentialSubjectType.gender:
        return GenderModel.fromJson(json);
      case CredentialSubjectType.walletCredential:
        return WalletCredentialModel.fromJson(json);
      case CredentialSubjectType.tezosAssociatedWallet:
        return TezosAssociatedAddressModel.fromJson(json);
      case CredentialSubjectType.ethereumAssociatedWallet:
        return EthereumAssociatedAddressModel.fromJson(json);
      case CredentialSubjectType.fantomAssociatedWallet:
        return FantomAssociatedAddressModel.fromJson(json);
      case CredentialSubjectType.polygonAssociatedWallet:
        return PolygonAssociatedAddressModel.fromJson(json);
      case CredentialSubjectType.binanceAssociatedWallet:
        return BinanceAssociatedAddressModel.fromJson(json);
      case CredentialSubjectType.certificateOfEmployment:
        return CertificateOfEmploymentModel.fromJson(json);
      case CredentialSubjectType.defaultCredential:
        return DefaultCredentialSubjectModel.fromJson(json);
      case CredentialSubjectType.ecole42LearningAchievement:
        return Ecole42LearningAchievementModel.fromJson(json);
      case CredentialSubjectType.emailPass:
        return EmailPassModel.fromJson(json);
      case CredentialSubjectType.identityPass:
        return IdentityPassModel.fromJson(json);
      case CredentialSubjectType.verifiableIdCard:
        return VerifiableIdCardModel.fromJson(json);
      case CredentialSubjectType.learningAchievement:
        return LearningAchievementModel.fromJson(json);
      case CredentialSubjectType.loyaltyCard:
        return LoyaltyCardModel.fromJson(json);
      case CredentialSubjectType.over18:
        return Over18Model.fromJson(json);
      case CredentialSubjectType.over13:
        return Over13Model.fromJson(json);
      case CredentialSubjectType.passportFootprint:
        return PassportFootprintModel.fromJson(json);
      case CredentialSubjectType.phonePass:
        return PhonePassModel.fromJson(json);
      case CredentialSubjectType.professionalExperienceAssessment:
        return ProfessionalExperienceAssessmentModel.fromJson(json);
      case CredentialSubjectType.professionalSkillAssessment:
        return ProfessionalSkillAssessmentModel.fromJson(json);
      case CredentialSubjectType.professionalStudentCard:
        return ProfessionalStudentCardModel.fromJson(json);
      case CredentialSubjectType.residentCard:
        return ResidentCardModel.fromJson(json);
      case CredentialSubjectType.selfIssued:
        return SelfIssuedModel.fromJson(json);
      case CredentialSubjectType.studentCard:
        return StudentCardModel.fromJson(json);
      case CredentialSubjectType.voucher:
        return VoucherModel.fromJson(json);
      case CredentialSubjectType.tezVoucher:
        return TezotopiaVoucherModel.fromJson(json);
      case CredentialSubjectType.talaoCommunityCard:
        return TalaoCommunityCardModel.fromJson(json);
      case CredentialSubjectType.diplomaCard:
        return DiplomaCardModel.fromJson(json);
      case CredentialSubjectType.aragoPass:
        return AragoPassModel.fromJson(json);
      case CredentialSubjectType.aragoEmailPass:
        return AragoEmailPassModel.fromJson(json);
      case CredentialSubjectType.aragoIdentityCard:
        return AragoIdentityCardModel.fromJson(json);
      case CredentialSubjectType.aragoLearningAchievement:
        return AragoLearningAchievementModel.fromJson(json);
      case CredentialSubjectType.aragoOver18:
        return AragoOver18Model.fromJson(json);
      case CredentialSubjectType.pcdsAgentCertificate:
        return PcdsAgentCertificateModel.fromJson(json);
      case CredentialSubjectType.linkedInCard:
        return LinkedinCardModel.fromJson(json);
      case CredentialSubjectType.ethereumPooAddress:
        return EthereumPooAddressModel.fromJson(json);
      case CredentialSubjectType.fantomPooAddress:
        return FantomPooAddressModel.fromJson(json);
      case CredentialSubjectType.polygonPooAddress:
        return PolygonPooAddressModel.fromJson(json);
      case CredentialSubjectType.binancePooAddress:
        return BinancePooAddressModel.fromJson(json);
      case CredentialSubjectType.tezosPooAddress:
        return TezosPooAddressModel.fromJson(json);
    }
  }

  bool get checkForAIKYC {
    if (this == CredentialSubjectType.over18 ||
        this == CredentialSubjectType.over13 ||
        this == CredentialSubjectType.ageRange) {
      return true;
    }
    return false;
  }

  bool get byPassDeepLink {
    if (this == CredentialSubjectType.tezotopiaMembership ||
        this == CredentialSubjectType.chainbornMembership ||
        this == CredentialSubjectType.twitterCard ||
        this == CredentialSubjectType.over13 ||
        this == CredentialSubjectType.over18 ||
        this == CredentialSubjectType.verifiableIdCard ||
        this == CredentialSubjectType.ageRange ||
        this == CredentialSubjectType.nationality ||
        this == CredentialSubjectType.gender ||
        this == CredentialSubjectType.passportFootprint ||
        this == CredentialSubjectType.linkedInCard) {
      return true;
    }
    return false;
  }
}
