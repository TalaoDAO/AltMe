// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discover_dummy_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DiscoverDummyCredential _$DiscoverDummyCredentialFromJson(
        Map<String, dynamic> json) =>
    DiscoverDummyCredential(
      credentialSubjectType: $enumDecode(
          _$CredentialSubjectTypeEnumMap, json['credentialSubjectType']),
      vcFormatType:
          $enumDecodeNullable(_$VCFormatTypeEnumMap, json['vcFormatType']) ??
              VCFormatType.ldpVc,
      link: json['link'] as String?,
      image: json['image'] as String?,
      websiteLink: json['websiteLink'] as String?,
      display: json['display'] == null
          ? null
          : Display.fromJson(json['display'] as Map<String, dynamic>),
      whyGetThisCardExtern: json['whyGetThisCardExtern'] as String?,
      expirationDateDetailsExtern:
          json['expirationDateDetailsExtern'] as String?,
      howToGetItExtern: json['howToGetItExtern'] as String?,
      longDescriptionExtern: json['longDescriptionExtern'] as String?,
      websiteLinkExtern: json['websiteLinkExtern'] as String?,
    );

Map<String, dynamic> _$DiscoverDummyCredentialToJson(
        DiscoverDummyCredential instance) =>
    <String, dynamic>{
      'link': instance.link,
      'image': instance.image,
      'credentialSubjectType':
          _$CredentialSubjectTypeEnumMap[instance.credentialSubjectType]!,
      'websiteLink': instance.websiteLink,
      'display': instance.display?.toJson(),
      'whyGetThisCardExtern': instance.whyGetThisCardExtern,
      'expirationDateDetailsExtern': instance.expirationDateDetailsExtern,
      'howToGetItExtern': instance.howToGetItExtern,
      'longDescriptionExtern': instance.longDescriptionExtern,
      'websiteLinkExtern': instance.websiteLinkExtern,
      'vcFormatType': _$VCFormatTypeEnumMap[instance.vcFormatType]!,
    };

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
  CredentialSubjectType.employeeCredential: 'employeeCredential',
  CredentialSubjectType.legalPersonalCredential: 'legalPersonalCredential',
  CredentialSubjectType.identityCredential: 'identityCredential',
  CredentialSubjectType.eudiPid: 'eudiPid',
  CredentialSubjectType.pid: 'pid',
};

const _$VCFormatTypeEnumMap = {
  VCFormatType.ldpVc: 'ldp_vc',
  VCFormatType.jwtVc: 'jwt_vc',
  VCFormatType.jwtVcJson: 'jwt_vc_json',
  VCFormatType.jwtVcJsonLd: 'jwt_vc_json-ld',
  VCFormatType.vcSdJWT: 'vc+sd-jwt',
  VCFormatType.dcSdJWT: 'dc+sd-jwt',
  VCFormatType.auto: 'auto',
};
