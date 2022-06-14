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
      case CredentialSubjectType.associatedWallet:
        return const Color(0xffFE7400);
      case CredentialSubjectType.residentCard:
        return Colors.white;
      case CredentialSubjectType.selfIssued:
        return const Color(0xffEFF0F6);
      case CredentialSubjectType.identityPass:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.voucher:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.loyaltyCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.over18:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.professionalStudentCard:
        return const Color(0xffCAFFBF);
      case CredentialSubjectType.certificateOfEmployment:
        return const Color(0xFF9BF6FF);
      case CredentialSubjectType.emailPass:
        return const Color(0xFFffD6A5);
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
      case CredentialSubjectType.talao:
        return const Color(0xffd72b8e);
      case CredentialSubjectType.defaultCredential:
        return Colors.white;
    }
  }

  IconData iconData() {
    switch (this) {
      case CredentialSubjectType.associatedWallet:
        return Icons.account_balance_wallet;
      case CredentialSubjectType.residentCard:
        return Icons.home;
      case CredentialSubjectType.selfIssued:
        return Icons.perm_identity;
      case CredentialSubjectType.identityPass:
        return Icons.perm_identity;
      case CredentialSubjectType.voucher:
        return Icons.gamepad;
      case CredentialSubjectType.loyaltyCard:
        return Icons.loyalty;
      case CredentialSubjectType.over18:
        return Icons.accessible_rounded;
      case CredentialSubjectType.professionalStudentCard:
        return Icons.perm_identity;
      case CredentialSubjectType.certificateOfEmployment:
        return Icons.work;
      case CredentialSubjectType.emailPass:
        return Icons.mail;
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
      case CredentialSubjectType.talao:
        return Icons.fact_check_outlined;
      case CredentialSubjectType.defaultCredential:
        return Icons.fact_check_outlined;
    }
  }
}
