import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';

void main() {
  final pidPreset = readerDocumentPresets.firstWhere(
    (preset) => preset.name == 'PID',
  );
  final mdlPreset = readerDocumentPresets.firstWhere(
    (preset) => preset.name == 'mDL',
  );

  group('ReaderRequestEditorCubit', () {
    test('starts with one empty document for a new request', () {
      final cubit = ReaderRequestEditorCubit();

      expect(cubit.state.name, isEmpty);
      expect(cubit.state.documents, hasLength(1));
      expect(cubit.state.documents.single.claims, isEmpty);
      expect(cubit.state.showErrors, isFalse);
      expect(cubit.id, isNotEmpty);
    });

    test('starts from the request to change, one document per name space', () {
      const request = ReaderRequest(
        id: 'saved',
        name: 'Photo ID',
        query: {
          'org.iso.23220.photoid.1': {
            'org.iso.23220.1': {'family_name': false},
            'org.iso.23220.photoid.1': {'person_id': true},
          },
          eudiPidDocType: {
            eudiPidDocType: {'birth_date': false},
          },
        },
      );

      final cubit = ReaderRequestEditorCubit(initial: request);

      expect(cubit.id, 'saved');
      expect(cubit.state.name, 'Photo ID');
      expect(
        [
          for (final document in cubit.state.documents)
            (document.docType, document.nameSpace),
        ],
        [
          ('org.iso.23220.photoid.1', 'org.iso.23220.1'),
          ('org.iso.23220.photoid.1', 'org.iso.23220.photoid.1'),
          (eudiPidDocType, eudiPidDocType),
        ],
      );
      expect(cubit.state.documents[1].claims, [
        const ReaderClaimDraft('person_id', retain: true),
      ]);
      expect({
        for (final document in cubit.state.documents) document.uid,
      }, hasLength(3));
    });

    test('submit round-trips a request it was started from', () {
      const request = ReaderRequest(
        id: 'saved',
        name: 'Both',
        query: {
          eudiPidDocType: {
            eudiPidDocType: {'family_name': false, 'given_name': true},
          },
          'org.iso.18013.5.1.mDL': {
            'org.iso.18013.5.1': {'portrait': false},
          },
        },
      );

      expect(ReaderRequestEditorCubit(initial: request).submit(), request);
    });

    group('submit', () {
      test('returns null and marks the missing fields when incomplete', () {
        final cubit = ReaderRequestEditorCubit();

        expect(cubit.submit(), isNull);
        expect(cubit.state.showErrors, isTrue);
        expect(cubit.state.isValid, isFalse);
      });

      test('needs a name, a document type, a name space and a claim', () {
        final cubit = ReaderRequestEditorCubit()
          ..setName('My request')
          ..setDocType(0, 'org.example.doc.1')
          ..setNameSpace(0, 'org.example.ns.1');
        expect(cubit.submit(), isNull, reason: 'no claim');

        cubit.addClaim(0, 'color');
        expect(cubit.submit(), isNotNull);

        cubit.setName('   ');
        expect(cubit.submit(), isNull, reason: 'blank name');
      });

      test('trims names and merges documents with the same type', () {
        final cubit = ReaderRequestEditorCubit()
          ..setName('  Mixed  ')
          ..setDocType(0, ' org.example.doc.1 ')
          ..setNameSpace(0, ' org.example.ns.1 ')
          ..addClaim(0, 'color')
          ..addDocument()
          ..setDocType(1, 'org.example.doc.1')
          ..setNameSpace(1, 'org.example.ns.1')
          ..addClaim(1, 'size')
          ..setRetain(1, 'size', retain: true)
          ..addDocument()
          ..setDocType(2, 'org.example.doc.1')
          ..setNameSpace(2, 'org.example.ns.2')
          ..addClaim(2, 'weight');

        final request = cubit.submit();

        expect(request, isNotNull);
        expect(request!.id, cubit.id);
        expect(request.name, 'Mixed');
        expect(request.query, {
          'org.example.doc.1': {
            'org.example.ns.1': {'color': false, 'size': true},
            'org.example.ns.2': {'weight': false},
          },
        });
      });
    });

    group('documents', () {
      test('addDocument appends an empty document with its own uid', () {
        final cubit = ReaderRequestEditorCubit()..addDocument();

        expect(cubit.state.documents, hasLength(2));
        expect(
          cubit.state.documents[0].uid,
          isNot(cubit.state.documents[1].uid),
        );
      });

      test('removeDocument removes it but keeps the last one', () {
        final cubit = ReaderRequestEditorCubit()
          ..setDocType(0, 'first')
          ..addDocument()
          ..setDocType(1, 'second')
          ..removeDocument(0);

        expect(cubit.state.documents.map((d) => d.docType), ['second']);

        cubit.removeDocument(0);

        expect(cubit.state.documents.map((d) => d.docType), ['second']);
      });

      test('a removed document does not give its uid to the next one', () {
        final cubit = ReaderRequestEditorCubit()
          ..addDocument()
          ..removeDocument(1)
          ..addDocument();

        expect(cubit.state.documents.map((d) => d.uid).toSet(), hasLength(2));
      });
    });

    group('presets', () {
      test('applyPreset fills the type and name space', () {
        final cubit = ReaderRequestEditorCubit()..applyPreset(0, mdlPreset);

        final document = cubit.state.documents.single;
        expect(document.docType, 'org.iso.18013.5.1.mDL');
        expect(document.nameSpace, 'org.iso.18013.5.1');
        expect(document.preset, mdlPreset);
      });

      test('applyPreset of another document clears the claims', () {
        final cubit = ReaderRequestEditorCubit()
          ..applyPreset(0, mdlPreset)
          ..addClaim(0, 'portrait')
          ..applyPreset(0, pidPreset);

        expect(cubit.state.documents.single.claims, isEmpty);
        expect(cubit.state.documents.single.preset, pidPreset);
      });

      test('applyPreset of the same document keeps the claims', () {
        final cubit = ReaderRequestEditorCubit()
          ..applyPreset(0, pidPreset)
          ..addClaim(0, 'family_name')
          ..applyPreset(0, pidPreset);

        expect(cubit.state.documents.single.claims, [
          const ReaderClaimDraft('family_name'),
        ]);
      });

      test('typing a preset by hand makes the document that preset', () {
        final cubit = ReaderRequestEditorCubit()
          ..setDocType(0, eudiPidDocType)
          ..setNameSpace(0, eudiPidDocType);

        expect(cubit.state.documents.single.preset, pidPreset);
      });

      test('a document of its own is no preset', () {
        final cubit = ReaderRequestEditorCubit()
          ..setDocType(0, 'org.example.doc.1')
          ..setNameSpace(0, eudiPidDocType);

        expect(cubit.state.documents.single.preset, isNull);
      });
    });

    group('claims', () {
      test('addClaim trims and returns whether it added', () {
        final cubit = ReaderRequestEditorCubit();

        expect(cubit.addClaim(0, '  family_name '), isTrue);
        expect(cubit.addClaim(0, 'family_name'), isFalse);
        expect(cubit.addClaim(0, '   '), isFalse);
        expect(cubit.state.documents.single.claims, [
          const ReaderClaimDraft('family_name'),
        ]);
      });

      test('the same claim can be asked in two documents', () {
        final cubit = ReaderRequestEditorCubit()
          ..addDocument()
          ..addClaim(0, 'family_name');

        expect(cubit.addClaim(1, 'family_name'), isTrue);
      });

      test('removeClaim stops asking for it', () {
        final cubit = ReaderRequestEditorCubit()
          ..addClaim(0, 'family_name')
          ..addClaim(0, 'given_name')
          ..removeClaim(0, 'family_name');

        expect(cubit.state.documents.single.claims, [
          const ReaderClaimDraft('given_name'),
        ]);
      });

      test('setRetain changes only that claim', () {
        final cubit = ReaderRequestEditorCubit()
          ..addClaim(0, 'family_name')
          ..addClaim(0, 'given_name')
          ..setRetain(0, 'given_name', retain: true);

        expect(cubit.state.documents.single.claims, [
          const ReaderClaimDraft('family_name'),
          const ReaderClaimDraft('given_name', retain: true),
        ]);
      });
    });
  });
}
