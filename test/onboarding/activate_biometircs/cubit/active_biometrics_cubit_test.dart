import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/onboarding/onboarding.dart';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

void main() {
  group('ActiveBiometricsCubit', () {
    late ActiveBiometricsCubit activeBiometricsCubit;
    late MockProfileCubit mockProfileCubit;

    setUp(() {
      mockProfileCubit = MockProfileCubit();

      activeBiometricsCubit =
          ActiveBiometricsCubit(profileCubit: mockProfileCubit);
    });

    test('initial state is false', () {
      expect(activeBiometricsCubit.state, false);
    });

    blocTest<ActiveBiometricsCubit, bool>(
      'load emits true if walletProtectionType is FA2 or biometrics',
      build: () {
        when(() => mockProfileCubit.state).thenReturn(
          ProfileState(
            model: ProfileModel(
              walletType: WalletType.personal,
              walletProtectionType: WalletProtectionType.biometrics,
              isDeveloperMode: false,
              profileType: ProfileType.custom,
              profileSetting: ProfileSetting.initial(),
            ),
          ),
        );
        return activeBiometricsCubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [true],
    );

    blocTest<ActiveBiometricsCubit, bool>(
      'load emits false if walletProtectionType is not FA2 or biometrics',
      build: () {
        when(() => mockProfileCubit.state).thenReturn(
          ProfileState(
            model: ProfileModel(
              walletType: WalletType.personal,
              walletProtectionType: WalletProtectionType.pinCode,
              isDeveloperMode: false,
              profileType: ProfileType.custom,
              profileSetting: ProfileSetting.initial(),
            ),
          ),
        );
        return activeBiometricsCubit;
      },
      act: (cubit) => cubit.load(),
      expect: () => [false],
    );

    blocTest<ActiveBiometricsCubit, bool>(
      'updateSwitch emits the provided value',
      build: () => activeBiometricsCubit,
      act: (cubit) => cubit.updateSwitch(value: true),
      expect: () => [true],
    );
  });
}
