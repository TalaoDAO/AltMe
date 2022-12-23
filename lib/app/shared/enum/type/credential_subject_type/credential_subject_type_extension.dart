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
}
