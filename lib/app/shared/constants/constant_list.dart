import 'package:altme/app/shared/enum/type/credential_subject_type/credential_subject_type.dart';

class DiscoverList {
  static final List<CredentialSubjectType> gamingCategories = [
    CredentialSubjectType.tezVoucher,
    CredentialSubjectType.tezotopiaMembership,
  ];
  static final List<CredentialSubjectType> communityCategories = [
    // CredentialSubjectType.talaoCommunityCard
  ];
  static final List<CredentialSubjectType> identityCategories = [
    CredentialSubjectType.emailPass,
    CredentialSubjectType.gender,
    CredentialSubjectType.ageRange,
    CredentialSubjectType.nationality,
    CredentialSubjectType.over18,
    CredentialSubjectType.over13,
    CredentialSubjectType.identityCard,
  ];
}

final List<CredentialSubjectType> membershipRequiredList = [
  CredentialSubjectType.ageRange,
  CredentialSubjectType.nationality,
];
