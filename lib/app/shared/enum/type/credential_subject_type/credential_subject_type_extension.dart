part of 'credential_subject_type.dart';

extension CredentialSubjectTypeExtension on CredentialSubjectType {
  Color backgroundColor(CredentialModel credentialModel) {
    Color _backgroundColor;
    if (credentialModel.display.backgroundColor != '') {
      _backgroundColor = Color(
        int.parse('FF${credentialModel.display.backgroundColor}', radix: 16),
      );
    } else {
      _backgroundColor = defaultBackgroundColor();
    }
    return _backgroundColor;
  }

  Color defaultBackgroundColor() {
    switch (this) {
      case CredentialSubjectType.deviceInfo:
        return const Color(0xff14181D);
      case CredentialSubjectType.bloometaPass:
        return const Color(0xff14181D);
      case CredentialSubjectType.tezotopiaMembership:
        return const Color(0xff273496);
      case CredentialSubjectType.chainbornMembership:
        return const Color(0xff273496);
      case CredentialSubjectType.twitterCard:
        return const Color(0xff273496);
      case CredentialSubjectType.tezoniaPass:
        return const Color(0xff273496);
      case CredentialSubjectType.tzlandPass:
        return const Color(0xff273496);
      case CredentialSubjectType.troopezPass:
        return const Color(0xff273496);
      case CredentialSubjectType.pigsPass:
        return const Color(0xff273496);
      case CredentialSubjectType.matterlightPass:
        return const Color(0xff273496);
      case CredentialSubjectType.dogamiPass:
        return const Color(0xff273496);
      case CredentialSubjectType.bunnyPass:
        return const Color(0xff273496);
      case CredentialSubjectType.nationality:
        return const Color(0xff273496);
      case CredentialSubjectType.gender:
        return const Color(0xff8C0D8E);
      case CredentialSubjectType.tezosAssociatedWallet:
        return const Color(0xffFE7400);
      case CredentialSubjectType.residentCard:
        return Colors.white;
      case CredentialSubjectType.selfIssued:
        return const Color(0xffEFF0F6);
      case CredentialSubjectType.identityPass:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.identityCard:
        return const Color(0xff2596be);
      case CredentialSubjectType.voucher:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.loyaltyCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.over18:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.over13:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.passportFootprint:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.professionalStudentCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.certificateOfEmployment:
        return const Color(0xFF9BF6FF);
      case CredentialSubjectType.emailPass:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.ageRange:
        return const Color(0xFFffC6B5);
      case CredentialSubjectType.phonePass:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.professionalExperienceAssessment:
        return const Color(0xFFFFADAD);
      case CredentialSubjectType.professionalSkillAssessment:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.learningAchievement:
        return const Color(0xFFFFADAD);
      case CredentialSubjectType.ecole42LearningAchievement:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.studentCard:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.tezVoucher:
        return const Color(0xff7a29de);
      case CredentialSubjectType.talaoCommunityCard:
        return const Color(0xff4700D8);
      case CredentialSubjectType.diplomaCard:
        return const Color(0xff4700D8);
      case CredentialSubjectType.aragoIdentityCard:
        return const Color(0xff2596be);
      case CredentialSubjectType.aragoOver18:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.aragoEmailPass:
        return const Color(0xFFffD6A5);
      case CredentialSubjectType.aragoLearningAchievement:
        return const Color(0xFFFFADAD);
      case CredentialSubjectType.aragoPass:
        return const Color(0xff4700D8);
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
        return const Color(0xff4700D8);
      case CredentialSubjectType.defaultCredential:
        return Colors.white;
      case CredentialSubjectType.pcdsAgentCertificate:
        return Colors.white;
    }
  }

