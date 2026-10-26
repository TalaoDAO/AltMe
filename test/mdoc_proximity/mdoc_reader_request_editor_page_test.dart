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
  const saved = ReaderRequest(
    id: 'saved',
    name: 'Names',
    query: {
      eudiPidDocType: {
        eudiPidDocType: {'family_name': false, 'given_name': true},
      },
    },
  );

  late CustomReaderRequestsCubit requests;

  Finder field(String label) => find.widgetWithText(TextField, label);

  /// Opens the suggested claims of the [document]th card that has them.
  Future<void> openSuggestions(WidgetTester tester, {int document = 0}) async {
    await tester.tap(find.textContaining('Suggested claims').at(document));
    await tester.pumpAndSettle();
  }

  /// Opens the editor from a page with a button, so a save or delete that
  /// leaves the editor can be seen. [existing] are the requests already saved.
  ///
  /// The cubit is made here, not in `setUp`: its storage work has to run in
  /// the test's fake async zone to be pumped.
  Future<void> openEditor(
    WidgetTester tester, {
    ReaderRequest? request,
    List<ReaderRequest> existing = const [],
  }) async {
    final storage = _MockSecureStorage();
    when(() => storage.get(any())).thenAnswer((_) async => null);
    when(() => storage.set(any(), any())).thenAnswer((_) async {});
    requests = CustomReaderRequestsCubit(secureStorage: storage);
    addTearDown(requests.close);
    await requests.loaded;
    for (final saved in existing) {
      await requests.save(saved);
    }

    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () => Navigator.of(
              context,
            ).push(MdocReaderRequestEditorPage.route(request: request)),
            child: const Text('open'),
          ),
        ),
      ),
      wrapApp: (app) => BlocProvider.value(value: requests, child: app),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  group('MdocReaderRequestEditorPage', () {
    group('new request', () {
      testWidgets('starts empty', (tester) async {
        await openEditor(tester);

        expect(find.text('New request'), findsOneWidget);
        expect(find.text('Document 1'), findsOneWidget);
        expect(find.text('None selected'), findsOneWidget);
        // Only a saved request can be deleted.
        expect(find.text('DELETE'), findsNothing);
      });

      testWidgets('saves a document picked from a preset with claims', (
        tester,
      ) async {
        await openEditor(tester);

        await tester.enterText(field('Name'), 'Age check');
        await tester.tap(find.widgetWithText(ChoiceChip, 'mDL'));
        await tester.pump();
        await openSuggestions(tester);
        await tester.tap(find.widgetWithText(ActionChip, '+ birth_date'));
        await tester.pump();
        await tester.tap(find.widgetWithText(ActionChip, '+ age_over_18'));
        await tester.pump();

        expect(field('Document type'), findsOneWidget);
        expect(
          tester.widget<TextField>(field('Document type')).controller!.text,
          'org.iso.18013.5.1.mDL',
        );
        expect(
          tester.widget<TextField>(field('Name space')).controller!.text,
          'org.iso.18013.5.1',
        );

        await tester.tap(find.text('SAVE'));
        await tester.pumpAndSettle();

        expect(requests.state.requests, hasLength(1));
        final request = requests.state.requests.single;
        expect(request.name, 'Age check');
        expect(request.query, {
          'org.iso.18013.5.1.mDL': {
            'org.iso.18013.5.1': {'birth_date': false, 'age_over_18': false},
          },
        });
        // The editor closed.
        expect(find.byType(MdocReaderRequestEditorPage), findsNothing);
      });

      testWidgets('saves a document of its own with a typed claim', (
        tester,
      ) async {
        await openEditor(tester);

        await tester.enterText(field('Name'), 'Badge');
        await tester.enterText(field('Document type'), 'org.example.badge.1');
        await tester.enterText(field('Name space'), 'org.example.badge.1');
        await tester.enterText(field('Add a claim'), 'holder_name');
        await tester.tap(find.byTooltip('Add a claim'));
        await tester.pump();

        // The field is cleared for the next claim and the claim is listed.
        expect(
          tester.widget<TextField>(field('Add a claim')).controller!.text,
          isEmpty,
        );
        expect(find.byType(Switch), findsOneWidget);

        await tester.tap(find.byType(Switch));
        await tester.pump();
        await tester.tap(find.text('SAVE'));
        await tester.pumpAndSettle();

        expect(requests.state.requests.single.query, {
          'org.example.badge.1': {
            'org.example.badge.1': {'holder_name': true},
          },
        });
      });

      testWidgets('does not add a claim twice', (tester) async {
        await openEditor(tester);

        for (var i = 0; i < 2; i++) {
          await tester.enterText(field('Add a claim'), 'holder_name');
          await tester.tap(find.byTooltip('Add a claim'));
          await tester.pump();
        }

        expect(find.byType(Switch), findsOneWidget);
        // The duplicate stays typed, so the user sees it was refused.
        expect(
          tester.widget<TextField>(field('Add a claim')).controller!.text,
          'holder_name',
        );
      });

      testWidgets('keeps the suggested claims closed until asked', (
        tester,
      ) async {
        await openEditor(tester);
        // No suggestion for a document of its own.
        expect(find.textContaining('Suggested claims'), findsNothing);

        await tester.tap(find.widgetWithText(ChoiceChip, 'PID'));
        await tester.pump();

        expect(find.textContaining('Suggested claims'), findsOneWidget);
        expect(find.widgetWithText(ActionChip, '+ family_name'), findsNothing);

        await openSuggestions(tester);

        expect(
          find.widgetWithText(ActionChip, '+ family_name'),
          findsOneWidget,
        );
      });

      testWidgets('removes a claim', (tester) async {
        await openEditor(tester);
        await tester.tap(find.widgetWithText(ChoiceChip, 'PID'));
        await tester.pump();
        await openSuggestions(tester);
        await tester.tap(find.widgetWithText(ActionChip, '+ family_name'));
        await tester.pump();
        expect(find.text('family_name'), findsOneWidget);

        await tester.tap(find.byIcon(Icons.close));
        await tester.pump();

        expect(find.text('family_name'), findsNothing);
        expect(find.text('None selected'), findsOneWidget);
        // It is offered again.
        expect(
          find.widgetWithText(ActionChip, '+ family_name'),
          findsOneWidget,
        );
      });

      testWidgets('marks what is missing and saves nothing', (tester) async {
        await openEditor(tester);

        await tester.tap(find.text('SAVE'));
        await tester.pump();

        expect(find.text('Required'), findsNWidgets(3));
        expect(find.text('Choose at least one claim.'), findsOneWidget);
        expect(requests.state.requests, isEmpty);
        expect(find.byType(MdocReaderRequestEditorPage), findsOneWidget);
      });

      testWidgets('asks for several documents in one request', (tester) async {
        await openEditor(tester);

        // Nothing to remove while there is one document.
        expect(find.byIcon(Icons.delete_outline), findsNothing);

        await tester.enterText(field('Name'), 'PID and mDL');
        await tester.tap(find.widgetWithText(ChoiceChip, 'PID'));
        await tester.pump();
        await openSuggestions(tester);
        await tester.tap(find.widgetWithText(ActionChip, '+ family_name'));
        await tester.pump();

        await tester.tap(find.text('ADD A DOCUMENT'));
        await tester.pump();
        expect(find.text('Document 2'), findsOneWidget);

        await tester.tap(find.widgetWithText(ChoiceChip, 'mDL').last);
        await tester.pump();
        await openSuggestions(tester, document: 1);
        await tester.tap(find.widgetWithText(ActionChip, '+ portrait').last);
        await tester.pump();

        await tester.tap(find.text('SAVE'));
        await tester.pumpAndSettle();

        expect(requests.state.requests.single.docTypes, [
          eudiPidDocType,
          'org.iso.18013.5.1.mDL',
        ]);
      });

      testWidgets('removes a document and keeps the others as they are', (
        tester,
      ) async {
        await openEditor(tester);
        await tester.tap(find.widgetWithText(ChoiceChip, 'PID'));
        await tester.pump();
        await tester.tap(find.text('ADD A DOCUMENT'));
        await tester.pump();
        await tester.tap(find.widgetWithText(ChoiceChip, 'mDL').last);
        await tester.pump();

        // Remove the first document: the mDL one moves up.
        await tester.tap(find.byIcon(Icons.delete_outline).first);
        await tester.pump();

        expect(find.text('Document 2'), findsNothing);
        expect(
          tester.widget<TextField>(field('Document type')).controller!.text,
          'org.iso.18013.5.1.mDL',
        );
      });
    });

    group('saved request', () {
      testWidgets('shows its name and claims', (tester) async {
        await openEditor(tester, request: saved, existing: [saved]);

        expect(find.text('Edit request'), findsOneWidget);
        expect(
          tester.widget<TextField>(field('Name')).controller!.text,
          'Names',
        );
        expect(find.text('family_name'), findsOneWidget);
        expect(find.text('given_name'), findsOneWidget);
        expect(
          tester.widget<Switch>(find.byType(Switch).last).value,
          isTrue,
          reason: 'given_name is retained',
        );
      });

      testWidgets('replaces the request when saved', (tester) async {
        await openEditor(tester, request: saved, existing: [saved]);

        await tester.enterText(field('Name'), 'Renamed');
        await openSuggestions(tester);
        await tester.tap(find.widgetWithText(ActionChip, '+ birth_date'));
        await tester.pump();
        await tester.tap(find.text('SAVE'));
        await tester.pumpAndSettle();

        expect(requests.state.requests, [
          const ReaderRequest(
            id: 'saved',
            name: 'Renamed',
            query: {
              eudiPidDocType: {
                eudiPidDocType: {
                  'family_name': false,
                  'given_name': true,
                  'birth_date': false,
                },
              },
            },
          ),
        ]);
      });

      testWidgets('deletes the request once confirmed', (tester) async {
        await openEditor(tester, request: saved, existing: [saved]);

        await tester.tap(find.text('DELETE'));
        await tester.pumpAndSettle();
        expect(find.text('Delete this request?'), findsOneWidget);

        await tester.tap(
          find.descendant(
            of: find.byType(ConfirmDialog),
            matching: find.text('DELETE'),
          ),
        );
        await tester.pumpAndSettle();

        expect(requests.state.requests, isEmpty);
        expect(find.byType(MdocReaderRequestEditorPage), findsNothing);
      });

      testWidgets('keeps the request when the deletion is cancelled', (
        tester,
      ) async {
        await openEditor(tester, request: saved, existing: [saved]);

        await tester.tap(find.text('DELETE'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.descendant(
            of: find.byType(ConfirmDialog),
            matching: find.text('CANCEL'),
          ),
        );
        await tester.pumpAndSettle();

        expect(requests.state.requests, [saved]);
        expect(find.byType(MdocReaderRequestEditorPage), findsOneWidget);
      });
    });
  });
}
