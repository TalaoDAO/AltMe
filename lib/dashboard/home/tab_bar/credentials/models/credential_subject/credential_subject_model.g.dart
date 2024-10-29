// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credential_subject_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CredentialSubjectModel _$CredentialSubjectModelFromJson(
        Map<String, dynamic> json) =>
    CredentialSubjectModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      issuedBy: CredentialSubjectModel.fromJsonAuthor(json['issuedBy']),
      offeredBy: CredentialSubjectModel.fromJsonAuthor(json['offeredBy']),
      credentialSubjectType: $enumDecode(
          _$CredentialSubjectTypeEnumMap, json['credentialSubjectType']),
      credentialCategory:
          $enumDecode(_$CredentialCategoryEnumMap, json['credentialCategory']),
    );

Map<String, dynamic> _$CredentialSubjectModelToJson(
    CredentialSubjectModel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
    'issuedBy': instance.issuedBy?.toJson(),
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('offeredBy', instance.offeredBy?.toJson());
  val['credentialSubjectType'] =
      _$CredentialSubjectTypeEnumMap[instance.credentialSubjectType]!;
  val['credentialCategory'] =
      _$CredentialCategoryEnumMap[instance.credentialCategory]!;
  return val;
}

const _$CredentialSubjectTypeEnumMap = {
  CredentialSubjectType.ageRange: 'ageRange',
  CredentialSubjectType.aragoEmailPass: 'aragoEmailPass',
  CredentialSubjectType.aragoIdentityCard: 'aragoIdentityCard',
  CredentialSubjectType.aragoLearningAchievement: 'aragoLearningAchievement',
  CredentialSubjectType.aragoOver18: 'aragoOver18',
  CredentialSubjectType.aragoPass: 'aragoPass',
  CredentialSubjectType.binanceAssociatedWallet: 'binanceAssociatedWallet',
  CredentialSubjectType.binancePooAddress: 'binancePooAddress',
  CredentialSubjectType.livenessCard: 'livenessCard',
  CredentialSubjectType.certificateOfEmployment: 'certificateOfEmployment',
  CredentialSubjectType.chainbornMembership: 'chainbornMembership',
  CredentialSubjectType.defaultCredential: 'defaultCredential',
  CredentialSubjectType.defiCompliance: 'defiCompliance',
  CredentialSubjectType.diplomaCard: 'diplomaCard',
  CredentialSubjectType.emailPass: 'emailPass',
  CredentialSubjectType.ethereumAssociatedWallet: 'ethereumAssociatedWallet',
  CredentialSubjectType.etherlinkAssociatedWallet: 'etherlinkAssociatedWallet',
  CredentialSubjectType.ethereumPooAddress: 'ethereumPooAddress',
  CredentialSubjectType.euDiplomaCard: 'euDiplomaCard',
  CredentialSubjectType.euVerifiableId: 'euVerifiableId',
  CredentialSubjectType.fantomAssociatedWallet: 'fantomAssociatedWallet',
  CredentialSubjectType.fantomPooAddress: 'fantomPooAddress',
  CredentialSubjectType.gender: 'gender',
  CredentialSubjectType.identityPass: 'identityPass',
  CredentialSubjectType.kycAgeCredential: 'kycAgeCredential',
  CredentialSubjectType.kycCountryOfResidence: 'kycCountryOfResidence',
  CredentialSubjectType.learningAchievement: 'learningAchievement',
  CredentialSubjectType.nationality: 'nationality',
  CredentialSubjectType.over13: 'over13',
  CredentialSubjectType.over15: 'over15',
  CredentialSubjectType.over18: 'over18',
  CredentialSubjectType.over21: 'over21',
  CredentialSubjectType.over50: 'over50',
  CredentialSubjectType.over65: 'over65',
  CredentialSubjectType.passportFootprint: 'passportFootprint',
  CredentialSubjectType.pcdsAgentCertificate: 'pcdsAgentCertificate',
  CredentialSubjectType.phonePass: 'phonePass',
  CredentialSubjectType.polygonAssociatedWallet: 'polygonAssociatedWallet',
  CredentialSubjectType.polygonPooAddress: 'polygonPooAddress',
  CredentialSubjectType.professionalExperienceAssessment:
      'professionalExperienceAssessment',
  CredentialSubjectType.professionalSkillAssessment:
      'professionalSkillAssessment',
  CredentialSubjectType.professionalStudentCard: 'professionalStudentCard',
  CredentialSubjectType.residentCard: 'residentCard',
  CredentialSubjectType.selfIssued: 'selfIssued',
  CredentialSubjectType.studentCard: 'studentCard',
  CredentialSubjectType.tezosAssociatedWallet: 'tezosAssociatedWallet',
  CredentialSubjectType.tezosPooAddress: 'tezosPooAddress',
  CredentialSubjectType.tezotopiaMembership: 'tezotopiaMembership',
  CredentialSubjectType.tezVoucher: 'tezVoucher',
  CredentialSubjectType.twitterCard: 'twitterCard',
  CredentialSubjectType.verifiableIdCard: 'verifiableIdCard',
  CredentialSubjectType.voucher: 'voucher',
  CredentialSubjectType.walletCredential: 'walletCredential',
  CredentialSubjectType.proofOfTwitterStats: 'proofOfTwitterStats',
  CredentialSubjectType.civicPassCredential: 'civicPassCredential',
  CredentialSubjectType.employeeCredential: 'employeeCredential',
  CredentialSubjectType.legalPersonalCredential: 'legalPersonalCredential',
  CredentialSubjectType.identityCredential: 'identityCredential',
  CredentialSubjectType.eudiPid: 'eudiPid',
  CredentialSubjectType.pid: 'pid',
};

const _$CredentialCategoryEnumMap = {
  CredentialCategory.advantagesCards: 'advantagesCards',
  CredentialCategory.identityCards: 'identityCards',
  CredentialCategory.professionalCards: 'professionalCards',
  CredentialCategory.contactInfoCredentials: 'contactInfoCredentials',
  CredentialCategory.educationCards: 'educationCards',
  CredentialCategory.financeCards: 'financeCards',
  CredentialCategory.humanityProofCards: 'humanityProofCards',
  CredentialCategory.socialMediaCards: 'socialMediaCards',
  CredentialCategory.walletIntegrity: 'walletIntegrity',
  CredentialCategory.blockchainAccountsCards: 'blockchainAccountsCards',
  CredentialCategory.othersCards: 'othersCards',
  CredentialCategory.polygonidCards: 'polygonidCards',
  CredentialCategory.pendingCards: 'pendingCards',
};