  IconData iconData() {
    switch (this) {
      case CredentialSubjectType.deviceInfo:
        return Icons.phone_android_rounded;
      case CredentialSubjectType.bloometaPass:
        return Icons.games;
      case CredentialSubjectType.nationality:
        return Icons.supervised_user_circle_sharp;
      case CredentialSubjectType.tezotopiaMembership:
        return Icons.supervised_user_circle_sharp;
      case CredentialSubjectType.chainbornMembership:
        return Icons.supervised_user_circle_sharp;
      case CredentialSubjectType.twitterCard:
        return Icons.supervised_user_circle_sharp;
      case CredentialSubjectType.tezoniaPass:
        return Icons.games_outlined;
      case CredentialSubjectType.tzlandPass:
        return Icons.games_outlined;
      case CredentialSubjectType.troopezPass:
        return Icons.games_outlined;
      case CredentialSubjectType.pigsPass:
        return Icons.games_outlined;
      case CredentialSubjectType.matterlightPass:
        return Icons.games_outlined;
      case CredentialSubjectType.dogamiPass:
        return Icons.games_outlined;
      case CredentialSubjectType.bunnyPass:
        return Icons.games_outlined;
      case CredentialSubjectType.gender:
        return Icons.supervised_user_circle_rounded;
      case CredentialSubjectType.tezosAssociatedWallet:
        return Icons.account_balance_wallet;
      case CredentialSubjectType.residentCard:
        return Icons.home;
      case CredentialSubjectType.selfIssued:
        return Icons.perm_identity;
      case CredentialSubjectType.identityPass:
        return Icons.perm_identity;
      case CredentialSubjectType.identityCard:
        return Icons.perm_identity;
      case CredentialSubjectType.loyaltyCard:
        return Icons.loyalty;
      case CredentialSubjectType.over18:
        return Icons.accessible_rounded;
      case CredentialSubjectType.over13:
        return Icons.accessible_rounded;
      case CredentialSubjectType.passportFootprint:
        return Icons.accessible_rounded;
      case CredentialSubjectType.professionalStudentCard:
        return Icons.perm_identity;
      case CredentialSubjectType.certificateOfEmployment:
        return Icons.work;
      case CredentialSubjectType.emailPass:
        return Icons.mail;
      case CredentialSubjectType.ageRange:
        return Icons.boy;
      case CredentialSubjectType.phonePass:
        return Icons.phone;
      case CredentialSubjectType.professionalExperienceAssessment:
        return Icons.add_road_outlined;
      case CredentialSubjectType.professionalSkillAssessment:
        return Icons.assessment_outlined;
      case CredentialSubjectType.learningAchievement:
        return Icons.star_rate_outlined;
      case CredentialSubjectType.ecole42LearningAchievement:
        return Icons.perm_identity;
      case CredentialSubjectType.studentCard:
        return Icons.perm_identity;
      case CredentialSubjectType.voucher:
        return Icons.gamepad;
      case CredentialSubjectType.tezVoucher:
        return Icons.gamepad;
      case CredentialSubjectType.diplomaCard:
        return Icons.gamepad;
      case CredentialSubjectType.talaoCommunityCard:
        return Icons.perm_identity;
      case CredentialSubjectType.aragoPass:
        return Icons.perm_identity;
      case CredentialSubjectType.aragoIdentityCard:
        return Icons.perm_identity;
      case CredentialSubjectType.aragoLearningAchievement:
        return Icons.star_rate_outlined;
      case CredentialSubjectType.aragoEmailPass:
        return Icons.mail;
      case CredentialSubjectType.aragoOver18:
        return Icons.accessible_rounded;
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
        return Icons.accessible_rounded;
      case CredentialSubjectType.defaultCredential:
        return Icons.fact_check_outlined;
      case CredentialSubjectType.pcdsAgentCertificate:
        return Icons.fact_check_outlined;
    }
  }

  bool isDisabled() {
    if (this == CredentialSubjectType.dogamiPass) {
      return true;
    } else if (this == CredentialSubjectType.pigsPass) {
      return true;
    } else if (this == CredentialSubjectType.bunnyPass) {
      return true;
    } else if (this == CredentialSubjectType.troopezPass) {
      return true;
    } else if (this == CredentialSubjectType.tzlandPass) {
      return true;
    } else if (this == CredentialSubjectType.matterlightPass) {
      return true;
    } else if (this == CredentialSubjectType.tezoniaPass) {
      return true;
    } else {
      return false;
    }
  }

  String get name {
    switch (this) {
      case CredentialSubjectType.bloometaPass:
        return 'BloometaPass';
      case CredentialSubjectType.tezoniaPass:
        return 'TezoniaPass';
      case CredentialSubjectType.tzlandPass:
        return 'TzlandPass';
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
      case CredentialSubjectType.deviceInfo:
        return 'DeviceInfo';
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
      case CredentialSubjectType.certificateOfEmployment:
        return 'CertificateOfEmployment';
      case CredentialSubjectType.ecole42LearningAchievement:
        return 'Ecole42LearningAchievement';
      case CredentialSubjectType.emailPass:
        return 'EmailPass';
      case CredentialSubjectType.identityPass:
        return 'IdentityPass';
      case CredentialSubjectType.identityCard:
        return 'IdCard';
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
      case CredentialSubjectType.tezoniaPass:
        return TezoniaPassModel.fromJson(json);
      case CredentialSubjectType.tzlandPass:
        return TzlandPassModel.fromJson(json);
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
      case CredentialSubjectType.deviceInfo:
        return DeviceInfoModel.fromJson(json);
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
      case CredentialSubjectType.identityCard:
        return IdentityCardModel.fromJson(json);
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
    }
  }
}
