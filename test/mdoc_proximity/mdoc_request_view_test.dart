import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class _MockCredential extends Mock implements Credential {}

void main() {
  CredentialModel mdoc(String id, String docType, Map<String, dynamic> ns) =>
      CredentialModel(
        id: id,
        image: '',
        shareLink: '',
        data: {
          'issuerSigned': 'issuer-signed',
          'docType': docType,
          'credentialSubject': ns,
        },
        credentialPreview: _MockCredential(),
        format: 'mso_mdoc',
        keyId: 'mdoc_$id',
      );

  final pid = mdoc('pid', eudiPidDocType, {
    eudiPidDocType: {'family_name': 'DOE', 'given_name': 'JANE'},
  });

  const documents = [
    ProximityDocumentRequest(
      docType: eudiPidDocType,
      nameSpaces: {
        eudiPidDocType: {'family_name': false, 'birth_date': false},
      },
      mdocId: 'pid',
    ),
    ProximityDocumentRequest(
      docType: 'org.iso.18013.5.1.mDL',
      nameSpaces: {
        'org.iso.18013.5.1': {'portrait': false},
      },
    ),
  ];

  Future<Map<String, Map<String, List<String>>>?> pump(
    WidgetTester tester,
  ) async {
    Map<String, Map<String, List<String>>>? shared;
    await tester.pumpApp(
      Scaffold(
        body: MdocRequestView(
          credentials: [pid],
          documents: documents,
          onShare: (elements) => shared = elements,
          onCancel: () {},
        ),
      ),
    );
    await tester.tap(find.byType(MyElevatedButton));
    return shared;
  }

  group('MdocRequestView', () {
    testWidgets('names the attestation answering each requested document', (
      tester,
    ) async {
      await pump(tester);

      // The PID answers with the wallet's attestation, the mDL with none.
      expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
      expect(find.byIcon(Icons.block), findsOneWidget);
      expect(find.text('org.iso.18013.5.1.mDL'), findsOneWidget);
      expect(find.text('Cannot be shared in this session'), findsOneWidget);
      expect(find.text('DOE'), findsOneWidget);
    });

    testWidgets('shares only what the answering attestation holds', (
      tester,
    ) async {
      final shared = await pump(tester);

      expect(shared, {
        eudiPidDocType: {
          eudiPidDocType: ['family_name'],
        },
      });
    });
  });
}
