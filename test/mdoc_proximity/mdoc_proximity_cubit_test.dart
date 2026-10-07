import 'dart:async';

import 'package:altme/mdoc_proximity/mdoc_proximity.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mdoc_proximity/mdoc_proximity.dart';
import 'package:mocktail/mocktail.dart';

class _MockMdocProximity extends Mock implements MdocProximity {}

void main() {
  late _MockMdocProximity proximity;
  late StreamController<ProximityState> states;

  setUp(() {
    proximity = _MockMdocProximity();
    states = StreamController<ProximityState>.broadcast();
    when(() => proximity.states).thenAnswer((_) => states.stream);
    when(() => proximity.dispose()).thenAnswer((_) async {});
    when(() => proximity.cancel()).thenAnswer((_) async {});
    when(
      () => proximity.start(
        issuerSigned: any(named: 'issuerSigned'),
        keyAlias: any(named: 'keyAlias'),
        engagement: any(named: 'engagement'),
      ),
    ).thenAnswer((_) async {});
  });

  setUpAll(() => registerFallbackValue(ProximityEngagement.qrCode));

  tearDown(() => states.close());

  MdocProximityCubit build({bool bluetoothGranted = true}) =>
      MdocProximityCubit(
        proximity: proximity,
        requestBluetoothPermissions: () async => bluetoothGranted,
      );

  group('MdocProximityCubit', () {
    blocTest<MdocProximityCubit, ProximityState>(
      'starts the session and follows its states',
      build: build,
      act: (cubit) async {
        await cubit.start(issuerSigned: 'is', keyAlias: 'mdoc_1');
        states.add(const ProximityShowQrCode('mdoc:abc'));
      },
      expect: () => const [
        ProximityPreparing(),
        ProximityShowQrCode('mdoc:abc'),
      ],
      verify: (_) => verify(
        () => proximity.start(
          issuerSigned: 'is',
          keyAlias: 'mdoc_1',
          engagement: ProximityEngagement.qrCode,
        ),
      ),
    );

    blocTest<MdocProximityCubit, ProximityState>(
      'does not start without the Bluetooth permissions',
      build: () => build(bluetoothGranted: false),
      act: (cubit) => cubit.start(issuerSigned: 'is', keyAlias: 'mdoc_1'),
      expect: () => const [
        ProximityPreparing(),
        ProximityBluetoothRequired(authorization: true),
      ],
      verify: (_) => verifyNever(
        () => proximity.start(
          issuerSigned: any(named: 'issuerSigned'),
          keyAlias: any(named: 'keyAlias'),
          engagement: any(named: 'engagement'),
        ),
      ),
    );

    blocTest<MdocProximityCubit, ProximityState>(
      'reports a session that cannot start',
      setUp: () => when(
        () => proximity.start(
          issuerSigned: any(named: 'issuerSigned'),
          keyAlias: any(named: 'keyAlias'),
          engagement: any(named: 'engagement'),
        ),
      ).thenThrow(const MdocProximityException('no key')),
      build: build,
      act: (cubit) => cubit.start(issuerSigned: 'is', keyAlias: 'mdoc_1'),
      expect: () => const [
        ProximityPreparing(),
        ProximityFailure(ProximityFailureReason.error, 'no key'),
      ],
    );

    blocTest<MdocProximityCubit, ProximityState>(
      'approve sends the selection',
      setUp: () =>
          when(() => proximity.approve(any())).thenAnswer((_) async {}),
      build: build,
      act: (cubit) => cubit.approve({
        'org.iso.18013.5.1.mDL': {
          'org.iso.18013.5.1': ['age_over_18'],
        },
      }),
      expect: () => const [ProximitySending()],
      verify: (_) => verify(
        () => proximity.approve({
          'org.iso.18013.5.1.mDL': {
            'org.iso.18013.5.1': ['age_over_18'],
          },
        }),
      ),
    );

    blocTest<MdocProximityCubit, ProximityState>(
      'restart cancels and starts again with the new engagement',
      build: build,
      act: (cubit) async {
        await cubit.start(issuerSigned: 'is', keyAlias: 'mdoc_1');
        await cubit.restart(engagement: ProximityEngagement.nfc);
      },
      verify: (cubit) {
        verify(() => proximity.cancel()).called(1);
        verify(
          () => proximity.start(
            issuerSigned: 'is',
            keyAlias: 'mdoc_1',
            engagement: ProximityEngagement.nfc,
          ),
        ).called(1);
        expect(cubit.engagement, ProximityEngagement.nfc);
      },
    );

    test('close disposes the session', () async {
      await build().close();
      verify(() => proximity.dispose()).called(1);
    });
  });
}
