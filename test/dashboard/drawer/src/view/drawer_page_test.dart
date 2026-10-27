import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../../helpers/helpers.dart';

class MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {
  @override
  final state = FlavorMode.development;
}

void main() {
  late MockProfileCubit mockProfileCubit;
  late FlavorCubit mockFlavorCubit;
  late MockNavigator navigator;

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockProfileCubit = MockProfileCubit();
    mockFlavorCubit = MockFlavorCubit();
    navigator = MockNavigator();
    when(navigator.canPop).thenReturn(true);

    when(() => navigator.push<void>(any())).thenAnswer((_) async {});
  });

  group('DrawerPage Tests', () {
    testWidgets('renders DrawerView', (tester) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
            BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
          ],
          child: const DrawerPage(),
        ),
      );

      expect(find.byType(DrawerView), findsOneWidget);
    });

    testWidgets('renders basic UI correctly', (tester) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
            BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
          ],
          child: const DrawerView(),
        ),
      );
      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(DrawerLogo), findsOneWidget);
      expect(find.byType(AppVersionDrawer), findsOneWidget);
    });

    testWidgets(
      'navigates to PickProfileMenu when displayProfile is enabled and '
      '"Wallet Profile" is tapped',
      (tester) async {
        when(
          () => mockProfileCubit.state,
        ).thenReturn(ProfileState(model: ProfileModel.empty()));

        await tester.pumpApp(
          MockNavigatorProvider(
            navigator: navigator,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
                BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
              ],
              child: const DrawerView(),
            ),
          ),
        );

        expect(find.text('Wallet Profile'), findsOneWidget);
        expect(
          find.text('Choose your wallet profile or customize your own'),
          findsOneWidget,
        );

        await tester.tap(find.text('Wallet Profile'));
        await tester.pumpAndSettle();

        verify(
          () => navigator.push<void>(
            any(that: isRoute<void>(whereName: equals('/PickProfileMenu'))),
          ),
        ).called(1);
      },
    );

    testWidgets('navigates to WalletSettingsMenu on tapped', (tester) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: const DrawerView(),
          ),
        ),
      );

      expect(find.text('Wallet Settings'), findsOneWidget);
      expect(find.text('Choose your language and theme'), findsOneWidget);

      await tester.tap(find.text('Wallet Settings'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/WalletSettingsMenu'))),
        ),
      ).called(1);
    });

    testWidgets('when walletHandlesCrypto is true, '
        'navigates to BlockchainSettingsMenu on tapped', (tester) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: const DrawerView(),
          ),
        ),
      );

      if (Parameters.walletHandlesCrypto) {
        expect(find.text('Blockchain Settings'), findsOneWidget);
        expect(
          find.text(
            'Manage accounts, recovery phrase, connected DApps and networks',
          ),
          findsOneWidget,
        );

        await tester.tap(find.text('Blockchain Settings'));
        await tester.pumpAndSettle();

        verify(
          () => navigator.push<void>(
            any(
              that: isRoute<void>(whereName: equals('/BlockchainSettingsMenu')),
            ),
          ),
        ).called(1);
      }
    });

    testWidgets(
      'navigates to DeveloperModeMenu when displayDeveloperMode is enabled '
      'and "Developer Mode" is tapped',
      (tester) async {
        when(
          () => mockProfileCubit.state,
        ).thenReturn(ProfileState(model: ProfileModel.empty()));

        await tester.pumpApp(
          MockNavigatorProvider(
            navigator: navigator,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
                BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
              ],
              child: const DrawerView(),
            ),
          ),
        );

        expect(find.text('Developer Mode'), findsOneWidget);
        expect(
          find.text('Enable developer mode to access advanced debugging tools'),
          findsOneWidget,
        );
        // The switch lives in the menu, not on the root.
        expect(find.byKey(const Key('developerMode')), findsNothing);
        expect(find.text('Protocol Trace Logs'), findsNothing);

        await tester.scrollUntilVisible(find.text('Developer Mode'), 0);

        await tester.tap(find.text('Developer Mode'));
        await tester.pumpAndSettle();

        verify(
          () => navigator.push<void>(
            any(that: isRoute<void>(whereName: equals('/DeveloperModeMenu'))),
          ),
        ).called(1);
      },
    );

    testWidgets('has no Developer Mode entry when the profile hides it', (
      tester,
    ) async {
      final model = ProfileModel.empty();
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(
          model: model.copyWith(
            profileSetting: model.profileSetting.copyWith(
              settingsMenu: model.profileSetting.settingsMenu.copyWith(
                displayDeveloperMode: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
            BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
          ],
          child: const DrawerView(),
        ),
      );

      expect(find.text('Developer Mode'), findsNothing);
    });

    testWidgets('navigates to HelpCenterMenu when displayHelpCenter is enabled '
        'and "helpCenter" is tapped', (tester) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: const DrawerView(),
          ),
        ),
      );

      await tester.scrollUntilVisible(find.text('Help Center'), 0);

      expect(find.text('Help Center'), findsOneWidget);
      expect(
        find.text(
          'Contact us and get support if you need '
          'assistance on using your wallet',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Help Center'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/HelpCenterMenu'))),
        ),
      ).called(1);
    });

    testWidgets('navigates to AboutAltmeMenu when "about" is tapped', (
      tester,
    ) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: const DrawerView(),
          ),
        ),
      );

      expect(find.text('About'), findsOneWidget);
      expect(
        find.text('Read about terms of use, confidentiality and licenses'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(find.text('About'), 0);

      await tester.tap(find.text('About'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/AboutAltmeMenu'))),
        ),
      ).called(1);
    });

    testWidgets('navigates to ResetWalletMenu when "resetWallet" is tapped', (
      tester,
    ) async {
      when(
        () => mockProfileCubit.state,
      ).thenReturn(ProfileState(model: ProfileModel.empty()));

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: const DrawerView(),
          ),
        ),
      );

      expect(find.text('Reset Wallet'), findsOneWidget);
      expect(
        find.text(
          'Erase all data stored on this device and reset your wallet.',
        ),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(find.text('Reset Wallet'), 0);

      await tester.tap(find.text('Reset Wallet'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/ResetWalletMenu'))),
        ),
      ).called(1);
    });
  });
}
