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
        profileLinkedId: '',
      );
      final credentialModel2 = CredentialModel(
        id: '',
        credentialPreview: Credential.dummy(),
        data: const <String, dynamic>{},
        image: '',
        shareLink: '',
        profileLinkedId: '',
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
        CredentialSubjectType.etherlinkAssociatedWallet.defaultBackgroundColor,
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
        CredentialSubjectType.etherlinkAssociatedWallet.name,
        equals('EtherlinkAssociatedAddress'),
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
            value == CredentialSubjectType.passportFootprint) {
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
            value == CredentialSubjectType.polygonAssociatedWallet ||
            value == CredentialSubjectType.etherlinkAssociatedWallet) {
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
        } else if (value == CredentialSubjectType.etherlinkAssociatedWallet) {
          expect(
            value.blockchainWidget,
            isA<EtherlinkAssociatedAddressWidget>(),
          );
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
        CredentialSubjectType.etherlinkAssociatedWallet.title,
        'Etherlink Associated Address',
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

      expect(
        CredentialSubjectType.etherlinkAssociatedWallet.supportSingleOnly,
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
      expect(CredentialSubjectType.employeeCredential.supportSingleOnly, false);
      expect(
        CredentialSubjectType.legalPersonalCredential.supportSingleOnly,
        false,
      );
      expect(CredentialSubjectType.identityCredential.supportSingleOnly, false);
      expect(CredentialSubjectType.eudiPid.supportSingleOnly, false);
      expect(CredentialSubjectType.pid.supportSingleOnly, false);
    });

    test('returns correct VCFormatType values for each CredentialSubjectType',
        () {
      void verifyVCFormatType(
        CredentialSubjectType subjectType,
        List<VCFormatType> expectedValues,
      ) {
        expect(
          subjectType.getVCFormatType,
          equals(expectedValues),
          reason: 'Failed for $subjectType',
        );
      }

      for (final type in CredentialSubjectType.values) {
        switch (type) {
          case CredentialSubjectType.ethereumAssociatedWallet:
          case CredentialSubjectType.fantomAssociatedWallet:
          case CredentialSubjectType.polygonAssociatedWallet:
          case CredentialSubjectType.binanceAssociatedWallet:
          case CredentialSubjectType.tezosAssociatedWallet:
          case CredentialSubjectType.etherlinkAssociatedWallet:
            verifyVCFormatType(type, VCFormatType.values);

          case CredentialSubjectType.over13:
          case CredentialSubjectType.over15:
          case CredentialSubjectType.over21:
          case CredentialSubjectType.over50:
          case CredentialSubjectType.over65:
          case CredentialSubjectType.ageRange:
          case CredentialSubjectType.gender:
          case CredentialSubjectType.chainbornMembership:
          case CredentialSubjectType.tezotopiaMembership:
          case CredentialSubjectType.defiCompliance:
            verifyVCFormatType(type, [VCFormatType.ldpVc, VCFormatType.auto]);

          case CredentialSubjectType.over18:
          case CredentialSubjectType.livenessCard:
          case CredentialSubjectType.phonePass:
            verifyVCFormatType(type, [
              VCFormatType.ldpVc,
              VCFormatType.jwtVcJson,
              VCFormatType.auto,
            ]);

          case CredentialSubjectType.verifiableIdCard:
            verifyVCFormatType(type, [
              VCFormatType.ldpVc,
              VCFormatType.jwtVcJson,
              VCFormatType.vcSdJWT,
              VCFormatType.jwtVc,
              VCFormatType.auto,
            ]);

          case CredentialSubjectType.emailPass:
            verifyVCFormatType(type, [
              VCFormatType.ldpVc,
              VCFormatType.jwtVcJson,
              VCFormatType.auto,
              VCFormatType.vcSdJWT,
            ]);

          case CredentialSubjectType.identityCredential:
          case CredentialSubjectType.eudiPid:
          case CredentialSubjectType.pid:
            verifyVCFormatType(type, [VCFormatType.vcSdJWT, VCFormatType.auto]);

          case CredentialSubjectType.nationality:
          case CredentialSubjectType.identityPass:
          case CredentialSubjectType.passportFootprint:
          case CredentialSubjectType.residentCard:
          case CredentialSubjectType.voucher:
          case CredentialSubjectType.tezVoucher:
          case CredentialSubjectType.diplomaCard:
          case CredentialSubjectType.twitterCard:
          case CredentialSubjectType.walletCredential:
          case CredentialSubjectType.tezosPooAddress:
          case CredentialSubjectType.ethereumPooAddress:
          case CredentialSubjectType.fantomPooAddress:
          case CredentialSubjectType.polygonPooAddress:
          case CredentialSubjectType.binancePooAddress:
          case CredentialSubjectType.certificateOfEmployment:
          case CredentialSubjectType.defaultCredential:
          case CredentialSubjectType.learningAchievement:
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
            verifyVCFormatType(type, [VCFormatType.jwtVc, VCFormatType.auto]);
        }
      }
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
      expect(CredentialSubjectType.etherlinkAssociatedWallet.order, 72);
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
      expect(CredentialSubjectType.employeeCredential.order, 0);
      expect(CredentialSubjectType.legalPersonalCredential.order, 0);
      expect(CredentialSubjectType.identityCredential.order, 0);
      expect(CredentialSubjectType.eudiPid.order, 0);
      expect(CredentialSubjectType.pid.order, 0);
    });
  });
}
