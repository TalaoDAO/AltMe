import 'dart:async';

import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:mocktail/mocktail.dart';

class _MockMdocReader extends Mock implements MdocReader {}

void main() {
  late _MockMdocReader reader;
  late StreamController<ReaderState> states;

  const result = ReaderResult(
    documents: [
      ReaderDocument(
        docType: 'org.iso.18013.5.1.mDL',
        nameSpaces: {
          'org.iso.18013.5.1': {'given_name': 'ALICE'},
        },
      ),
    ],
  );

  const query = {
    eudiPidDocType: {
      eudiPidDocType: {'family_name': false},
    },
  };

  setUp(() {
    reader = _MockMdocReader();
    states = StreamController<ReaderState>.broadcast();
    when(() => reader.states).thenAnswer((_) => states.stream);
    when(() => reader.dispose()).thenAnswer((_) async {});
    when(() => reader.cancel()).thenAnswer((_) async {});
    when(
      () => reader.start(
        qrUri: any(named: 'qrUri'),
        query: any(named: 'query'),
        trustedRoots: any(named: 'trustedRoots'),
      ),
    ).thenAnswer((_) async {});
  });

  tearDown(() => states.close());

  MdocReaderCubit build({bool bluetoothGranted = true}) => MdocReaderCubit(
    reader: reader,
    qrUri: 'mdoc:abc',
    query: query,
    trustedRoots: const ['PEM'],
    requestBluetoothPermissions: () async => bluetoothGranted,
  );

  void verifyStarted() => verify(
    () => reader.start(
      qrUri: 'mdoc:abc',
      query: query,
      trustedRoots: const ['PEM'],
    ),
  ).called(1);

  group('MdocReaderCubit', () {
    blocTest<MdocReaderCubit, ReaderState>(
      'reads from the scanned engagement and follows the session',
      build: build,
      act: (cubit) async {
        await cubit.start();
        states
          ..add(const ReaderWaitingForResponse())
          ..add(const ReaderSuccess(result));
      },
      expect: () => const [
        ReaderConnecting(),
        ReaderWaitingForResponse(),
        ReaderSuccess(result),
      ],
      verify: (_) => verifyStarted(),
    );

    blocTest<MdocReaderCubit, ReaderState>(
      'asks for Bluetooth when the permissions are refused',
      build: () => build(bluetoothGranted: false),
      act: (cubit) => cubit.start(),
      expect: () => const [
        ReaderConnecting(),
        ReaderBluetoothRequired(authorization: true),
      ],
      verify: (_) => verifyNever(
        () => reader.start(
          qrUri: any(named: 'qrUri'),
          query: any(named: 'query'),
          trustedRoots: any(named: 'trustedRoots'),
        ),
      ),
    );

    blocTest<MdocReaderCubit, ReaderState>(
      'fails with the platform message',
      setUp: () => when(
        () => reader.start(
          qrUri: any(named: 'qrUri'),
          query: any(named: 'query'),
          trustedRoots: any(named: 'trustedRoots'),
        ),
      ).thenThrow(PlatformException(code: 'x', message: 'no BLE')),
      build: build,
      act: (cubit) => cubit.start(),
      expect: () => const [ReaderConnecting(), ReaderFailure('no BLE')],
    );

    blocTest<MdocReaderCubit, ReaderState>(
      'cancels the previous session on retry',
      build: build,
      seed: () => const ReaderFailure('timeout'),
      act: (cubit) => cubit.start(),
      expect: () => const [ReaderConnecting()],
      verify: (_) {
        verify(() => reader.cancel()).called(1);
        verifyStarted();
      },
    );

    test('disposes the reader on close', () async {
      await build().close();
      verify(() => reader.dispose()).called(1);
    });
  });
}
