import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

import '../helpers/helpers.dart';

void main() {
  const requests = [
    ReaderRequest(
      id: 'pid-basic',
      name: 'PID',
      query: {
        eudiPidDocType: {
          eudiPidDocType: {'family_name': false},
        },
      },
    ),
    ReaderRequest(id: 'mdl-basic', name: 'mDL', query: mdlReaderQuery),
  ];

  group('MdocReaderRequestsView', () {
    testWidgets('lists the requests with their document types', (tester) async {
      await tester.pumpApp(
        const Scaffold(body: MdocReaderRequestsView(requests: requests)),
      );

      expect(find.text('PID'), findsOneWidget);
      expect(find.text('mDL'), findsOneWidget);
      expect(find.text(eudiPidDocType), findsOneWidget);
      expect(find.text('org.iso.18013.5.1.mDL'), findsOneWidget);
    });

    testWidgets('opens the camera when a request is picked', (tester) async {
      var scans = 0;
      await tester.pumpApp(
        Scaffold(
          body: MdocReaderRequestsView(
            requests: requests,
            scan: (_) async {
              scans++;
              return null;
            },
          ),
        ),
      );

      await tester.tap(find.text('mDL'));
      await tester.pumpAndSettle();

      expect(scans, 1);
      expect(find.byType(MdocReaderPage), findsNothing);
    });

    testWidgets('refuses a QR code that is not a holder engagement', (
      tester,
    ) async {
      await tester.pumpApp(
        Scaffold(
          body: MdocReaderRequestsView(
            requests: requests,
            scan: (_) async => 'openid4vp://?request_uri=x',
          ),
        ),
      );

      await tester.tap(find.text('PID'));
      await tester.pump();

      expect(
        find.text('This is not a wallet QR code to read in person.'),
        findsOneWidget,
      );
      expect(find.byType(MdocReaderPage), findsNothing);
    });
  });
}
