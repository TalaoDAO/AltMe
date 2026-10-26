import 'dart:async';
import 'dart:typed_data';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:mocktail/mocktail.dart';
import 'package:platform_p256_keys/platform_p256_keys.dart';

class _MockMdocProximity extends Mock implements MdocProximity {}

class _MockPlatformP256Keys extends Mock implements PlatformP256Keys {}

class _MockCredential extends Mock implements Credential {}

const _pidDocType = 'eu.europa.ec.eudi.pid.1';
const _mdlDocType = 'org.iso.18013.5.1.mDL';

void main() {
  CredentialModel mdoc(String id, String docType, {String? keyId}) =>
      CredentialModel(
        id: id,
        image: '',
        shareLink: '',
        data: {'issuerSigned': 'is-$id', 'docType': docType},
        credentialPreview: _MockCredential(),
        format: 'mso_mdoc',
        keyId: keyId ?? 'key-$id',
      );

  ProximityRequest request(List<String> docTypes) => ProximityRequest([
    for (final docType in docTypes)
      ProximityDocumentRequest(
        docType: docType,
        nameSpaces: const {
          'ns': {'family_name': false},
        },
      ),
  ]);

  late _MockMdocProximity proximity;
  late _MockPlatformP256Keys keys;
  late StreamController<ProximityState> states;
  late List<CredentialModel> credentials;

  setUp(() {
    proximity = _MockMdocProximity();
    keys = _MockPlatformP256Keys();
    states = StreamController<ProximityState>.broadcast();
    credentials = [];
    when(() => proximity.states).thenAnswer((_) => states.stream);
    when(() => proximity.dispose()).thenAnswer((_) async {});
    when(() => proximity.cancel()).thenAnswer((_) async {});
    when(
      () => proximity.start(bleModes: any(named: 'bleModes')),
    ).thenAnswer((_) async {});
    when(() => proximity.approve(any())).thenAnswer((_) async {});
    when(() => proximity.decline()).thenAnswer((_) async {});
    when(() => keys.find(any())).thenAnswer(
      (call) async => PlatformP256Key(
        alias: call.positionalArguments.first as String,
        publicKey: Uint8List(65),
        hardwareBacked: true,
      ),
    );
  });

  tearDown(() => states.close());

  MdocProximityCubit build({
    bool bluetoothGranted = true,
    Set<ProximityBleMode> Function()? bleModes,
  }) => MdocProximityCubit(
    proximity: proximity,
    credentials: () => credentials,
    platformKeys: keys,
    requestBluetoothPermissions: () async => bluetoothGranted,
    bleModes: bleModes ?? ProximityBleMode.values.toSet,
  );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  group('MdocProximityCubit', () {
    blocTest<MdocProximityCubit, MdocProximityState>(
      'starts the session without any mdoc and follows its states',
      build: build,
      act: (cubit) async {
        await cubit.start();
        states.add(const ProximityShowQrCode('mdoc:abc'));
        await settle();
      },
      expect: () => const [
        MdocProximityState(ProximityPreparing()),
        MdocProximityState(ProximityShowQrCode('mdoc:abc')),
      ],
      verify: (_) =>
          verify(() => proximity.start(bleModes: any(named: 'bleModes'))),
    );

    test('starts each session with the BLE modes ticked then', () async {
      var modes = {ProximityBleMode.centralClient};
      final cubit = build(bleModes: () => modes);

      await cubit.start();
      verify(
        () => proximity.start(bleModes: {ProximityBleMode.centralClient}),
      ).called(1);

      modes = {ProximityBleMode.peripheralServer};
      await cubit.restart();
      verify(
        () => proximity.start(bleModes: {ProximityBleMode.peripheralServer}),
      ).called(1);
      await cubit.close();
    });

    test('offers both BLE modes by default', () async {
      final cubit = MdocProximityCubit(
        proximity: proximity,
        credentials: () => credentials,
        platformKeys: keys,
        requestBluetoothPermissions: () async => true,
      );

      await cubit.start();

      verify(
        () => proximity.start(
          bleModes: {
            ProximityBleMode.peripheralServer,
            ProximityBleMode.centralClient,
          },
        ),
      ).called(1);
      await cubit.close();
    });

    blocTest<MdocProximityCubit, MdocProximityState>(
      'does not start without the Bluetooth permissions',
      build: () => build(bluetoothGranted: false),
      act: (cubit) => cubit.start(),
      expect: () => const [
        MdocProximityState(ProximityPreparing()),
        MdocProximityState(ProximityBluetoothRequired(authorization: true)),
      ],
      verify: (_) =>
          verifyNever(() => proximity.start(bleModes: any(named: 'bleModes'))),
    );

    blocTest<MdocProximityCubit, MdocProximityState>(
      'reports a session that cannot start',
      setUp: () => when(
        () => proximity.start(bleModes: any(named: 'bleModes')),
      ).thenThrow(const MdocProximityException('no key')),
      build: build,
      act: (cubit) => cubit.start(),
      expect: () => const [
        MdocProximityState(ProximityPreparing()),
        MdocProximityState(
          ProximityFailure(ProximityFailureReason.error, 'no key'),
        ),
      ],
    );

    blocTest<MdocProximityCubit, MdocProximityState>(
      'restart cancels and starts again',
      build: build,
      act: (cubit) async {
        await cubit.start();
        await cubit.restart();
      },
      verify: (_) {
        verify(() => proximity.cancel()).called(1);
        verify(
          () => proximity.start(bleModes: any(named: 'bleModes')),
        ).called(2);
      },
    );

    test('close disposes the session', () async {
      await build().close();
      verify(() => proximity.dispose()).called(1);
    });
  });

  group('MdocProximityCubit request', () {
    Future<MdocProximityState> requestState(
      MdocProximityCubit cubit,
      List<String> docTypes,
    ) async {
      states.add(request(docTypes));
      await settle();
      return cubit.state;
    }

    test('finds no candidate for a docType the wallet does not hold', () async {
      final cubit = build();
      addTearDown(cubit.close);

      final state = await requestState(cubit, [_mdlDocType]);

      expect(state.session, request([_mdlDocType]));
      expect(state.candidates, {_mdlDocType: isEmpty});
    });

    test('finds the one candidate of the requested type', () async {
      final pid = mdoc('pid', _pidDocType);
      credentials = [pid, mdoc('mdl', _mdlDocType)];
      final cubit = build();
      addTearDown(cubit.close);

      final state = await requestState(cubit, [_pidDocType]);

      expect(state.candidates, {
        _pidDocType: [pid],
      });
    });

    test('finds every candidate when two share a docType', () async {
      final first = mdoc('pid-1', _pidDocType);
      final second = mdoc('pid-2', _pidDocType);
      credentials = [first, second];
      final cubit = build();
      addTearDown(cubit.close);

      final state = await requestState(cubit, [_pidDocType]);

      expect(state.candidates[_pidDocType], [first, second]);
    });

    test('leaves out a candidate whose platform key is gone', () async {
      final kept = mdoc('pid-1', _pidDocType);
      credentials = [mdoc('pid-2', _pidDocType, keyId: 'gone'), kept];
      when(() => keys.find('gone')).thenAnswer((_) async => null);
      final cubit = build();
      addTearDown(cubit.close);

      final state = await requestState(cubit, [_pidDocType]);

      expect(state.candidates[_pidDocType], [kept]);
    });

    test('leaves out an mdoc that cannot be presented in proximity', () async {
      credentials = [
        CredentialModel(
          id: 'no-key',
          image: '',
          shareLink: '',
          data: const {'issuerSigned': 'is', 'docType': _pidDocType},
          credentialPreview: _MockCredential(),
          format: 'mso_mdoc',
        ),
      ];
      final cubit = build();
      addTearDown(cubit.close);

      final state = await requestState(cubit, [_pidDocType]);

      expect(state.candidates[_pidDocType], isEmpty);
    });

    test('finds candidates for two docTypes of one request', () async {
      final pid = mdoc('pid', _pidDocType);
      final mdl = mdoc('mdl', _mdlDocType);
      credentials = [mdl, pid];
      final cubit = build();
      addTearDown(cubit.close);

      final state = await requestState(cubit, [_pidDocType, _mdlDocType]);

      expect(state.candidates, {
        _pidDocType: [pid],
        _mdlDocType: [mdl],
      });
    });

    test('reads the wallet credentials when the request arrives', () async {
      final cubit = build();
      addTearDown(cubit.close);
      final pid = mdoc('pid', _pidDocType);
      credentials = [pid];

      final state = await requestState(cubit, [_pidDocType]);

      expect(state.candidates[_pidDocType], [pid]);
    });
  });

  group('MdocProximityCubit answer', () {
    final disclosure = ProximityDisclosure(
      mdoc: mdoc('pid', _pidDocType).proximityMdoc,
      elements: const {
        'ns': ['family_name'],
      },
    );

    blocTest<MdocProximityCubit, MdocProximityState>(
      'approve sends the disclosures',
      build: build,
      act: (cubit) => cubit.approve([disclosure]),
      expect: () => const <MdocProximityState>[],
      verify: (_) => verify(() => proximity.approve([disclosure])),
    );

    blocTest<MdocProximityCubit, MdocProximityState>(
      'approve reports an mdoc that cannot be signed',
      setUp: () => when(
        () => proximity.approve(any()),
      ).thenThrow(const MdocProximityException('no platform key')),
      build: build,
      act: (cubit) => cubit.approve([disclosure]),
      expect: () => const [
        MdocProximityState(
          ProximityFailure(ProximityFailureReason.error, 'no platform key'),
        ),
      ],
    );

    blocTest<MdocProximityCubit, MdocProximityState>(
      'decline sends the decline, and its end is not a success',
      build: build,
      act: (cubit) async {
        await cubit.decline();
        states.add(const ProximitySuccess());
        await settle();
      },
      expect: () => const <MdocProximityState>[],
      verify: (_) => verify(() => proximity.decline()),
    );

    blocTest<MdocProximityCubit, MdocProximityState>(
      'a success after the decline is not ignored in the next session',
      build: build,
      act: (cubit) async {
        await cubit.decline();
        await cubit.start();
        states.add(const ProximitySuccess());
        await settle();
      },
      expect: () => const [
        MdocProximityState(ProximityPreparing()),
        MdocProximityState(ProximitySuccess()),
      ],
    );

    blocTest<MdocProximityCubit, MdocProximityState>(
      'decline reports a session with no request waiting',
      setUp: () => when(
        () => proximity.decline(),
      ).thenThrow(const MdocProximityException('no request')),
      build: build,
      act: (cubit) => cubit.decline(),
      expect: () => const [
        MdocProximityState(
          ProximityFailure(ProximityFailureReason.error, 'no request'),
        ),
      ],
    );
  });
}
