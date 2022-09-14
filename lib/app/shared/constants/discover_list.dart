import 'package:altme/app/shared/enum/type/credential_subject_type/credential_subject_type.dart';

class DiscoverList {
  static final List<CredentialSubjectType> gamingCategories = [
    CredentialSubjectType.tezVoucher,
  ];
  static final List<CredentialSubjectType> communityCategories = [
    // CredentialSubjectType.talaoCommunityCard
  ];
  static final List<CredentialSubjectType> identityCategories = [
    CredentialSubjectType.emailPass,
    CredentialSubjectType.ageRange,
    CredentialSubjectType.over18,
    CredentialSubjectType.identityCard,
  ];
}
