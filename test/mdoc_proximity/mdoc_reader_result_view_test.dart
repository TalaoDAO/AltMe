import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

import '../helpers/helpers.dart';

const _noTrustAnchor =
    'certificate chain validation failed: IACA certificate error: no valid '
    'trust anchor found';
const _digestMismatch =
    'issuer authentication failed: a disclosed element does not match its '
    'digest in the MSO';

void main() {
  const trusted = ReaderDocument(
    docType: 'org.iso.18013.5.1.mDL',
    nameSpaces: {
      'org.iso.18013.5.1': {'family_name': 'DOE'},
    },
  );
  const untrusted = ReaderDocument(
    docType: eudiPidDocType,
    nameSpaces: {
      eudiPidDocType: {'family_name': 'ROE'},
    },
    issuerTrustErrors: [_noTrustAnchor],
  );

  Future<void> pump(WidgetTester tester, ReaderResult result) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);
    await tester.pumpApp(Scaffold(body: MdocReaderResultView(result: result)));
  }

  group('MdocReaderResultView', () {
    testWidgets('shows a document of a trusted issuer as verified', (
      tester,
    ) async {
      await pump(tester, const ReaderResult(documents: [trusted]));

      expect(find.text('Trusted issuer'), findsOneWidget);
      expect(find.text('Issuer not verified'), findsNothing);
      expect(
        find.text('Issuer and device signatures verified'),
        findsOneWidget,
      );
      expect(find.text('DOE'), findsOneWidget);
      expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
      expect(find.text('Not verified'), findsNothing);
    });

    testWidgets('shows a document of an untrusted issuer with its elements '
        'and marks the issuer as not trusted', (tester) async {
      await pump(tester, const ReaderResult(documents: [untrusted]));

      expect(find.text('Issuer not verified'), findsOneWidget);
      expect(
        find.text('The identity of this issuer could not be verified.'),
        findsOneWidget,
      );
      expect(find.text('Trusted issuer'), findsNothing);
      expect(find.text(_noTrustAnchor), findsOneWidget);
      expect(find.text('ROE'), findsOneWidget);
      expect(find.byIcon(Icons.gpp_maybe_outlined), findsOneWidget);
      expect(find.byIcon(Icons.verified_outlined), findsNothing);
      // The document was read: it is not among those that failed.
      expect(find.text('Not verified'), findsNothing);
    });

    testWidgets('marks each document by its own issuer', (tester) async {
      await pump(tester, const ReaderResult(documents: [trusted, untrusted]));

      expect(find.text('Trusted issuer'), findsOneWidget);
      expect(find.text('Issuer not verified'), findsOneWidget);
      expect(find.text('DOE'), findsOneWidget);
      expect(find.text('ROE'), findsOneWidget);
    });

    testWidgets('still lists a failed document under not verified', (
      tester,
    ) async {
      await pump(
        tester,
        const ReaderResult(
          documents: [untrusted],
          failedDocTypes: ['org.iso.18013.5.1.mDL'],
          documentErrors: {
            'org.iso.18013.5.1.mDL': [_digestMismatch],
          },
        ),
      );

      expect(find.text('Not verified'), findsOneWidget);
      expect(find.text('org.iso.18013.5.1.mDL'), findsOneWidget);
      expect(find.text(_digestMismatch), findsOneWidget);
      expect(find.text('Issuer not verified'), findsOneWidget);
    });
  });
}
