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
  CredentialModel mdoc(
    String id,
    String docType,
    Map<String, dynamic> ns, {
    String? name,
  }) => CredentialModel(
    id: id,
    image: '',
    shareLink: '',
    data: {
      'issuerSigned': 'issuer-signed-$id',
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
  final otherPid = mdoc('pid-2', eudiPidDocType, {
    eudiPidDocType: {'family_name': 'ROE', 'given_name': 'RICHARD'},
  });

  const documents = [
    ProximityDocumentRequest(
      docType: eudiPidDocType,
      nameSpaces: {
        eudiPidDocType: {'family_name': false, 'birth_date': false},
      },
    ),
    ProximityDocumentRequest(
      docType: 'org.iso.18013.5.1.mDL',
      nameSpaces: {
        'org.iso.18013.5.1': {'portrait': false},
      },
    ),
  ];

  late List<ProximityDisclosure>? shared;
  late bool declined;

  Future<void> pump(
    WidgetTester tester, {
    required Map<String, List<CredentialModel>> candidates,
    List<ProximityDocumentRequest> requested = documents,
  }) async {
    shared = null;
    declined = false;
    await tester.pumpApp(
      Scaffold(
        body: MdocRequestView(
          documents: requested,
          candidates: candidates,
          onShare: (disclosures) => shared = disclosures,
          onDecline: () => declined = true,
        ),
      ),
    );
  }

  group('MdocRequestView', () {
    testWidgets('names the attestation answering each requested document', (
      tester,
    ) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
          'org.iso.18013.5.1.mDL': [],
        },
      );

      // The PID answers with the wallet's attestation, the mDL with none.
      expect(find.byIcon(Icons.badge_outlined), findsOneWidget);
      expect(find.byIcon(Icons.block), findsOneWidget);
      expect(find.text('org.iso.18013.5.1.mDL'), findsOneWidget);
      expect(find.text('Cannot be shared in this session'), findsOneWidget);
      expect(find.text('DOE'), findsOneWidget);
      expect(
        find.byType(DropdownButtonFormField<CredentialModel>),
        findsNothing,
      );
    });

    testWidgets('shares only what the answering attestation holds', (
      tester,
    ) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
          'org.iso.18013.5.1.mDL': [],
        },
      );

      await tester.tap(find.byType(MyElevatedButton));

      expect(shared, [
        ProximityDisclosure(
          mdoc: pid.proximityMdoc,
          elements: const {
            eudiPidDocType: ['family_name'],
          },
        ),
      ]);
    });

    testWidgets('shares one disclosure per document it can answer', (
      tester,
    ) async {
      final mdl = mdoc('mdl', 'org.iso.18013.5.1.mDL', {
        'org.iso.18013.5.1': {'portrait': 'bytes'},
      });
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
          'org.iso.18013.5.1.mDL': [mdl],
        },
      );

      await tester.tap(find.byType(MyElevatedButton));

      expect(shared?.map((disclosure) => disclosure.mdoc.id), ['pid', 'mdl']);
    });

    testWidgets('leaves out an element the user unticks', (tester) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
        },
        requested: [documents.first],
      );

      await tester.tap(find.byType(CheckboxListTile).first);
      await tester.pump();

      // The only element held is unticked: nothing left to share.
      final button = tester.widget<MyElevatedButton>(
        find.byType(MyElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('lets the user choose between two attestations of a type', (
      tester,
    ) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid, otherPid],
        },
        requested: [documents.first],
      );

      expect(find.text('DOE'), findsOneWidget);
      expect(find.text('ROE'), findsNothing);

      await tester.tap(find.byType(DropdownButtonFormField<CredentialModel>));
      await tester.pumpAndSettle();
      await tester.tap(find.textContaining('(2)').last);
      await tester.pumpAndSettle();

      expect(find.text('ROE'), findsOneWidget);
      expect(find.text('DOE'), findsNothing);

      await tester.tap(find.byType(MyElevatedButton));

      expect(shared, [
        ProximityDisclosure(
          mdoc: otherPid.proximityMdoc,
          elements: const {
            eudiPidDocType: ['family_name'],
          },
        ),
      ]);
    });

    testWidgets('cannot share when no document can be answered', (
      tester,
    ) async {
      await pump(
        tester,
        candidates: {eudiPidDocType: [], 'org.iso.18013.5.1.mDL': []},
      );

      final button = tester.widget<MyElevatedButton>(
        find.byType(MyElevatedButton),
      );
      expect(button.onPressed, isNull);
    });

    testWidgets('declines', (tester) async {
      await pump(
        tester,
        candidates: {
          eudiPidDocType: [pid],
        },
      );

      await tester.tap(find.byType(MyOutlinedButton));

      expect(declined, isTrue);
      expect(shared, isNull);
    });
  });
}
