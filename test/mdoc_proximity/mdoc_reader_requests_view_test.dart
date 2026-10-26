import 'package:altme/app/app.dart';
import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

import '../helpers/helpers.dart';

class _MockSecureStorage extends Mock implements SecureStorageProvider {}

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

  const badge = ReaderRequest(
    id: 'badge',
    name: 'Badge',
    query: {
      'org.example.badge.1': {
        'org.example.badge.1': {'holder_name': false, 'site': true},
      },
    },
  );

  // The menu of a request of the user's, whose action type is private.
  final requestMenu = find.byWidgetPredicate(
    (widget) => widget is PopupMenuButton,
  );

  /// Pumps the view with the custom requests [saved] already stored. The
  /// cubit is made here, not in `setUp`: its storage work has to run in the
  /// test's fake async zone to be pumped.
  Future<CustomReaderRequestsCubit> pumpView(
    WidgetTester tester, {
    List<ReaderRequest> saved = const [],
    Future<String?> Function(BuildContext context)? scan,
  }) async {
    final storage = _MockSecureStorage();
    when(() => storage.get(any())).thenAnswer((_) async => null);
    when(() => storage.set(any(), any())).thenAnswer((_) async {});
    final custom = CustomReaderRequestsCubit(secureStorage: storage);
    addTearDown(custom.close);
    await custom.loaded;
    for (final request in saved) {
      await custom.save(request);
    }

    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      Scaffold(
        body: scan == null
            ? const MdocReaderRequestsView(requests: requests)
            : MdocReaderRequestsView(requests: requests, scan: scan),
      ),
      wrapApp: (app) => BlocProvider.value(value: custom, child: app),
    );
    return custom;
  }

  group('MdocReaderRequestsView', () {
    testWidgets('lists the requests with their document types', (tester) async {
      await pumpView(tester);

      expect(find.text('PID'), findsOneWidget);
      expect(find.text('mDL'), findsOneWidget);
      expect(find.text(eudiPidDocType), findsOneWidget);
      expect(find.text('org.iso.18013.5.1.mDL'), findsOneWidget);
    });

    testWidgets('opens the camera when a request is picked', (tester) async {
      var scans = 0;
      await pumpView(
        tester,
        scan: (_) async {
          scans++;
          return null;
        },
      );

      await tester.tap(find.text('mDL'));
      await tester.pumpAndSettle();

      expect(scans, 1);
      expect(find.byType(MdocReaderPage), findsNothing);
    });

    testWidgets('refuses a QR code that is not a holder engagement', (
      tester,
    ) async {
      await pumpView(tester, scan: (_) async => 'openid4vp://?request_uri=x');

      await tester.tap(find.text('PID'));
      await tester.pump();

      expect(
        find.text('This is not a wallet QR code to read in person.'),
        findsOneWidget,
      );
      expect(find.byType(MdocReaderPage), findsNothing);
    });

    group('my requests', () {
      testWidgets('offers to add one when there is none', (tester) async {
        await pumpView(tester);

        expect(find.text('My requests'), findsOneWidget);
        expect(find.text('ADD A REQUEST'), findsOneWidget);
        expect(requestMenu, findsNothing);
      });

      testWidgets("lists them after the profile's with their claim count", (
        tester,
      ) async {
        await pumpView(tester, saved: [badge]);

        expect(find.text('Badge'), findsOneWidget);
        expect(find.text('org.example.badge.1 · 2 claims'), findsOneWidget);
        // The profile's requests are still there, above.
        expect(
          tester.getTopLeft(find.text('mDL')).dy,
          lessThan(tester.getTopLeft(find.text('Badge')).dy),
        );
      });

      testWidgets('opens the camera when one is picked', (tester) async {
        var scans = 0;
        await pumpView(
          tester,
          saved: [badge],
          scan: (_) async {
            scans++;
            return null;
          },
        );

        await tester.tap(find.text('Badge'));
        await tester.pumpAndSettle();

        expect(scans, 1);
      });

      testWidgets('adds one through the editor', (tester) async {
        final custom = await pumpView(tester);

        await tester.tap(find.text('ADD A REQUEST'));
        await tester.pumpAndSettle();
        expect(find.text('New request'), findsOneWidget);

        await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Mine');
        await tester.tap(find.widgetWithText(ChoiceChip, 'PID'));
        await tester.pump();
        await tester.tap(find.textContaining('Suggested claims'));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(ActionChip, '+ birth_date'));
        await tester.pump();
        await tester.tap(find.text('SAVE'));
        await tester.pumpAndSettle();

        expect(custom.state.requests.single.name, 'Mine');
        // Back on the list, which shows it.
        expect(find.text('New request'), findsNothing);
        expect(find.text('Mine'), findsOneWidget);
        expect(find.text('$eudiPidDocType · 1 claim'), findsOneWidget);
      });

      testWidgets('edits one through the editor', (tester) async {
        final custom = await pumpView(tester, saved: [badge]);

        await tester.tap(requestMenu);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Edit'));
        await tester.pumpAndSettle();

        expect(find.text('Edit request'), findsOneWidget);
        expect(
          tester
              .widget<TextField>(find.widgetWithText(TextField, 'Name'))
              .controller!
              .text,
          'Badge',
        );

        await tester.enterText(
          find.widgetWithText(TextField, 'Name'),
          'Badge 2',
        );
        await tester.tap(find.text('SAVE'));
        await tester.pumpAndSettle();

        expect(custom.state.requests.single.id, 'badge');
        expect(find.text('Badge 2'), findsOneWidget);
        expect(find.text('Badge'), findsNothing);
      });

      testWidgets('deletes one once confirmed', (tester) async {
        final custom = await pumpView(tester, saved: [badge]);

        await tester.tap(requestMenu);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();
        expect(find.text('Delete this request?'), findsOneWidget);
        expect(custom.state.requests, [badge]);

        await tester.tap(
          find.descendant(
            of: find.byType(ConfirmDialog),
            matching: find.text('DELETE'),
          ),
        );
        await tester.pumpAndSettle();

        expect(custom.state.requests, isEmpty);
        expect(find.text('Badge'), findsNothing);
      });

      testWidgets('keeps one when the deletion is cancelled', (tester) async {
        final custom = await pumpView(tester, saved: [badge]);

        await tester.tap(requestMenu);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byType(ConfirmDialog),
            matching: find.text('CANCEL'),
          ),
        );
        await tester.pumpAndSettle();

        expect(custom.state.requests, [badge]);
        expect(find.text('Badge'), findsOneWidget);
      });
    });
  });
}
