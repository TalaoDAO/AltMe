import 'package:altme/app/app.dart';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:altme/onboarding/onboarding.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

class MockProfileCubit extends MockCubit<ProfileState> implements ProfileCubit {
  @override
  Future<void> setProfileSetting({
    required ProfileSetting profileSetting,
    required ProfileType profileType,
  }) async {}
}

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {
  @override
  final state = FlavorMode.development;
}

void main() {
  group('Starter Page Test', () {
    late FlavorCubit mockFlavorCubit;
    late MockProfileCubit profileCubit;
    late MockNavigator navigator;

    setUpAll(() {
      mockFlavorCubit = MockFlavorCubit();
      profileCubit = MockProfileCubit();
      navigator = MockNavigator();
      when(navigator.canPop).thenReturn(true);

      when(() => navigator.push<void>(any())).thenAnswer((_) async {});

      when(
        () => profileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));

      when(
        () => profileCubit.setWalletType(walletType: WalletType.personal),
      ).thenAnswer((_) async {});

      // when(
      //   () => profileCubit.setProfileSetting(
      //     profileSetting: profileSetting,
      //     profileType: ProfileType.defaultOne,
      //   ),
      // ).thenAnswer((_) async {});
    });

    testWidgets(
      'acctions are performed correctly when Create account is pressed',
      (tester) async {
        await tester.pumpApp(
          MockNavigatorProvider(
            navigator: navigator,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ProfileCubit>.value(value: profileCubit),
                BlocProvider<FlavorCubit>(create: (context) => mockFlavorCubit),
              ],
              child: StarterView(profileCubit: profileCubit),
            ),
          ),
        );

        await tester.tap(find.text('Create account'.toUpperCase()));

        verify(
          () => profileCubit.setWalletType(walletType: WalletType.personal),
        ).called(1);

        // verify(
        //   () => profileCubit.setProfileSetting(
        //     profileSetting: profileSetting,
        //     profileType: ProfileType.defaultOne,
        //   ),
        // ).called(1);

        verify(
          () => navigator.push<void>(
            any(that: isRoute<void>(whereName: equals('/ProtectWalletPage'))),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'acctions are performed correctly when Import account is pressed',
      (tester) async {
        await tester.pumpApp(
          MockNavigatorProvider(
            navigator: navigator,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ProfileCubit>.value(value: profileCubit),
                BlocProvider<FlavorCubit>(create: (context) => mockFlavorCubit),
              ],
              child: StarterView(profileCubit: profileCubit),
            ),
          ),
        );

        await tester.tap(find.text('Import account'.toUpperCase()));

        verify(
          () => profileCubit.setWalletType(walletType: WalletType.personal),
        ).called(1);

        // verify(
        //   () => profileCubit.setProfileSetting(
        //     profileSetting: profileSetting,
        //     profileType: ProfileType.defaultOne,
        //   ),
        // ).called(1);

        verify(
          () => navigator.push<void>(
            any(that: isRoute<void>(whereName: equals('/ProtectWalletPage'))),
          ),
        ).called(1);
      },
    );
  });
}
