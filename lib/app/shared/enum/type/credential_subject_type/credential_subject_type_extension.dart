part of 'credential_subject_type.dart';

extension CredentialSubjectTypeExtension on CredentialSubjectType {
  Color backgroundColor(CredentialModel credentialModel) {
    try {
      final Color backgroundColor;
      if (credentialModel.display?.backgroundColor != null) {
        backgroundColor = Color(
          int.parse(
            // ignore: lines_longer_than_80_chars
            'FF${credentialModel.display?.backgroundColor!.replaceAll('#', '')}',
            radix: 16,
          ),
        );
      } else {
        backgroundColor = defaultBackgroundColor;
      }
      return backgroundColor;
    } catch (e) {
      return defaultBackgroundColor;
    }
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
        return const Color(0xff6600FF);
      case CredentialSubjectType.professionalStudentCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.livenessCard:
      case CredentialSubjectType.nationality:
      case CredentialSubjectType.tezotopiaMembership:
      case CredentialSubjectType.chainbornMembership:
      case CredentialSubjectType.twitterCard:
      case CredentialSubjectType.gender:
      case CredentialSubjectType.tezosAssociatedWallet:
      case CredentialSubjectType.verifiableIdCard:
      case CredentialSubjectType.over13:
      case CredentialSubjectType.over15:
      case CredentialSubjectType.over18:
      case CredentialSubjectType.over21:
      case CredentialSubjectType.over50:
      case CredentialSubjectType.over65:
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
      case CredentialSubjectType.aragoPass:
      case CredentialSubjectType.aragoIdentityCard:
      case CredentialSubjectType.aragoLearningAchievement:
      case CredentialSubjectType.aragoEmailPass:
      case CredentialSubjectType.aragoOver18:
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
      case CredentialSubjectType.etherlinkAssociatedWallet:
      case CredentialSubjectType.ethereumPooAddress:
      case CredentialSubjectType.fantomPooAddress:
      case CredentialSubjectType.polygonPooAddress:
      case CredentialSubjectType.binancePooAddress:
      case CredentialSubjectType.tezosPooAddress:
      case CredentialSubjectType.pcdsAgentCertificate:
      case CredentialSubjectType.euDiplomaCard:
      case CredentialSubjectType.euVerifiableId:
      case CredentialSubjectType.employeeCredential:
      case CredentialSubjectType.legalPersonalCredential:
      case CredentialSubjectType.identityCredential:
      case CredentialSubjectType.eudiPid:
      case CredentialSubjectType.pid:
        return const Color(0xff6600FF);
    }
  }

  String get name {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
        return 'DefiCompliance';
      case CredentialSubjectType.livenessCard:
        return 'Liveness';
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
      case CredentialSubjectType.etherlinkAssociatedWallet:
        return 'EtherlinkAssociatedAddress';
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
      case CredentialSubjectType.emailPass:
        return 'EmailPass';
      case CredentialSubjectType.identityPass:
        return 'IdentityPass';
      case CredentialSubjectType.verifiableIdCard:
        return 'VerifiableId';
      case CredentialSubjectType.learningAchievement:
        return 'LearningAchievement';
      case CredentialSubjectType.over13:
        return 'Over13';
      case CredentialSubjectType.over15:
        return 'Over15';
      case CredentialSubjectType.over18:
        return 'Over18';
      case CredentialSubjectType.over21:
        return 'Over21';
      case CredentialSubjectType.over50:
        return 'Over50';
      case CredentialSubjectType.over65:
        return 'Over65';
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
      case CredentialSubjectType.identityCredential:
        return 'IdentityCredential';
      case CredentialSubjectType.eudiPid:
        return 'EudiPid';
      case CredentialSubjectType.pid:
        return 'Pid';
      case CredentialSubjectType.defaultCredential:
        return '';
    }
  }

  CredentialSubjectModel modelFromJson(Map<String, dynamic> json) {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
        return DefiComplianceModel.fromJson(json);
      case CredentialSubjectType.livenessCard:
        return LivenessCardModel.fromJson(json);
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
      case CredentialSubjectType.etherlinkAssociatedWallet:
        return EtherlinkAssociatedAddressModel.fromJson(json);
      case CredentialSubjectType.certificateOfEmployment:
        return CertificateOfEmploymentModel.fromJson(json);
      case CredentialSubjectType.emailPass:
        return EmailPassModel.fromJson(json);
      case CredentialSubjectType.identityPass:
        return IdentityPassModel.fromJson(json);
      case CredentialSubjectType.verifiableIdCard:
        return VerifiableIdCardModel.fromJson(json);
      case CredentialSubjectType.learningAchievement:
        return LearningAchievementModel.fromJson(json);
      case CredentialSubjectType.over13:
        return Over13Model.fromJson(json);
      case CredentialSubjectType.over15:
        return Over15Model.fromJson(json);
      case CredentialSubjectType.over18:
        return Over18Model.fromJson(json);
      case CredentialSubjectType.over21:
        return Over21Model.fromJson(json);
      case CredentialSubjectType.over50:
        return Over50Model.fromJson(json);
      case CredentialSubjectType.over65:
        return Over65Model.fromJson(json);
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
      case CredentialSubjectType.employeeCredential:
        return EmployeeCredentialModel.fromJson(json);
      case CredentialSubjectType.legalPersonalCredential:
        return LegalPersonCredentialModel.fromJson(json);
      case CredentialSubjectType.defaultCredential:
        return DefaultCredentialSubjectModel.fromJson(json);
      case CredentialSubjectType.identityCredential:
        return IdentityCredentialSubjectModel.fromJson(json);
      case CredentialSubjectType.eudiPid:
        return EudipidSubjectModel.fromJson(json);
      case CredentialSubjectType.pid:
        return PidSubjectModel.fromJson(json);
    }
  }

  bool get checkForAIKYC {
    if (this == CredentialSubjectType.over18 ||
        this == CredentialSubjectType.over13 ||
        this == CredentialSubjectType.over15 ||
        this == CredentialSubjectType.over21 ||
        this == CredentialSubjectType.over50 ||
        this == CredentialSubjectType.over65 ||
        this == CredentialSubjectType.ageRange ||
        this == CredentialSubjectType.defiCompliance ||
        this == CredentialSubjectType.livenessCard) {
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
    } else if (this == CredentialSubjectType.over21) {
      return KycVcType.over21;
    } else if (this == CredentialSubjectType.over50) {
      return KycVcType.over50;
    } else if (this == CredentialSubjectType.over65) {
      return KycVcType.over65;
    } else if (this == CredentialSubjectType.ageRange) {
      return KycVcType.ageRange;
    } else if (this == CredentialSubjectType.defiCompliance) {
      return KycVcType.defiCompliance;
    } else {
      return KycVcType.verifiableId;
    }
  }

  String get aiValidationUrl {
    if (this == CredentialSubjectType.over13) {
      return Urls.over13AIValidationUrl;
    } else if (this == CredentialSubjectType.over15) {
      return Urls.over15AIValidationUrl;
    } else if (this == CredentialSubjectType.over18) {
      return Urls.over18AIValidationUrl;
    } else if (this == CredentialSubjectType.over21) {
      return Urls.over21AIValidationUrl;
    } else if (this == CredentialSubjectType.over50) {
      return Urls.over50AIValidationUrl;
    } else if (this == CredentialSubjectType.over65) {
      return Urls.over65AIValidationUrl;
    } else if (this == CredentialSubjectType.ageRange) {
      return Urls.ageRangeAIValidationUrl;
    } else {
      throw ResponseMessage(
        data: {
          'error': 'invalid_request',
          'error_description': 'Url is not specified for $name.',
        },
      );
    }
  }

  bool get byPassDeepLink {
    if (this == CredentialSubjectType.tezotopiaMembership ||
        this == CredentialSubjectType.chainbornMembership ||
        this == CredentialSubjectType.twitterCard ||
        this == CredentialSubjectType.over13 ||
        this == CredentialSubjectType.over15 ||
        this == CredentialSubjectType.over18 ||
        this == CredentialSubjectType.over21 ||
        this == CredentialSubjectType.over50 ||
        this == CredentialSubjectType.over65 ||
        this == CredentialSubjectType.verifiableIdCard ||
        this == CredentialSubjectType.ageRange ||
        this == CredentialSubjectType.nationality ||
        this == CredentialSubjectType.gender ||
        this == CredentialSubjectType.passportFootprint) {
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
        this == CredentialSubjectType.polygonAssociatedWallet ||
        this == CredentialSubjectType.etherlinkAssociatedWallet) {
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
    } else if (this == CredentialSubjectType.fantomAssociatedWallet) {
      return const FantomAssociatedAddressWidget();
    } else if (this == CredentialSubjectType.etherlinkAssociatedWallet) {
      return const EtherlinkAssociatedAddressWidget();
    }
    return null;
  }

  String get title {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
        return 'Defi Compliance';
      case CredentialSubjectType.livenessCard:
        return 'Liveness';
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
      case CredentialSubjectType.etherlinkAssociatedWallet:
        return 'Etherlink Associated Address';
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
      case CredentialSubjectType.emailPass:
        return 'Email Pass';
      case CredentialSubjectType.identityPass:
        return 'Identity Pass';
      case CredentialSubjectType.verifiableIdCard:
        return 'VerifiableId';
      case CredentialSubjectType.learningAchievement:
        return 'Learning Achievement';
      case CredentialSubjectType.over13:
        return 'Over13';
      case CredentialSubjectType.over15:
        return 'Over15';
      case CredentialSubjectType.over18:
        return 'Over18';
      case CredentialSubjectType.over21:
        return 'Over18';
      case CredentialSubjectType.over50:
        return 'Over18';
      case CredentialSubjectType.over65:
        return 'Over18';
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
      case CredentialSubjectType.employeeCredential:
        return 'Employee Credential';
      case CredentialSubjectType.legalPersonalCredential:
        return 'Legal Person Credential';
      case CredentialSubjectType.identityCredential:
        return 'Identity Credential';
      case CredentialSubjectType.eudiPid:
        return 'EudiPid';
      case CredentialSubjectType.pid:
        return 'Pid';
      case CredentialSubjectType.defaultCredential:
        return '';
    }
  }

  bool get supportSingleOnly {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
      case CredentialSubjectType.livenessCard:
      case CredentialSubjectType.tezotopiaMembership:
      case CredentialSubjectType.chainbornMembership:
      case CredentialSubjectType.ageRange:
      case CredentialSubjectType.nationality:
      case CredentialSubjectType.gender:
      case CredentialSubjectType.identityPass:
      case CredentialSubjectType.verifiableIdCard:
      case CredentialSubjectType.over13:
      case CredentialSubjectType.over15:
      case CredentialSubjectType.over18:
      case CredentialSubjectType.over21:
      case CredentialSubjectType.over50:
      case CredentialSubjectType.over65:
      case CredentialSubjectType.passportFootprint:
      case CredentialSubjectType.residentCard:
      case CredentialSubjectType.voucher:
      case CredentialSubjectType.tezVoucher:
      case CredentialSubjectType.diplomaCard:
      case CredentialSubjectType.twitterCard:
        return true;
      case CredentialSubjectType.tezosAssociatedWallet:
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
      case CredentialSubjectType.etherlinkAssociatedWallet:
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.tezosPooAddress:
      case CredentialSubjectType.ethereumPooAddress:
      case CredentialSubjectType.fantomPooAddress:
      case CredentialSubjectType.polygonPooAddress:
      case CredentialSubjectType.binancePooAddress:
      case CredentialSubjectType.certificateOfEmployment:
      case CredentialSubjectType.defaultCredential:
      case CredentialSubjectType.emailPass:
      case CredentialSubjectType.learningAchievement:
      case CredentialSubjectType.phonePass:
      case CredentialSubjectType.professionalExperienceAssessment:
      case CredentialSubjectType.professionalSkillAssessment:
      case CredentialSubjectType.professionalStudentCard:
      case CredentialSubjectType.selfIssued:
      case CredentialSubjectType.studentCard:
      case CredentialSubjectType.aragoPass:
      case CredentialSubjectType.aragoEmailPass:
      case CredentialSubjectType.aragoIdentityCard:
      case CredentialSubjectType.aragoLearningAchievement:
      case CredentialSubjectType.aragoOver18:
      case CredentialSubjectType.pcdsAgentCertificate:
      case CredentialSubjectType.euDiplomaCard:
      case CredentialSubjectType.euVerifiableId:
      case CredentialSubjectType.employeeCredential:
      case CredentialSubjectType.legalPersonalCredential:
      case CredentialSubjectType.identityCredential:
      case CredentialSubjectType.eudiPid:
      case CredentialSubjectType.pid:
        return false;
    }
  }

  DiscoverDummyCredential dummyCredential({
    required ProfileSetting profileSetting,
    required VCFormatType assignedVCFormatType,
  }) {
    String? image;
    String? link;
    String? websiteLink;
    ResponseString? whyGetThisCard;
    ResponseString? expirationDateDetails;
    ResponseString? howToGetIt;
    ResponseString? longDescription;

    /// handles the dummy casse

    final oidc4vcDraftType = profileSetting
        .selfSovereignIdentityOptions.customOidc4vcProfile.oidc4vciDraft;

    final isEmailPassOrPhonePass = this == CredentialSubjectType.emailPass ||
        this == CredentialSubjectType.phonePass;

    final format = assignedVCFormatType.urlValue(
      isEmailPassOrPhonePass: isEmailPassOrPhonePass,
    );

    switch (this) {
      case CredentialSubjectType.defiCompliance:
        image = ImageStrings.dummyDefiComplianceCard;
        link = '';
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_defiComplianceWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_defiComplianceExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_defiComplianceHowToGetIt;
      case CredentialSubjectType.ageRange:
        image = ImageStrings.dummyAgeRangeCard;
        link = '';
        whyGetThisCard = ResponseString.RESPONSE_STRING_ageRangeWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_ageRangeExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_ageRangeHowToGetIt;

      case CredentialSubjectType.nationality:
        image = ImageStrings.dummyNationalityCard;
        link = '';
        whyGetThisCard =
            ResponseString.RESPONSE_STRING_nationalityWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_nationalityExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_nationalityHowToGetIt;

      case CredentialSubjectType.gender:
        image = ImageStrings.dummyGenderCard;
        link = '';
        whyGetThisCard = ResponseString.RESPONSE_STRING_genderWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_genderExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_genderHowToGetIt;

      case CredentialSubjectType.emailPass:
        image = ImageStrings.dummyEmailPassCard;

        link = '${Urls.emailPassUrl}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format';

        whyGetThisCard = ResponseString.RESPONSE_STRING_emailPassWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_emailPassExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_emailPassHowToGetIt;

      case CredentialSubjectType.over13:
        image = ImageStrings.dummyOver13Card;

        link = '${Urls.id360Url}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format'
            '&type=over13';

        whyGetThisCard = ResponseString.RESPONSE_STRING_over13WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over13ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over13HowToGetIt;

      case CredentialSubjectType.over15:
        image = ImageStrings.dummyOver15Card;

        link = '${Urls.id360Url}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format'
            '&type=over15';

        whyGetThisCard = ResponseString.RESPONSE_STRING_over15WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over15ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over15HowToGetIt;

      case CredentialSubjectType.over18:
        image = ImageStrings.dummyOver18Card;

        link = '${Urls.id360Url}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format'
            '&type=over18';

        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;

      case CredentialSubjectType.over21:
        image = ImageStrings.dummyOver21Card;

        link = '${Urls.id360Url}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format'
            '&type=over21';

        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;

      case CredentialSubjectType.over50:
        image = ImageStrings.dummyOver50Card;

        link = '${Urls.id360Url}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format'
            '&type=over50';

        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;

      case CredentialSubjectType.over65:
        image = ImageStrings.dummyOver65Card;

        link = '${Urls.id360Url}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format'
            '&type=over65';

        whyGetThisCard = ResponseString.RESPONSE_STRING_over18WhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_over18ExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_over18HowToGetIt;

      case CredentialSubjectType.passportFootprint:
        image = ImageStrings.dummyPassportFootprintCard;
        link = '';
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

      case CredentialSubjectType.verifiableIdCard:
        var type = 'verifiableid';
        image = ImageStrings.dummyVerifiableIdCard;

        final discoverCardsOptions = profileSetting.discoverCardsOptions;

        if (discoverCardsOptions != null) {
          if (discoverCardsOptions.displayVerifiableIdSdJwt &&
              (assignedVCFormatType == VCFormatType.vcSdJWT ||
                  assignedVCFormatType == VCFormatType.dcSdJWT)) {
            type = 'pid';
            image = ImageStrings.dummyPIDCard;
          } else if (discoverCardsOptions.displayVerifiableIdJwt &&
              assignedVCFormatType == VCFormatType.jwtVcJson) {
            type = 'verifiableid';
          } else if (discoverCardsOptions.displayVerifiableId &&
              assignedVCFormatType == VCFormatType.ldpVc) {
            type = 'verifiableid';
          }
        } else if (assignedVCFormatType == VCFormatType.jwtVc) {
          type = 'individualverifiableattestation';
        }

        link = '${Urls.id360Url}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format'
            '&type=$type';

        whyGetThisCard =
            ResponseString.RESPONSE_STRING_verifiableIdCardWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_verifiableIdCardExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_verifiableIdCardHowToGetIt;

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

      case CredentialSubjectType.phonePass:
        image = ImageStrings.dummyPhonePassCard;

        link = '${Urls.phonePassUrl}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format';

        whyGetThisCard =
            ResponseString.RESPONSE_STRING_phoneProofWhyGetThisCard;
        expirationDateDetails =
            ResponseString.RESPONSE_STRING_phoneProofExpirationDate;
        howToGetIt = ResponseString.RESPONSE_STRING_phoneProofHowToGetIt;

      case CredentialSubjectType.livenessCard:
        image = ImageStrings.livenessDummy;

        link = '${Urls.id360Url}'
            '?draft=${oidc4vcDraftType.numbering}'
            '&format=$format'
            '&type=liveness';

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
      case CredentialSubjectType.etherlinkAssociatedWallet:
        image = ImageStrings.etherlinkOwnershipCard;

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
      case CredentialSubjectType.legalPersonalCredential:
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.identityCredential:
      case CredentialSubjectType.eudiPid:
      case CredentialSubjectType.pid:
        break;
    }

    return DiscoverDummyCredential(
      image: image,
      link: link,
      credentialSubjectType: this,
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
      vcFormatType: assignedVCFormatType,
    );
  }

  // Future changes will be made to values where 0 appears
  double get order {
    switch (this) {
      case CredentialSubjectType.defiCompliance:
        return 0;
      case CredentialSubjectType.livenessCard:
        return 75;
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
      case CredentialSubjectType.etherlinkAssociatedWallet:
        return 72;
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
        return 100;
      case CredentialSubjectType.emailPass:
        return 99;
      case CredentialSubjectType.identityPass:
        return 90;
      case CredentialSubjectType.verifiableIdCard:
        return 97.5;
      case CredentialSubjectType.learningAchievement:
        return 0;
      case CredentialSubjectType.over13:
        return 97.3;
      case CredentialSubjectType.over15:
        return 97.2;
      case CredentialSubjectType.over18:
        return 97.1;
      case CredentialSubjectType.over21:
        return 97;
      case CredentialSubjectType.over50:
        return 96;
      case CredentialSubjectType.over65:
        return 95;
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
      case CredentialSubjectType.employeeCredential:
      case CredentialSubjectType.legalPersonalCredential:
      case CredentialSubjectType.identityCredential:
      case CredentialSubjectType.eudiPid:
      case CredentialSubjectType.pid:
        return 0;
    }
  }
}
