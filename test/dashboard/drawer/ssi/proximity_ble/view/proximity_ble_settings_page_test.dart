import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../helpers/helpers.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  late _MockProfileCubit profileCubit;

  ProfileState withModes({
    required bool peripheralServer,
    required bool centralClient,
  }) {
    final model = ProfileModel.empty();
    final setting = model.profileSetting;
    return ProfileState(
      model: model.copyWith(
        profileSetting: setting.copyWith(
          selfSovereignIdentityOptions: setting.selfSovereignIdentityOptions
              .copyWith(
                proximityPeripheralServer: peripheralServer,
                proximityCentralClient: centralClient,
              ),
        ),
      ),
    );
  }

  setUp(() {
    profileCubit = _MockProfileCubit();
    when(
      () => profileCubit.updateProfileSetting(
        proximityPeripheralServer: any(named: 'proximityPeripheralServer'),
        proximityCentralClient: any(named: 'proximityCentralClient'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pumpPage(WidgetTester tester, ProfileState state) {
    when(() => profileCubit.state).thenReturn(state);
    return tester.pumpApp(
      BlocProvider<ProfileCubit>.value(
        value: profileCubit,
        child: const ProximityBleSettingsPage(),
      ),
    );
  }

  CheckboxListTile tile(WidgetTester tester, String title) =>
      tester.widget<CheckboxListTile>(
        find.ancestor(
          of: find.text(title),
          matching: find.byType(CheckboxListTile),
        ),
      );

  group('ProximityBleSettingsPage', () {
    testWidgets('shows both modes ticked by default', (tester) async {
      await pumpPage(tester, ProfileState(model: ProfileModel.empty()));

      expect(tile(tester, 'Peripheral server').value, isTrue);
      expect(tile(tester, 'Central client').value, isTrue);
    });

    testWidgets('unticks a mode while the other stays ticked', (tester) async {
      await pumpPage(tester, ProfileState(model: ProfileModel.empty()));

      await tester.tap(find.text('Central client'));

      verify(
        () => profileCubit.updateProfileSetting(proximityCentralClient: false),
      ).called(1);
    });

    testWidgets('ticks a mode back', (tester) async {
      await pumpPage(
        tester,
        withModes(peripheralServer: false, centralClient: true),
      );

      await tester.tap(find.text('Peripheral server'));

      verify(
        () =>
            profileCubit.updateProfileSetting(proximityPeripheralServer: true),
      ).called(1);
    });

    testWidgets('refuses to untick the last ticked mode', (tester) async {
      await pumpPage(
        tester,
        withModes(peripheralServer: true, centralClient: false),
      );

      expect(tile(tester, 'Peripheral server').onChanged, isNull);
      expect(tile(tester, 'Central client').onChanged, isNotNull);

      await tester.tap(find.text('Peripheral server'));

      verifyNever(
        () => profileCubit.updateProfileSetting(
          proximityPeripheralServer: any(named: 'proximityPeripheralServer'),
        ),
      );
    });
  });
}
