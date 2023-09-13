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
      case CredentialSubjectType.defiCompliance:
        return const Color.fromARGB(255, 62, 15, 163);
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
      case CredentialSubjectType.professionalStudentCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.kycAgeCredential:
        return const Color(0xff8247E5);
      case CredentialSubjectType.kycCountryOfResidence:
        return const Color(0xff8247E5);
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
      case CredentialSubjectType.over15:
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
      case CredentialSubjectType.euDiplomaCard:
      case CredentialSubjectType.euVerifiableId:
      case CredentialSubjectType.proofOfTwitterStats:
      case CredentialSubjectType.civicPassCredential:
      case CredentialSubjectType.employeeCredential:
      case CredentialSubjectType.legalPersonalCredential:
        return Colors.white;
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
      case CredentialSubjectType.defiCompliance:
        return 'DefiCompliance';
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
      case CredentialSubjectType.over18:
        return 'Over18';
      case CredentialSubjectType.over13:
        return 'Over13';
      case CredentialSubjectType.over15:
        return 'Over15';
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
      case CredentialSubjectType.employeeCredential:
        return 'EmployeeCredential';
      case CredentialSubjectType.legalPersonalCredential:
        return 'LegalPersonCredential';
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
      case CredentialSubjectType.euDiplomaCard:
        return 'https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd';
      case CredentialSubjectType.euVerifiableId:
        return 'https://api-conformance.ebsi.eu/trusted-schemas-registry/v2/schemas/z22ZAMdQtNLwi51T2vdZXGGZaYyjrsuP1yzWyXZirCAHv';
      case CredentialSubjectType.kycAgeCredential:
        return 'KYCAgeCredential';
      case CredentialSubjectType.kycCountryOfResidence:
        return 'KYCCountryOfResidenceCredential';
      case CredentialSubjectType.proofOfTwitterStats:
        return 'ProofOfTwitterStats';
      case CredentialSubjectType.civicPassCredential:
        return 'CivicPassCredential';
      case CredentialSubjectType.defaultCredential:
        return '';
    }
  }

  CredentialSubjectModel modelFromJson(Map<String, dynamic> json) {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
        return DefiComplianceModel.fromJson(json);
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
      case CredentialSubjectType.over18:
        return Over18Model.fromJson(json);
      case CredentialSubjectType.over13:
        return Over13Model.fromJson(json);
      case CredentialSubjectType.over15:
        return Over15Model.fromJson(json);
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
      case CredentialSubjectType.euDiplomaCard:
        return EUDiplomaCardModel.fromJson(json);
      case CredentialSubjectType.euVerifiableId:
        return EUVerifiableIdModel.fromJson(json);
      case CredentialSubjectType.kycAgeCredential:
        return KYCAgeCredentialModel.fromJson(json);
      case CredentialSubjectType.kycCountryOfResidence:
        return KYCCountryOfResidenceModel.fromJson(json);
      case CredentialSubjectType.proofOfTwitterStats:
        return ProofOfTwitterStatsModel.fromJson(json);
      case CredentialSubjectType.civicPassCredential:
        return CivicPassCredentialModel.fromJson(json);
      case CredentialSubjectType.employeeCredential:
        return EmployeeCredentialModel.fromJson(json);
      case CredentialSubjectType.legalPersonalCredential:
        return LegalPersonCredentialModel.fromJson(json);
    }
  }

  bool get checkForAIKYC {
    if (this == CredentialSubjectType.over18 ||
        this == CredentialSubjectType.over13 ||
        this == CredentialSubjectType.over15 ||
        this == CredentialSubjectType.ageRange ||
        this == CredentialSubjectType.defiCompliance) {
      return true;
    }
    return false;
  }

  KycVcType get getKycVcType {
    if (this == CredentialSubjectType.over18) {
      return KycVcType.over18;
    } else if (this == CredentialSubjectType.over13) {
      return KycVcType.over13;
    } else if (this == CredentialSubjectType.over15) {
      return KycVcType.over15;
    } else if (this == CredentialSubjectType.ageRange) {
      return KycVcType.ageRange;
    } else if (this == CredentialSubjectType.defiCompliance) {
      return KycVcType.defiCompliance;
    } else {
      return KycVcType.verifiableId;
    }
  }

  bool get byPassDeepLink {
    if (this == CredentialSubjectType.tezotopiaMembership ||
        this == CredentialSubjectType.chainbornMembership ||
        this == CredentialSubjectType.twitterCard ||
        this == CredentialSubjectType.over13 ||
        this == CredentialSubjectType.over15 ||
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

  bool get isEbsiCard {
    if (this == CredentialSubjectType.euDiplomaCard ||
        this == CredentialSubjectType.euVerifiableId) {
      return true;
    }
    return false;
  }

  bool get isBlockchainAccount {
    if (this == CredentialSubjectType.tezosAssociatedWallet ||
        this == CredentialSubjectType.ethereumAssociatedWallet ||
        this == CredentialSubjectType.binanceAssociatedWallet ||
        this == CredentialSubjectType.fantomAssociatedWallet ||
        this == CredentialSubjectType.polygonAssociatedWallet) {
      return true;
    }
    return false;
  }

  Widget? get blockchainWidget {
    if (this == CredentialSubjectType.tezosAssociatedWallet) {
      return const TezosAssociatedAddressWidget();
    } else if (this == CredentialSubjectType.ethereumAssociatedWallet) {
      return const EthereumAssociatedAddressWidget();
    } else if (this == CredentialSubjectType.polygonAssociatedWallet) {
      return const PolygonAssociatedAddressWidget();
    } else if (this == CredentialSubjectType.binanceAssociatedWallet) {
      return const BinanceAssociatedAddressWidget();
    } else if (this == CredentialSubjectType.tezosAssociatedWallet) {
      return const TezosAssociatedAddressWidget();
    } else if (this == CredentialSubjectType.fantomAssociatedWallet) {
      return const FantomAssociatedAddressWidget();
    }
    return null;
  }

  String get title {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
        return 'Defi Compliance';
      case CredentialSubjectType.bloometaPass:
        return 'Bloometa';
      case CredentialSubjectType.troopezPass:
        return 'Troopez Pass';
      case CredentialSubjectType.pigsPass:
        return 'Pigs Pass';
      case CredentialSubjectType.matterlightPass:
        return 'Matterlight Pass';
      case CredentialSubjectType.dogamiPass:
        return 'Dogami Pass';
      case CredentialSubjectType.bunnyPass:
        return 'Bunny Pass';
      case CredentialSubjectType.tezotopiaMembership:
        return 'Membership Card';
      case CredentialSubjectType.chainbornMembership:
        return 'Chainborn';
      case CredentialSubjectType.twitterCard:
        return 'Twitter Account Proof';
      case CredentialSubjectType.ageRange:
        return 'Age Range';
      case CredentialSubjectType.nationality:
        return 'Nationality';
      case CredentialSubjectType.gender:
        return 'Gender';
      case CredentialSubjectType.walletCredential:
        return 'Wallet Credential';
      case CredentialSubjectType.tezosAssociatedWallet:
        return 'Tezos Associated Address';
      case CredentialSubjectType.ethereumAssociatedWallet:
        return 'Ethereum Associated Address';
      case CredentialSubjectType.fantomAssociatedWallet:
        return 'Fantom Associated Address';
      case CredentialSubjectType.polygonAssociatedWallet:
        return 'Polygon Associated Address';
      case CredentialSubjectType.binanceAssociatedWallet:
        return 'BNB Chain Associated Address';
      case CredentialSubjectType.ethereumPooAddress:
        return 'Ethereum Poo Address';
      case CredentialSubjectType.fantomPooAddress:
        return 'Fantom Poo Address';
      case CredentialSubjectType.polygonPooAddress:
        return 'Polygon Poo Address';
      case CredentialSubjectType.binancePooAddress:
        return 'BNB Chain Poo Address';
      case CredentialSubjectType.tezosPooAddress:
        return 'Tezos Poo Address';
      case CredentialSubjectType.certificateOfEmployment:
        return 'Certificate of Employment';
      case CredentialSubjectType.ecole42LearningAchievement:
        return 'Ecole42 Learning Achievement';
      case CredentialSubjectType.emailPass:
        return 'Email Pass';
      case CredentialSubjectType.identityPass:
        return 'Identity Pass';
      case CredentialSubjectType.verifiableIdCard:
        return 'VerifiableId';
      case CredentialSubjectType.linkedInCard:
        return 'Linkedin Card';
      case CredentialSubjectType.learningAchievement:
        return 'Learning Achievement';
      case CredentialSubjectType.over18:
        return 'Over18';
      case CredentialSubjectType.over13:
        return 'Over13';
      case CredentialSubjectType.over15:
        return 'Over15';
      case CredentialSubjectType.passportFootprint:
        return 'Passport Number';
      case CredentialSubjectType.phonePass:
        return 'Phone Proof';
      case CredentialSubjectType.professionalExperienceAssessment:
        return 'Professional Experience Assessment';
      case CredentialSubjectType.professionalSkillAssessment:
        return 'Professional Skill Assessment';
      case CredentialSubjectType.professionalStudentCard:
        return 'Professional Student Card';
      case CredentialSubjectType.residentCard:
        return 'Resident Card';
      case CredentialSubjectType.selfIssued:
        return 'Self Issued';
      case CredentialSubjectType.studentCard:
        return 'Student Card';
      case CredentialSubjectType.voucher:
        return 'Voucher';
      case CredentialSubjectType.tezVoucher:
        return 'TezVoucher';
      case CredentialSubjectType.talaoCommunityCard:
        return 'Talao Community';
      case CredentialSubjectType.diplomaCard:
        return 'Verifiable Diploma';
      case CredentialSubjectType.aragoPass:
        return 'Arago Pass';
      case CredentialSubjectType.aragoEmailPass:
        return 'Arago Email Pass';
      case CredentialSubjectType.aragoIdentityCard:
        return 'Arago Id Card';
      case CredentialSubjectType.aragoLearningAchievement:
        return 'Arago Learning Achievement';
      case CredentialSubjectType.aragoOver18:
        return 'Arago Over18';
      case CredentialSubjectType.pcdsAgentCertificate:
        return 'PCDS Agent Certificate';
      case CredentialSubjectType.euDiplomaCard:
        return 'EU Diploma';
      case CredentialSubjectType.euVerifiableId:
        return 'EU VerifiableID';
      case CredentialSubjectType.kycAgeCredential:
        return 'KYC Age Credential';
      case CredentialSubjectType.kycCountryOfResidence:
        return 'KYC Country of Residence';
      case CredentialSubjectType.proofOfTwitterStats:
        return 'Proof Of Twitter Stats';
      case CredentialSubjectType.civicPassCredential:
        return 'Civic Pass Credential';
      case CredentialSubjectType.employeeCredential:
        return 'Employee Credential';
      case CredentialSubjectType.legalPersonalCredential:
        return 'Legal Person Credential';
      case CredentialSubjectType.defaultCredential:
        return '';
    }
  }

  bool get weCanRemoveItIfCredentialExist {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
      case CredentialSubjectType.bloometaPass:
      case CredentialSubjectType.tezotopiaMembership:
      case CredentialSubjectType.chainbornMembership:
      case CredentialSubjectType.ageRange:
      case CredentialSubjectType.nationality:
      case CredentialSubjectType.gender:
      case CredentialSubjectType.identityPass:
      case CredentialSubjectType.verifiableIdCard:
      case CredentialSubjectType.over18:
      case CredentialSubjectType.over13:
      case CredentialSubjectType.over15:
      case CredentialSubjectType.passportFootprint:
      case CredentialSubjectType.residentCard:
      case CredentialSubjectType.voucher:
      case CredentialSubjectType.tezVoucher:
      case CredentialSubjectType.diplomaCard:
      case CredentialSubjectType.twitterCard:
        return true;
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.tezosAssociatedWallet:
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
      case CredentialSubjectType.tezosPooAddress:
      case CredentialSubjectType.ethereumPooAddress:
      case CredentialSubjectType.fantomPooAddress:
      case CredentialSubjectType.polygonPooAddress:
      case CredentialSubjectType.binancePooAddress:
      case CredentialSubjectType.certificateOfEmployment:
      case CredentialSubjectType.defaultCredential:
      case CredentialSubjectType.ecole42LearningAchievement:
      case CredentialSubjectType.emailPass:
      case CredentialSubjectType.troopezPass:
      case CredentialSubjectType.pigsPass:
      case CredentialSubjectType.matterlightPass:
      case CredentialSubjectType.dogamiPass:
      case CredentialSubjectType.bunnyPass:
      case CredentialSubjectType.linkedInCard:
      case CredentialSubjectType.learningAchievement:
      case CredentialSubjectType.phonePass:
      case CredentialSubjectType.professionalExperienceAssessment:
      case CredentialSubjectType.professionalSkillAssessment:
      case CredentialSubjectType.professionalStudentCard:
      case CredentialSubjectType.selfIssued:
      case CredentialSubjectType.studentCard:
      case CredentialSubjectType.talaoCommunityCard:
      case CredentialSubjectType.aragoPass:
      case CredentialSubjectType.aragoEmailPass:
      case CredentialSubjectType.aragoIdentityCard:
      case CredentialSubjectType.aragoLearningAchievement:
      case CredentialSubjectType.aragoOver18:
      case CredentialSubjectType.pcdsAgentCertificate:
      case CredentialSubjectType.euDiplomaCard:
      case CredentialSubjectType.euVerifiableId:
      case CredentialSubjectType.kycAgeCredential:
      case CredentialSubjectType.kycCountryOfResidence:
      case CredentialSubjectType.proofOfTwitterStats:
      case CredentialSubjectType.civicPassCredential:
      case CredentialSubjectType.employeeCredential:
      case CredentialSubjectType.legalPersonalCredential:
        return false;
    }
  }

  // Future changes will be made to values where 0 appears
  double get order {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
        return 0;
      case CredentialSubjectType.bloometaPass:
        return 76;
      case CredentialSubjectType.troopezPass:
        return 73;
      case CredentialSubjectType.pigsPass:
        return 75;
      case CredentialSubjectType.matterlightPass:
        return 74;
      case CredentialSubjectType.dogamiPass:
        return 78;
      case CredentialSubjectType.bunnyPass:
        return 77;
      case CredentialSubjectType.tezotopiaMembership:
        return 79;
      case CredentialSubjectType.chainbornMembership:
        return 72;
      case CredentialSubjectType.ageRange:
        return 94;
      case CredentialSubjectType.nationality:
        return 97.3;
      case CredentialSubjectType.gender:
        return 93;
      case CredentialSubjectType.walletCredential:
        return 0;
      case CredentialSubjectType.tezosAssociatedWallet:
        return 68;
      case CredentialSubjectType.ethereumAssociatedWallet:
        return 69;
      case CredentialSubjectType.fantomAssociatedWallet:
        return 67;
      case CredentialSubjectType.polygonAssociatedWallet:
        return 71;
      case CredentialSubjectType.binanceAssociatedWallet:
        return 70;
      case CredentialSubjectType.tezosPooAddress:
        return 0;
      case CredentialSubjectType.ethereumPooAddress:
        return 0;
      case CredentialSubjectType.fantomPooAddress:
        return 0;
      case CredentialSubjectType.polygonPooAddress:
        return 0;
      case CredentialSubjectType.binancePooAddress:
        return 0;
      case CredentialSubjectType.certificateOfEmployment:
        return 85;
      case CredentialSubjectType.defaultCredential:
        return 0;
      case CredentialSubjectType.ecole42LearningAchievement:
        return 0;
      case CredentialSubjectType.emailPass:
        return 99;
      case CredentialSubjectType.identityPass:
        return 90;
      case CredentialSubjectType.verifiableIdCard:
        return 97.5;
      case CredentialSubjectType.linkedInCard:
        return 86;
      case CredentialSubjectType.learningAchievement:
        return 0;
      case CredentialSubjectType.over18:
        return 97;
      case CredentialSubjectType.over13:
        return 95;
      case CredentialSubjectType.over15:
        return 96;
      case CredentialSubjectType.passportFootprint:
        return 91;
      case CredentialSubjectType.phonePass:
        return 98;
      case CredentialSubjectType.professionalExperienceAssessment:
        return 0;
      case CredentialSubjectType.professionalSkillAssessment:
        return 0;
      case CredentialSubjectType.professionalStudentCard:
        return 87;
      case CredentialSubjectType.residentCard:
        return 0;
      case CredentialSubjectType.selfIssued:
        return 0;
      case CredentialSubjectType.studentCard:
        return 88;
      case CredentialSubjectType.voucher:
        return 81;
      case CredentialSubjectType.tezVoucher:
        return 80;
      case CredentialSubjectType.talaoCommunityCard:
        return 84;
      case CredentialSubjectType.diplomaCard:
        return 89;
      case CredentialSubjectType.aragoPass:
        return 81;
      case CredentialSubjectType.aragoEmailPass:
        return 0;
      case CredentialSubjectType.aragoIdentityCard:
        return 0;
      case CredentialSubjectType.aragoLearningAchievement:
        return 0;
      case CredentialSubjectType.aragoOver18:
        return 0;
      case CredentialSubjectType.pcdsAgentCertificate:
        return 82;
      case CredentialSubjectType.twitterCard:
        return 83;
      case CredentialSubjectType.euDiplomaCard:
        return 67;
      case CredentialSubjectType.euVerifiableId:
        return 92;
      case CredentialSubjectType.kycAgeCredential:
        return 0;
      case CredentialSubjectType.kycCountryOfResidence:
      case CredentialSubjectType.proofOfTwitterStats:
      case CredentialSubjectType.civicPassCredential:
      case CredentialSubjectType.employeeCredential:
      case CredentialSubjectType.legalPersonalCredential:
        return 0;
    }
  }
}
