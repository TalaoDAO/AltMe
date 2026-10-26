import 'dart:convert';

import 'package:altme/app/app.dart';
import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class _MockSecureStorage extends Mock implements SecureStorageProvider {}

void main() {
  const pid = ReaderRequest(
    id: 'pid',
    name: 'PID names',
    query: {
      eudiPidDocType: {
        eudiPidDocType: {'family_name': false, 'given_name': true},
      },
    },
  );
  const mdl = ReaderRequest(
    id: 'mdl',
    name: 'mDL',
    query: {
      'org.iso.18013.5.1.mDL': {
        'org.iso.18013.5.1': {'portrait': false},
      },
    },
  );

  late _MockSecureStorage storage;
  late Map<String, String> stored;

  CustomReaderRequestsCubit build() =>
      CustomReaderRequestsCubit(secureStorage: storage);

  List<dynamic> storedRequests() =>
      jsonDecode(stored[SecureStorageKeys.customReaderRequests]!)
          as List<dynamic>;

  setUp(() {
    storage = _MockSecureStorage();
    stored = {};
    when(() => storage.get(any())).thenAnswer((i) async {
      return stored[i.positionalArguments.first as String];
    });
    when(() => storage.set(any(), any())).thenAnswer((i) async {
      stored[i.positionalArguments[0] as String] =
          i.positionalArguments[1] as String;
    });
  });

  group('CustomReaderRequestsCubit', () {
    test('starts without requests when nothing was saved', () async {
      final cubit = build();
      await cubit.loaded;

      expect(cubit.state.requests, isEmpty);
    });

    test('loads the saved requests', () async {
      stored[SecureStorageKeys.customReaderRequests] = jsonEncode([
        pid.toJson(),
        mdl.toJson(),
      ]);

      final cubit = build();
      await cubit.loaded;

      expect(cubit.state.requests, [pid, mdl]);
    });

    test('drops a saved request of the wrong shape', () async {
      stored[SecureStorageKeys.customReaderRequests] = jsonEncode([
        {'id': 'broken'},
        pid.toJson(),
      ]);

      final cubit = build();
      await cubit.loaded;

      expect(cubit.state.requests, [pid]);
    });

    test('starts empty when the saved value is not a list', () async {
      stored[SecureStorageKeys.customReaderRequests] = 'not json';

      final cubit = build();
      await cubit.loaded;

      expect(cubit.state.requests, isEmpty);
    });

    test('save adds a request and stores it', () async {
      final cubit = build();

      await cubit.save(pid);
      await cubit.save(mdl);

      expect(cubit.state.requests, [pid, mdl]);
      expect(storedRequests(), [pid.toJson(), mdl.toJson()]);
    });

    test('save replaces the request with the same id in place', () async {
      final cubit = build();
      await cubit.save(pid);
      await cubit.save(mdl);

      const renamed = ReaderRequest(
        id: 'pid',
        name: 'Renamed',
        query: {
          eudiPidDocType: {
            eudiPidDocType: {'birth_date': false},
          },
        },
      );
      await cubit.save(renamed);

      expect(cubit.state.requests, [renamed, mdl]);
      expect(storedRequests(), [renamed.toJson(), mdl.toJson()]);
    });

    test('save keeps the requests that were stored before it', () async {
      stored[SecureStorageKeys.customReaderRequests] = jsonEncode([
        pid.toJson(),
      ]);

      final cubit = build();
      await cubit.save(mdl);

      expect(cubit.state.requests, [pid, mdl]);
    });

    test('delete removes the request and stores the rest', () async {
      final cubit = build();
      await cubit.save(pid);
      await cubit.save(mdl);

      await cubit.delete('pid');

      expect(cubit.state.requests, [mdl]);
      expect(storedRequests(), [mdl.toJson()]);
    });

    test('delete of an unknown id changes nothing', () async {
      final cubit = build();
      await cubit.save(pid);

      await cubit.delete('unknown');

      expect(cubit.state.requests, [pid]);
    });
  });
}
