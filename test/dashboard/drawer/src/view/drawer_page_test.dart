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
      when(() => mockProfileCubit.state)
          .thenReturn(ProfileState(model: ProfileModel.empty()));
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
      when(() => mockProfileCubit.state)
          .thenReturn(ProfileState(model: ProfileModel.empty()));
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
            BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
          ],
          child: DrawerView(profileCubit: mockProfileCubit),
        ),
      );
      expect(find.byType(Drawer), findsOneWidget);
      expect(find.byType(DrawerLogo), findsOneWidget);
      expect(find.byType(AppVersionDrawer), findsOneWidget);
    });

    testWidgets(
        'navigates to PickProfileMenu when displayProfile is enabled and '
        '"Wallet Profile" is tapped', (tester) async {
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(model: ProfileModel.empty()),
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: DrawerView(profileCubit: mockProfileCubit),
          ),
        ),
      );

      expect(find.text('Wallet Profiles'), findsOneWidget);
      expect(
        find.text('Choose your SSI profile or customize your own'),
        findsOneWidget,
      );

      await tester.tap(find.text('Wallet Profiles'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/PickProfileMenu'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('navigates to WalletSettingsMenu on tapped', (tester) async {
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(model: ProfileModel.empty()),
      );
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: DrawerView(profileCubit: mockProfileCubit),
          ),
        ),
      );

      expect(find.text('Wallet Settings'), findsOneWidget);
      expect(find.text('Choose your language and theme'), findsOneWidget);

      await tester.tap(find.text('Wallet Settings'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/WalletSettingsMenu'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'when walletHandlesCrypto is true, '
        'navigates to BlockchainSettingsMenu on tapped', (tester) async {
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(model: ProfileModel.empty()),
      );
      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: DrawerView(profileCubit: mockProfileCubit),
          ),
        ),
      );

      if (Parameters.walletHandlesCrypto) {
        expect(find.text('Blockchain Settings'), findsOneWidget);
        expect(
          find.text(
            'Manage accounts, Recovery Phrase, Connected dApps and Networks',
          ),
          findsOneWidget,
        );

        await tester.tap(find.text('Blockchain Settings'));
        await tester.pumpAndSettle();

        verify(
          () => navigator.push<void>(
            any(
              that: isRoute<void>(
                whereName: equals('/BlockchainSettingsMenu'),
              ),
            ),
          ),
        ).called(1);
      }
    });

    testWidgets(
        'navigates to SSIMenu when displaySelfSovereignIdentity is enabled '
        'and "ssi" is tapped', (tester) async {
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(model: ProfileModel.empty()),
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: DrawerView(profileCubit: mockProfileCubit),
          ),
        ),
      );

      expect(find.text('Self-Sovereign Identity (DID)'), findsOneWidget);
      expect(
        find.text(
          'Manage your Decentralized ID and backup or restore your credentials',
        ),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(
        find.text('Self-Sovereign Identity (DID)'),
        0,
      );

      await tester.tap(find.text('Self-Sovereign Identity (DID)'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/ssiMenu'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'setDeveloperModeStatus is called when displayDeveloperMode is enabled '
        'and "developerMode" is tapped', (tester) async {
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(model: ProfileModel.empty()),
      );

      when(
        () => mockProfileCubit.setDeveloperModeStatus(
          enabled: true,
        ),
      ).thenAnswer((_) async => {});

      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
            BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
          ],
          child: DrawerView(profileCubit: mockProfileCubit),
        ),
      );

      expect(find.text('Developer Mode'), findsOneWidget);
      expect(
        find.text('Enable developer mode to access advanced debugging tools'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(find.text('Developer Mode'), 0);

      await tester.tap(find.byKey(const Key('developerMode')));
      await tester.pumpAndSettle();

      verify(
        () => mockProfileCubit.setDeveloperModeStatus(enabled: true),
      ).called(1);
    });

    testWidgets(
        'navigates to HelpCenterMenu when displayHelpCenter is enabled '
        'and "helpCenter" is tapped', (tester) async {
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(model: ProfileModel.empty()),
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: DrawerView(profileCubit: mockProfileCubit),
          ),
        ),
      );

      await tester.scrollUntilVisible(find.text('Help Center'), 0);

      expect(find.text('Help Center'), findsOneWidget);
      expect(
        find.text('Contact us and get support if you need '
            'assistance on using our wallet'),
        findsOneWidget,
      );

      await tester.tap(find.text('Help Center'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/HelpCenterMenu'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('navigates to AboutAltmeMenu when "about" is tapped',
        (tester) async {
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(model: ProfileModel.empty()),
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: DrawerView(profileCubit: mockProfileCubit),
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
          any(
            that: isRoute<void>(
              whereName: equals('/AboutAltmeMenu'),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets('navigates to ResetWalletMenu when "resetWallet" is tapped',
        (tester) async {
      when(() => mockProfileCubit.state).thenReturn(
        ProfileState(model: ProfileModel.empty()),
      );

      await tester.pumpApp(
        MockNavigatorProvider(
          navigator: navigator,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileCubit>.value(value: mockProfileCubit),
              BlocProvider<FlavorCubit>.value(value: mockFlavorCubit),
            ],
            child: DrawerView(profileCubit: mockProfileCubit),
          ),
        ),
      );

      expect(find.text('Reset Wallet'), findsOneWidget);
      expect(
        find.text('Erase all data stored on your phone and reset your wallet.'),
        findsOneWidget,
      );

      await tester.scrollUntilVisible(find.text('Reset Wallet'), 0);

      await tester.tap(find.text('Reset Wallet'));
      await tester.pumpAndSettle();

      verify(
        () => navigator.push<void>(
          any(
            that: isRoute<void>(
              whereName: equals('/ResetWalletMenu'),
            ),
          ),
        ),
      ).called(1);
    });
  });
}
