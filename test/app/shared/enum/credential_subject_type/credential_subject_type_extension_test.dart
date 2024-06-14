import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:test/test.dart';

void main() {
  group('CredentialSubjectType Extension Tests', () {
    test('CredentialSubjectType backgroundColor returns correct value', () {
      final credentialModel = CredentialModel(
        id: '',
        credentialPreview: Credential.dummy(),
        data: const <String, dynamic>{},
        image: '',
        shareLink: '',
        display: const Display(backgroundColor: '#FFFFFF'),
      );
      final credentialModel2 = CredentialModel(
        id: '',
        credentialPreview: Credential.dummy(),
        data: const <String, dynamic>{},
        image: '',
        shareLink: '',
      );

      for (final value in CredentialSubjectType.values) {
        expect(
          value.backgroundColor(credentialModel),
          equals(const Color(0xFFFFFFFF)),
        );
        expect(
          value.backgroundColor(credentialModel2),
          equals(value.defaultBackgroundColor),
        );
      }
    });

    test('CredentialSubjectType defaultBackgroundColor returns correct value',
        () {
      expect(
        CredentialSubjectType.defiCompliance.defaultBackgroundColor,
        equals(const Color.fromARGB(255, 62, 15, 163)),
      );

      expect(
        CredentialSubjectType.identityPass.defaultBackgroundColor,
        equals(const Color(0xffCAFFBF)),
      );

      expect(
        CredentialSubjectType
            .professionalExperienceAssessment.defaultBackgroundColor,
        equals(const Color(0xFFFFADAD)),
      );

      expect(
        CredentialSubjectType
            .professionalSkillAssessment.defaultBackgroundColor,
        equals(const Color(0xffCAFFBF)),
      );

      expect(
        CredentialSubjectType.residentCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.selfIssued.defaultBackgroundColor,
        equals(const Color(0xffEFF0F6)),
      );

      expect(
        CredentialSubjectType.defaultCredential.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.professionalStudentCard.defaultBackgroundColor,
        equals(const Color(0xffCAFFBF)),
      );

      expect(
        CredentialSubjectType.kycAgeCredential.defaultBackgroundColor,
        equals(const Color(0xff8247E5)),
      );

      expect(
        CredentialSubjectType.kycCountryOfResidence.defaultBackgroundColor,
        equals(const Color(0xff8247E5)),
      );

      expect(
        CredentialSubjectType.walletCredential.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.livenessCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.nationality.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.tezotopiaMembership.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.chainbornMembership.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.twitterCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.gender.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.tezosAssociatedWallet.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.verifiableIdCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.linkedInCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.over13.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.over15.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.over18.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.over21.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.over50.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.over65.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.passportFootprint.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.certificateOfEmployment.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.emailPass.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.ageRange.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.phonePass.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.learningAchievement.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.studentCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.voucher.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.tezVoucher.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.diplomaCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.aragoPass.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.aragoIdentityCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.aragoLearningAchievement.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.aragoEmailPass.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.aragoOver18.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.ethereumAssociatedWallet.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.fantomAssociatedWallet.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.polygonAssociatedWallet.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.binanceAssociatedWallet.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.ethereumPooAddress.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.fantomPooAddress.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.polygonPooAddress.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.binancePooAddress.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.tezosPooAddress.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.pcdsAgentCertificate.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.euDiplomaCard.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.euVerifiableId.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.proofOfTwitterStats.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.civicPassCredential.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.employeeCredential.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.legalPersonalCredential.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.identityCredential.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.eudiPid.defaultBackgroundColor,
        equals(Colors.white),
      );

      expect(
        CredentialSubjectType.pid.defaultBackgroundColor,
        equals(Colors.white),
      );
    });

    test('CredentialSubjectType name returns correct value', () {
      expect(
        CredentialSubjectType.defiCompliance.name,
        equals('DefiCompliance'),
      );
      expect(CredentialSubjectType.livenessCard.name, equals('Liveness'));
      expect(
        CredentialSubjectType.tezotopiaMembership.name,
        equals('MembershipCard_1'),
      );
      expect(
        CredentialSubjectType.chainbornMembership.name,
        equals('Chainborn_MembershipCard'),
      );
      expect(
        CredentialSubjectType.twitterCard.name,
        equals('TwitterAccountProof'),
      );
      expect(CredentialSubjectType.ageRange.name, equals('AgeRange'));
      expect(CredentialSubjectType.nationality.name, equals('Nationality'));
      expect(CredentialSubjectType.gender.name, equals('Gender'));
      expect(
        CredentialSubjectType.walletCredential.name,
        equals('WalletCredential'),
      );
      expect(
        CredentialSubjectType.tezosAssociatedWallet.name,
        equals('TezosAssociatedAddress'),
      );
      expect(
        CredentialSubjectType.ethereumAssociatedWallet.name,
        equals('EthereumAssociatedAddress'),
      );
      expect(
        CredentialSubjectType.fantomAssociatedWallet.name,
        equals('FantomAssociatedAddress'),
      );
      expect(
        CredentialSubjectType.polygonAssociatedWallet.name,
        equals('PolygonAssociatedAddress'),
      );
      expect(
        CredentialSubjectType.binanceAssociatedWallet.name,
        equals('BinanceAssociatedAddress'),
      );
      expect(
        CredentialSubjectType.ethereumPooAddress.name,
        equals('EthereumPooAddress'),
      );
      expect(
        CredentialSubjectType.fantomPooAddress.name,
        equals('FantomPooAddress'),
      );
      expect(
        CredentialSubjectType.polygonPooAddress.name,
        equals('PolygonPooAddress'),
      );
      expect(
        CredentialSubjectType.binancePooAddress.name,
        equals('BinancePooAddress'),
      );
      expect(
        CredentialSubjectType.tezosPooAddress.name,
        equals('TezosPooAddress'),
      );
      expect(
        CredentialSubjectType.certificateOfEmployment.name,
        equals('CertificateOfEmployment'),
      );
      expect(CredentialSubjectType.emailPass.name, equals('EmailPass'));
      expect(CredentialSubjectType.identityPass.name, equals('IdentityPass'));
      expect(
        CredentialSubjectType.verifiableIdCard.name,
        equals('VerifiableId'),
      );
      expect(CredentialSubjectType.linkedInCard.name, equals('LinkedinCard'));
      expect(
        CredentialSubjectType.learningAchievement.name,
        equals('LearningAchievement'),
      );
      expect(CredentialSubjectType.over13.name, equals('Over13'));
      expect(CredentialSubjectType.over15.name, equals('Over15'));
      expect(CredentialSubjectType.over18.name, equals('Over18'));
      expect(CredentialSubjectType.over21.name, equals('Over21'));
      expect(CredentialSubjectType.over50.name, equals('Over50'));
      expect(CredentialSubjectType.over65.name, equals('Over65'));
      expect(
        CredentialSubjectType.passportFootprint.name,
        equals('PassportNumber'),
      );
      expect(CredentialSubjectType.phonePass.name, equals('PhoneProof'));
      expect(
        CredentialSubjectType.professionalExperienceAssessment.name,
        equals('ProfessionalExperienceAssessment'),
      );
      expect(
        CredentialSubjectType.professionalSkillAssessment.name,
        equals('ProfessionalSkillAssessment'),
      );
      expect(
        CredentialSubjectType.professionalStudentCard.name,
        equals('ProfessionalStudentCard'),
      );
      expect(CredentialSubjectType.residentCard.name, equals('ResidentCard'));
      expect(
        CredentialSubjectType.employeeCredential.name,
        equals('EmployeeCredential'),
      );
      expect(
        CredentialSubjectType.legalPersonalCredential.name,
        equals('LegalPersonCredential'),
      );
      expect(CredentialSubjectType.selfIssued.name, equals('SelfIssued'));
      expect(CredentialSubjectType.studentCard.name, equals('StudentCard'));
      expect(CredentialSubjectType.voucher.name, equals('Voucher'));
      expect(CredentialSubjectType.tezVoucher.name, equals('TezVoucher_1'));
      expect(
        CredentialSubjectType.diplomaCard.name,
        equals('VerifiableDiploma'),
      );
      expect(CredentialSubjectType.aragoPass.name, equals('AragoPass'));
      expect(
        CredentialSubjectType.aragoEmailPass.name,
        equals('AragoEmailPass'),
      );
      expect(
        CredentialSubjectType.aragoIdentityCard.name,
        equals('AragoIdCard'),
      );
      expect(
        CredentialSubjectType.aragoLearningAchievement.name,
        equals('AragoLearningAchievement'),
      );
      expect(CredentialSubjectType.aragoOver18.name, equals('AragoOver18'));
      expect(
        CredentialSubjectType.pcdsAgentCertificate.name,
        equals('PCDSAgentCertificate'),
      );
      expect(
        CredentialSubjectType.euDiplomaCard.name,
        equals(
          'https://api.preprod.ebsi.eu/trusted-schemas-registry/v1/schemas/0xbf78fc08a7a9f28f5479f58dea269d3657f54f13ca37d380cd4e92237fb691dd',
        ),
      );
      expect(
        CredentialSubjectType.euVerifiableId.name,
        equals(
          'https://api-conformance.ebsi.eu/trusted-schemas-registry/v2/schemas/z22ZAMdQtNLwi51T2vdZXGGZaYyjrsuP1yzWyXZirCAHv',
        ),
      );
      expect(
        CredentialSubjectType.kycAgeCredential.name,
        equals('KYCAgeCredential'),
      );
      expect(
        CredentialSubjectType.kycCountryOfResidence.name,
        equals('KYCCountryOfResidenceCredential'),
      );
      expect(
        CredentialSubjectType.proofOfTwitterStats.name,
        equals('ProofOfTwitterStats'),
      );
      expect(
        CredentialSubjectType.civicPassCredential.name,
        equals('CivicPassCredential'),
      );
      expect(
        CredentialSubjectType.identityCredential.name,
        equals('IdentityCredential'),
      );
      expect(CredentialSubjectType.eudiPid.name, equals('EudiPid'));
      expect(CredentialSubjectType.pid.name, equals('Pid'));
      expect(CredentialSubjectType.defaultCredential.name, equals(''));
    });

    test('CredentialSubjectType checkForAIKYC returns correct value', () {
      for (final value in CredentialSubjectType.values) {
        if (value == CredentialSubjectType.over18 ||
            value == CredentialSubjectType.over13 ||
            value == CredentialSubjectType.over15 ||
            value == CredentialSubjectType.over21 ||
            value == CredentialSubjectType.over50 ||
            value == CredentialSubjectType.over65 ||
            value == CredentialSubjectType.ageRange ||
            value == CredentialSubjectType.defiCompliance ||
            value == CredentialSubjectType.livenessCard) {
          expect(value.checkForAIKYC, isTrue);
        } else {
          expect(value.checkForAIKYC, isFalse);
        }
      }
    });

    test('CredentialSubjectType getKycVcType returns correct value', () {
      for (final value in CredentialSubjectType.values) {
        if (value == CredentialSubjectType.over18) {
          expect(value.getKycVcType, equals(KycVcType.over18));
        } else if (value == CredentialSubjectType.over13) {
          expect(value.getKycVcType, equals(KycVcType.over13));
        } else if (value == CredentialSubjectType.over15) {
          expect(value.getKycVcType, equals(KycVcType.over15));
        } else if (value == CredentialSubjectType.over21) {
          expect(value.getKycVcType, equals(KycVcType.over21));
        } else if (value == CredentialSubjectType.over50) {
          expect(value.getKycVcType, equals(KycVcType.over50));
        } else if (value == CredentialSubjectType.over65) {
          expect(value.getKycVcType, equals(KycVcType.over65));
        } else if (value == CredentialSubjectType.ageRange) {
          expect(value.getKycVcType, equals(KycVcType.ageRange));
        } else if (value == CredentialSubjectType.defiCompliance) {
          expect(value.getKycVcType, equals(KycVcType.defiCompliance));
        } else {
          expect(value.getKycVcType, equals(KycVcType.verifiableId));
        }
      }
    });

    test('CredentialSubjectType aiValidationUrl returns correct value', () {
      for (final value in CredentialSubjectType.values) {
        if (value == CredentialSubjectType.over13) {
          expect(value.aiValidationUrl, equals(Urls.over13AIValidationUrl));
        } else if (value == CredentialSubjectType.over15) {
          expect(value.aiValidationUrl, equals(Urls.over15AIValidationUrl));
        } else if (value == CredentialSubjectType.over18) {
          expect(value.aiValidationUrl, equals(Urls.over18AIValidationUrl));
        } else if (value == CredentialSubjectType.over21) {
          expect(value.aiValidationUrl, equals(Urls.over21AIValidationUrl));
        } else if (value == CredentialSubjectType.over50) {
          expect(value.aiValidationUrl, equals(Urls.over50AIValidationUrl));
        } else if (value == CredentialSubjectType.over65) {
          expect(value.aiValidationUrl, equals(Urls.over65AIValidationUrl));
        } else if (value == CredentialSubjectType.ageRange) {
          expect(value.aiValidationUrl, equals(Urls.ageRangeAIValidationUrl));
        } else {
          expect(
            () => CredentialSubjectType.defaultCredential.aiValidationUrl,
            throwsA(
              predicate(
                (e) =>
                    e is ResponseMessage &&
                    e.data['error'] == 'invalid_request',
              ),
            ),
          );
        }
      }
    });

    test('CredentialSubjectType byPassDeepLink returns correct value', () {
      for (final value in CredentialSubjectType.values) {
        if (value == CredentialSubjectType.tezotopiaMembership ||
            value == CredentialSubjectType.chainbornMembership ||
            value == CredentialSubjectType.twitterCard ||
            value == CredentialSubjectType.over13 ||
            value == CredentialSubjectType.over15 ||
            value == CredentialSubjectType.over18 ||
            value == CredentialSubjectType.over21 ||
            value == CredentialSubjectType.over50 ||
            value == CredentialSubjectType.over65 ||
            value == CredentialSubjectType.verifiableIdCard ||
            value == CredentialSubjectType.ageRange ||
            value == CredentialSubjectType.nationality ||
            value == CredentialSubjectType.gender ||
            value == CredentialSubjectType.passportFootprint ||
            value == CredentialSubjectType.linkedInCard) {
          expect(value.byPassDeepLink, isTrue);
        } else {
          expect(value.byPassDeepLink, isFalse);
        }
      }
    });

    test('CredentialSubjectType isEbsiCard returns correct value', () {
      for (final value in CredentialSubjectType.values) {
        if (value == CredentialSubjectType.euDiplomaCard ||
            value == CredentialSubjectType.euVerifiableId) {
          expect(value.isEbsiCard, isTrue);
        } else {
          expect(value.isEbsiCard, isFalse);
        }
      }
    });

    test('CredentialSubjectType isBlockchainAccount returns correct value', () {
      for (final value in CredentialSubjectType.values) {
        if (value == CredentialSubjectType.tezosAssociatedWallet ||
            value == CredentialSubjectType.ethereumAssociatedWallet ||
            value == CredentialSubjectType.binanceAssociatedWallet ||
            value == CredentialSubjectType.fantomAssociatedWallet ||
            value == CredentialSubjectType.polygonAssociatedWallet) {
          expect(value.isBlockchainAccount, isTrue);
        } else {
          expect(value.isBlockchainAccount, isFalse);
        }
      }
    });

    test('CredentialSubjectType blockchainWidget returns correct value', () {
      for (final value in CredentialSubjectType.values) {
        if (value == CredentialSubjectType.tezosAssociatedWallet) {
          expect(value.blockchainWidget, isA<TezosAssociatedAddressWidget>());
        } else if (value == CredentialSubjectType.ethereumAssociatedWallet) {
          expect(
            value.blockchainWidget,
            isA<EthereumAssociatedAddressWidget>(),
          );
        } else if (value == CredentialSubjectType.polygonAssociatedWallet) {
          expect(value.blockchainWidget, isA<PolygonAssociatedAddressWidget>());
        } else if (value == CredentialSubjectType.binanceAssociatedWallet) {
          expect(value.blockchainWidget, isA<BinanceAssociatedAddressWidget>());
        } else if (value == CredentialSubjectType.fantomAssociatedWallet) {
          expect(value.blockchainWidget, isA<FantomAssociatedAddressWidget>());
        } else {
          expect(value.blockchainWidget, isNull);
        }
      }
    });

    test('CredentialSubjectType title returns correct value', () {
      expect(CredentialSubjectType.defiCompliance.title, 'Defi Compliance');
      expect(CredentialSubjectType.livenessCard.title, 'Liveness');
      expect(
        CredentialSubjectType.tezotopiaMembership.title,
        'Membership Card',
      );
      expect(CredentialSubjectType.chainbornMembership.title, 'Chainborn');
      expect(CredentialSubjectType.twitterCard.title, 'Twitter Account Proof');
      expect(CredentialSubjectType.ageRange.title, 'Age Range');
      expect(CredentialSubjectType.nationality.title, 'Nationality');
      expect(CredentialSubjectType.gender.title, 'Gender');
      expect(CredentialSubjectType.walletCredential.title, 'Wallet Credential');
      expect(
        CredentialSubjectType.tezosAssociatedWallet.title,
        'Tezos Associated Address',
      );
      expect(
        CredentialSubjectType.ethereumAssociatedWallet.title,
        'Ethereum Associated Address',
      );
      expect(
        CredentialSubjectType.fantomAssociatedWallet.title,
        'Fantom Associated Address',
      );
      expect(
        CredentialSubjectType.polygonAssociatedWallet.title,
        'Polygon Associated Address',
      );
      expect(
        CredentialSubjectType.binanceAssociatedWallet.title,
        'BNB Chain Associated Address',
      );
      expect(
        CredentialSubjectType.ethereumPooAddress.title,
        'Ethereum Poo Address',
      );
      expect(
        CredentialSubjectType.fantomPooAddress.title,
        'Fantom Poo Address',
      );
      expect(
        CredentialSubjectType.polygonPooAddress.title,
        'Polygon Poo Address',
      );
      expect(
        CredentialSubjectType.binancePooAddress.title,
        'BNB Chain Poo Address',
      );
      expect(CredentialSubjectType.tezosPooAddress.title, 'Tezos Poo Address');
      expect(
        CredentialSubjectType.certificateOfEmployment.title,
        'Certificate of Employment',
      );
      expect(CredentialSubjectType.emailPass.title, 'Email Pass');
      expect(CredentialSubjectType.identityPass.title, 'Identity Pass');
      expect(CredentialSubjectType.verifiableIdCard.title, 'VerifiableId');
      expect(CredentialSubjectType.linkedInCard.title, 'Linkedin Card');
      expect(
        CredentialSubjectType.learningAchievement.title,
        'Learning Achievement',
      );
      expect(CredentialSubjectType.over13.title, 'Over13');
      expect(CredentialSubjectType.over15.title, 'Over15');
      expect(CredentialSubjectType.over18.title, 'Over18');
      expect(CredentialSubjectType.over21.title, 'Over18');
      expect(CredentialSubjectType.over50.title, 'Over18');
      expect(CredentialSubjectType.over65.title, 'Over18');
      expect(CredentialSubjectType.passportFootprint.title, 'Passport Number');
      expect(CredentialSubjectType.phonePass.title, 'Phone Proof');
      expect(
        CredentialSubjectType.professionalExperienceAssessment.title,
        'Professional Experience Assessment',
      );
      expect(
        CredentialSubjectType.professionalSkillAssessment.title,
        'Professional Skill Assessment',
      );
      expect(
        CredentialSubjectType.professionalStudentCard.title,
        'Professional Student Card',
      );
      expect(CredentialSubjectType.residentCard.title, 'Resident Card');
      expect(CredentialSubjectType.selfIssued.title, 'Self Issued');
      expect(CredentialSubjectType.studentCard.title, 'Student Card');
      expect(CredentialSubjectType.voucher.title, 'Voucher');
      expect(CredentialSubjectType.tezVoucher.title, 'TezVoucher');
      expect(CredentialSubjectType.diplomaCard.title, 'Verifiable Diploma');
      expect(CredentialSubjectType.aragoPass.title, 'Arago Pass');
      expect(CredentialSubjectType.aragoEmailPass.title, 'Arago Email Pass');
      expect(CredentialSubjectType.aragoIdentityCard.title, 'Arago Id Card');
      expect(
        CredentialSubjectType.aragoLearningAchievement.title,
        'Arago Learning Achievement',
      );
      expect(CredentialSubjectType.aragoOver18.title, 'Arago Over18');
      expect(
        CredentialSubjectType.pcdsAgentCertificate.title,
        'PCDS Agent Certificate',
      );
      expect(CredentialSubjectType.euDiplomaCard.title, 'EU Diploma');
      expect(CredentialSubjectType.euVerifiableId.title, 'EU VerifiableID');
      expect(
        CredentialSubjectType.kycAgeCredential.title,
        'KYC Age Credential',
      );
      expect(
        CredentialSubjectType.kycCountryOfResidence.title,
        'KYC Country of Residence',
      );
      expect(
        CredentialSubjectType.proofOfTwitterStats.title,
        'Proof Of Twitter Stats',
      );
      expect(
        CredentialSubjectType.civicPassCredential.title,
        'Civic Pass Credential',
      );
      expect(
        CredentialSubjectType.employeeCredential.title,
        'Employee Credential',
      );
      expect(
        CredentialSubjectType.legalPersonalCredential.title,
        'Legal Person Credential',
      );
      expect(
        CredentialSubjectType.identityCredential.title,
        'Identity Credential',
      );
      expect(CredentialSubjectType.eudiPid.title, 'EudiPid');
      expect(CredentialSubjectType.pid.title, 'Pid');
      expect(CredentialSubjectType.defaultCredential.title, '');
    });

    test('CredentialSubjectType supportSingleOnly returns correct value', () {
      expect(CredentialSubjectType.defiCompliance.supportSingleOnly, true);
      expect(CredentialSubjectType.livenessCard.supportSingleOnly, true);
      expect(CredentialSubjectType.tezotopiaMembership.supportSingleOnly, true);
      expect(CredentialSubjectType.chainbornMembership.supportSingleOnly, true);
      expect(CredentialSubjectType.ageRange.supportSingleOnly, true);
      expect(CredentialSubjectType.nationality.supportSingleOnly, true);
      expect(CredentialSubjectType.gender.supportSingleOnly, true);
      expect(CredentialSubjectType.identityPass.supportSingleOnly, true);
      expect(CredentialSubjectType.verifiableIdCard.supportSingleOnly, true);
      expect(CredentialSubjectType.over13.supportSingleOnly, true);
      expect(CredentialSubjectType.over15.supportSingleOnly, true);
      expect(CredentialSubjectType.over18.supportSingleOnly, true);
      expect(CredentialSubjectType.over21.supportSingleOnly, true);
      expect(CredentialSubjectType.over50.supportSingleOnly, true);
      expect(CredentialSubjectType.over65.supportSingleOnly, true);
      expect(CredentialSubjectType.passportFootprint.supportSingleOnly, true);
      expect(CredentialSubjectType.residentCard.supportSingleOnly, true);
      expect(CredentialSubjectType.voucher.supportSingleOnly, true);
      expect(CredentialSubjectType.tezVoucher.supportSingleOnly, true);
      expect(CredentialSubjectType.diplomaCard.supportSingleOnly, true);
      expect(CredentialSubjectType.twitterCard.supportSingleOnly, true);
      expect(
        CredentialSubjectType.tezosAssociatedWallet.supportSingleOnly,
        true,
      );
      expect(
        CredentialSubjectType.ethereumAssociatedWallet.supportSingleOnly,
        true,
      );
      expect(
        CredentialSubjectType.fantomAssociatedWallet.supportSingleOnly,
        true,
      );
      expect(
        CredentialSubjectType.polygonAssociatedWallet.supportSingleOnly,
        true,
      );
      expect(
        CredentialSubjectType.binanceAssociatedWallet.supportSingleOnly,
        true,
      );

      expect(CredentialSubjectType.walletCredential.supportSingleOnly, false);
      expect(CredentialSubjectType.tezosPooAddress.supportSingleOnly, false);
      expect(CredentialSubjectType.ethereumPooAddress.supportSingleOnly, false);
      expect(CredentialSubjectType.fantomPooAddress.supportSingleOnly, false);
      expect(CredentialSubjectType.polygonPooAddress.supportSingleOnly, false);
      expect(CredentialSubjectType.binancePooAddress.supportSingleOnly, false);
      expect(
        CredentialSubjectType.certificateOfEmployment.supportSingleOnly,
        false,
      );
      expect(CredentialSubjectType.defaultCredential.supportSingleOnly, false);
      expect(CredentialSubjectType.emailPass.supportSingleOnly, false);
      expect(CredentialSubjectType.linkedInCard.supportSingleOnly, false);
      expect(
        CredentialSubjectType.learningAchievement.supportSingleOnly,
        false,
      );
      expect(CredentialSubjectType.phonePass.supportSingleOnly, false);
      expect(
        CredentialSubjectType
            .professionalExperienceAssessment.supportSingleOnly,
        false,
      );
      expect(
        CredentialSubjectType.professionalSkillAssessment.supportSingleOnly,
        false,
      );
      expect(
        CredentialSubjectType.professionalStudentCard.supportSingleOnly,
        false,
      );
      expect(CredentialSubjectType.selfIssued.supportSingleOnly, false);
      expect(CredentialSubjectType.studentCard.supportSingleOnly, false);
      expect(CredentialSubjectType.aragoPass.supportSingleOnly, false);
      expect(CredentialSubjectType.aragoEmailPass.supportSingleOnly, false);
      expect(CredentialSubjectType.aragoIdentityCard.supportSingleOnly, false);
      expect(
        CredentialSubjectType.aragoLearningAchievement.supportSingleOnly,
        false,
      );
      expect(CredentialSubjectType.aragoOver18.supportSingleOnly, false);
      expect(
        CredentialSubjectType.pcdsAgentCertificate.supportSingleOnly,
        false,
      );
      expect(CredentialSubjectType.euDiplomaCard.supportSingleOnly, false);
      expect(CredentialSubjectType.euVerifiableId.supportSingleOnly, false);
      expect(CredentialSubjectType.kycAgeCredential.supportSingleOnly, false);
      expect(
        CredentialSubjectType.kycCountryOfResidence.supportSingleOnly,
        false,
      );
      expect(
        CredentialSubjectType.proofOfTwitterStats.supportSingleOnly,
        false,
      );
      expect(
        CredentialSubjectType.civicPassCredential.supportSingleOnly,
        false,
      );
      expect(CredentialSubjectType.employeeCredential.supportSingleOnly, false);
      expect(
        CredentialSubjectType.legalPersonalCredential.supportSingleOnly,
        false,
      );
      expect(CredentialSubjectType.identityCredential.supportSingleOnly, false);
      expect(CredentialSubjectType.eudiPid.supportSingleOnly, false);
      expect(CredentialSubjectType.pid.supportSingleOnly, false);
    });

    test('CredentialSubjectType getVCFormatType returns correct value', () {
      expect(
        CredentialSubjectType.ethereumAssociatedWallet.getVCFormatType,
        VCFormatType.values,
      );
      expect(
        CredentialSubjectType.fantomAssociatedWallet.getVCFormatType,
        VCFormatType.values,
      );
      expect(
        CredentialSubjectType.polygonAssociatedWallet.getVCFormatType,
        VCFormatType.values,
      );
      expect(
        CredentialSubjectType.binanceAssociatedWallet.getVCFormatType,
        VCFormatType.values,
      );
      expect(
        CredentialSubjectType.tezosAssociatedWallet.getVCFormatType,
        VCFormatType.values,
      );

      expect(
        CredentialSubjectType.over13.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.over15.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.over21.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.over50.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.over65.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.gender.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.ageRange.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.defiCompliance.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.tezotopiaMembership.getVCFormatType,
        [VCFormatType.ldpVc],
      );
      expect(
        CredentialSubjectType.chainbornMembership.getVCFormatType,
        [VCFormatType.ldpVc],
      );

      expect(CredentialSubjectType.verifiableIdCard.getVCFormatType, [
        VCFormatType.ldpVc,
        VCFormatType.jwtVcJson,
        VCFormatType.vcSdJWT,
        VCFormatType.jwtVc,
      ]);

      expect(
        CredentialSubjectType.identityCredential.getVCFormatType,
        [VCFormatType.vcSdJWT],
      );
      expect(
        CredentialSubjectType.eudiPid.getVCFormatType,
        [VCFormatType.vcSdJWT],
      );
      expect(CredentialSubjectType.pid.getVCFormatType, [VCFormatType.vcSdJWT]);

      expect(CredentialSubjectType.over18.getVCFormatType, [
        VCFormatType.ldpVc,
        VCFormatType.jwtVcJson,
      ]);

      expect(
        CredentialSubjectType.phonePass.getVCFormatType,
        [VCFormatType.ldpVc, VCFormatType.jwtVcJson],
      );
      expect(
        CredentialSubjectType.livenessCard.getVCFormatType,
        [VCFormatType.ldpVc, VCFormatType.jwtVcJson],
      );
      expect(
        CredentialSubjectType.emailPass.getVCFormatType,
        [VCFormatType.ldpVc, VCFormatType.jwtVcJson],
      );

      expect(
        CredentialSubjectType.nationality.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.identityPass.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.passportFootprint.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.residentCard.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.voucher.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.tezVoucher.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.diplomaCard.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.twitterCard.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.walletCredential.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.tezosPooAddress.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.ethereumPooAddress.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.fantomPooAddress.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.polygonPooAddress.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.binancePooAddress.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.certificateOfEmployment.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.defaultCredential.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.linkedInCard.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.learningAchievement.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.professionalExperienceAssessment.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.professionalSkillAssessment.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.professionalStudentCard.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.selfIssued.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.studentCard.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.aragoPass.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.aragoEmailPass.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.aragoIdentityCard.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.aragoLearningAchievement.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.aragoOver18.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.pcdsAgentCertificate.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.euDiplomaCard.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.euVerifiableId.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.kycAgeCredential.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.kycCountryOfResidence.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.proofOfTwitterStats.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.civicPassCredential.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.employeeCredential.getVCFormatType,
        [VCFormatType.jwtVc],
      );
      expect(
        CredentialSubjectType.legalPersonalCredential.getVCFormatType,
        [VCFormatType.jwtVc],
      );
    });

    test('CredentialSubjectType order returns correct value', () {
      expect(CredentialSubjectType.defiCompliance.order, 0);
      expect(CredentialSubjectType.livenessCard.order, 75);
      expect(CredentialSubjectType.tezotopiaMembership.order, 79);
      expect(CredentialSubjectType.chainbornMembership.order, 72);
      expect(CredentialSubjectType.ageRange.order, 94);
      expect(CredentialSubjectType.nationality.order, 97.3);
      expect(CredentialSubjectType.gender.order, 93);
      expect(CredentialSubjectType.walletCredential.order, 0);
      expect(CredentialSubjectType.tezosAssociatedWallet.order, 68);
      expect(CredentialSubjectType.ethereumAssociatedWallet.order, 69);
      expect(CredentialSubjectType.fantomAssociatedWallet.order, 67);
      expect(CredentialSubjectType.polygonAssociatedWallet.order, 71);
      expect(CredentialSubjectType.binanceAssociatedWallet.order, 70);
      expect(CredentialSubjectType.tezosPooAddress.order, 0);
      expect(CredentialSubjectType.ethereumPooAddress.order, 0);
      expect(CredentialSubjectType.fantomPooAddress.order, 0);
      expect(CredentialSubjectType.polygonPooAddress.order, 0);
      expect(CredentialSubjectType.binancePooAddress.order, 0);
      expect(CredentialSubjectType.certificateOfEmployment.order, 85);
      expect(CredentialSubjectType.defaultCredential.order, 100);
      expect(CredentialSubjectType.emailPass.order, 99);
      expect(CredentialSubjectType.identityPass.order, 90);
      expect(CredentialSubjectType.verifiableIdCard.order, 97.5);
      expect(CredentialSubjectType.linkedInCard.order, 86);
      expect(CredentialSubjectType.learningAchievement.order, 0);
      expect(CredentialSubjectType.over13.order, 97.3);
      expect(CredentialSubjectType.over15.order, 97.2);
      expect(CredentialSubjectType.over18.order, 97.1);
      expect(CredentialSubjectType.over21.order, 97);
      expect(CredentialSubjectType.over50.order, 96);
      expect(CredentialSubjectType.over65.order, 95);
      expect(CredentialSubjectType.passportFootprint.order, 91);
      expect(CredentialSubjectType.phonePass.order, 98);
      expect(CredentialSubjectType.professionalExperienceAssessment.order, 0);
      expect(CredentialSubjectType.professionalSkillAssessment.order, 0);
      expect(CredentialSubjectType.professionalStudentCard.order, 87);
      expect(CredentialSubjectType.residentCard.order, 0);
      expect(CredentialSubjectType.selfIssued.order, 0);
      expect(CredentialSubjectType.studentCard.order, 88);
      expect(CredentialSubjectType.voucher.order, 81);
      expect(CredentialSubjectType.tezVoucher.order, 80);
      expect(CredentialSubjectType.diplomaCard.order, 89);
      expect(CredentialSubjectType.aragoPass.order, 81);
      expect(CredentialSubjectType.aragoEmailPass.order, 0);
      expect(CredentialSubjectType.aragoIdentityCard.order, 0);
      expect(CredentialSubjectType.aragoLearningAchievement.order, 0);
      expect(CredentialSubjectType.aragoOver18.order, 0);
      expect(CredentialSubjectType.pcdsAgentCertificate.order, 82);
      expect(CredentialSubjectType.twitterCard.order, 83);
      expect(CredentialSubjectType.euDiplomaCard.order, 67);
      expect(CredentialSubjectType.euVerifiableId.order, 92);
      expect(CredentialSubjectType.kycAgeCredential.order, 0);
      expect(CredentialSubjectType.kycCountryOfResidence.order, 0);
      expect(CredentialSubjectType.proofOfTwitterStats.order, 0);
      expect(CredentialSubjectType.civicPassCredential.order, 0);
      expect(CredentialSubjectType.employeeCredential.order, 0);
      expect(CredentialSubjectType.legalPersonalCredential.order, 0);
      expect(CredentialSubjectType.identityCredential.order, 0);
      expect(CredentialSubjectType.eudiPid.order, 0);
      expect(CredentialSubjectType.pid.order, 0);
    });
  });
}
