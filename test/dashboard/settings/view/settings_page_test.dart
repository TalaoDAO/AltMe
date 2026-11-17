// Runs on its own: in the merged run of the whole suite the golden test
// errors ("Invalid image data"), while it passes alone.
@Tags(['skip_very_good_optimization'])
library;

import 'dart:async';

import 'package:altme/app/app.dart';
import 'package:altme/chat_room/chat_room.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/enterprise/cubit/enterprise_cubit.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../../helpers/helpers.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockEnterpriseCubit extends MockCubit<EnterpriseState>
    implements EnterpriseCubit {}

class _MockManageNetworkCubit extends MockCubit<ManageNetworkState>
    implements ManageNetworkCubit {}

class _MockAltmeChatSupportCubit extends MockCubit<ChatRoomState>
    implements AltmeChatSupportCubit {}

class _MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {
  @override
  final state = FlavorMode.development;
}

void main() {
  setUpAll(() => registerFallbackValue(_MockManageNetworkCubit()));

  late _MockProfileCubit profileCubit;
  late _MockEnterpriseCubit enterpriseCubit;
  late _MockManageNetworkCubit manageNetworkCubit;
  late _MockAltmeChatSupportCubit chatCubit;
  late _MockFlavorCubit flavorCubit;
  late MockNavigator navigator;

  ProfileModel profile({
    ProfileType? type,
    bool activityLog = true,
    bool helpCenter = true,
    bool developerMode = true,
    bool profiles = true,
    bool ssi = true,
    bool chatSupport = false,
  }) {
    final model = ProfileModel.empty();
    final setting = model.profileSetting;
    return model.copyWith(
      profileType: type,
      profileSetting: setting.copyWith(
        // An asset: a network logo is not available in tests.
        generalOptions: setting.generalOptions.copyWith(
          companyLogo: ImageStrings.appLogo,
        ),
        settingsMenu: setting.settingsMenu.copyWith(
          displayActivityLog: activityLog,
          displayHelpCenter: helpCenter,
          displayDeveloperMode: developerMode,
          displayProfile: profiles,
          displaySelfSovereignIdentity: ssi,
        ),
        helpCenterOptions: setting.helpCenterOptions.copyWith(
          displayChatSupport: chatSupport,
        ),
      ),
    );
  }

  void withProfile(ProfileModel model) {
    when(() => profileCubit.state).thenReturn(ProfileState(model: model));
  }

  setUp(() {
    profileCubit = _MockProfileCubit();
    enterpriseCubit = _MockEnterpriseCubit();
    manageNetworkCubit = _MockManageNetworkCubit();
    chatCubit = _MockAltmeChatSupportCubit();
    flavorCubit = _MockFlavorCubit();
    navigator = MockNavigator();
    when(navigator.canPop).thenReturn(true);
    when(() => navigator.push<void>(any())).thenAnswer((_) async {});

    withProfile(profile());
    when(() => enterpriseCubit.state).thenReturn(const EnterpriseState());
    when(() => chatCubit.unreadMessageCount).thenReturn(0);
    when(
      () => chatCubit.unreadMessageCountStream,
    ).thenAnswer((_) => const Stream<int>.empty());
  });

  Future<void> pump(WidgetTester tester) => tester.pumpApp(
    MockNavigatorProvider(navigator: navigator, child: const SettingsPage()),
    wrapApp: (app) => MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>.value(value: profileCubit),
        BlocProvider<EnterpriseCubit>.value(value: enterpriseCubit),
        BlocProvider<ManageNetworkCubit>.value(value: manageNetworkCubit),
        BlocProvider<AltmeChatSupportCubit>.value(value: chatCubit),
        BlocProvider<FlavorCubit>.value(value: flavorCubit),
      ],
      child: app,
    ),
  );

  Future<void> tapRow(WidgetTester tester, String title) async {
    await tester.scrollUntilVisible(
      find.text(title),
      100,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text(title));
    await tester.pump();
  }

  group('SettingsPage rows', () {
    final targets = <String, String>{
      'Wallet Security and Backup': '/WalletSecurityMenu',
      'Appearance & language': '/WalletSettingsMenu',
      'Activity Log': '/ActivityLogPage',
      'Help Center': '/HelpCenterMenu',
      'Legal': '/AboutAltmeMenu',
      'Developer Mode': '/DeveloperModeMenu',
      'Advanced settings': '/AdvancedSettingsMenu',
      'Reset Wallet': '/ResetWalletMenu',
    };

    for (final entry in targets.entries) {
      testWidgets('"${entry.key}" opens ${entry.value}', (tester) async {
        await pump(tester);

        await tapRow(tester, entry.key);

        verify(
          () => navigator.push<void>(
            any(that: isRoute<void>(whereName: equals(entry.value))),
          ),
        ).called(1);
      });
    }

    testWidgets(
      'has no drawer and no update row for a non-enterprise profile',
      (tester) async {
        await pump(tester);

        expect(find.byType(Drawer), findsNothing);
        expect(find.text('Update your wallet config now'), findsNothing);
      },
    );

    testWidgets('hides the rows whose flag is off', (tester) async {
      withProfile(
        profile(
          activityLog: false,
          helpCenter: false,
          developerMode: false,
          profiles: false,
          ssi: false,
        ),
      );
      await pump(tester);

      expect(find.text('Activity Log'), findsNothing);
      expect(find.text('Help Center'), findsNothing);
      expect(find.text('Developer Mode'), findsNothing);
      // Nothing is left in Advanced settings (the wallet does not handle
      // crypto on this app).
      expect(
        find.text('Advanced settings'),
        Parameters.walletHandlesCrypto ? findsOneWidget : findsNothing,
      );
      // The rows without a flag stay.
      expect(find.text('Wallet Security and Backup'), findsOneWidget);
    });

    testWidgets('rebuilds the list when the profile is switched', (
      tester,
    ) async {
      final states = StreamController<ProfileState>();
      addTearDown(states.close);
      whenListen(
        profileCubit,
        states.stream,
        initialState: ProfileState(model: profile()),
      );
      await pump(tester);
      expect(find.text('Developer Mode'), findsOneWidget);

      final switched = ProfileState(model: profile(developerMode: false));
      when(() => profileCubit.state).thenReturn(switched);
      states.add(switched);
      await tester.pump();

      expect(find.text('Developer Mode'), findsNothing);
    });
  });

  group('SettingsPage Help centre badge', () {
    testWidgets('shows the unread chat count', (tester) async {
      withProfile(profile(chatSupport: true));
      when(() => chatCubit.unreadMessageCount).thenReturn(3);
      await pump(tester);

      expect(find.byType(Badge), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('shows no badge without unread messages', (tester) async {
      withProfile(profile(chatSupport: true));
      await pump(tester);

      expect(find.byType(Badge), findsNothing);
    });

    testWidgets('shows no badge when chat support is off', (tester) async {
      when(() => chatCubit.unreadMessageCount).thenReturn(3);
      await pump(tester);

      expect(find.byType(Badge), findsNothing);
    });
  });

  group('SettingsPage update config', () {
    setUp(() {
      withProfile(profile(type: ProfileType.enterprise));
      when(
        () => enterpriseCubit.updateTheConfiguration(any()),
      ).thenAnswer((_) async {});
    });

    testWidgets('is shown for an enterprise profile only', (tester) async {
      await pump(tester);

      expect(find.text('Update your wallet config now'), findsOneWidget);
    });

    testWidgets('runs the update in place and shows the loading state', (
      tester,
    ) async {
      final states = StreamController<EnterpriseState>();
      addTearDown(states.close);
      whenListen(
        enterpriseCubit,
        states.stream,
        initialState: const EnterpriseState(),
      );
      await pump(tester);

      await tapRow(tester, 'Update your wallet config now');
      verify(() => enterpriseCubit.updateTheConfiguration(any())).called(1);
      verifyNever(() => navigator.pop<Object?>(any()));

      states.add(const EnterpriseState(status: AppStatus.loading));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // No second update while one runs.
      await tester.tap(find.text('Update your wallet config now'));
      verifyNever(() => enterpriseCubit.updateTheConfiguration(any()));
    });

    testWidgets('shows the success state', (tester) async {
      final states = StreamController<EnterpriseState>();
      addTearDown(states.close);
      whenListen(
        enterpriseCubit,
        states.stream,
        initialState: const EnterpriseState(),
      );
      await pump(tester);
      await tapRow(tester, 'Update your wallet config now');

      states.add(const EnterpriseState(status: AppStatus.success));
      await tester.pump();

      expect(find.text('Successfully updated enterprise account!'), findsOne);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows the error state', (tester) async {
      final states = StreamController<EnterpriseState>();
      addTearDown(states.close);
      whenListen(
        enterpriseCubit,
        states.stream,
        initialState: const EnterpriseState(),
      );
      await pump(tester);
      await tapRow(tester, 'Update your wallet config now');

      states.add(const EnterpriseState(status: AppStatus.error));
      await tester.pump();

      expect(
        find.textContaining('Something went wrong, please try again later'),
        findsOneWidget,
      );
    });

    testWidgets('ignores a result left by an earlier update', (tester) async {
      when(
        () => enterpriseCubit.state,
      ).thenReturn(const EnterpriseState(status: AppStatus.success));
      await pump(tester);

      expect(
        find.text('Successfully updated enterprise account!'),
        findsNothing,
      );
    });
  });

  group('SettingsPage golden', () {
    testWidgets('root', (tester) async {
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpApp(
        const SettingsPage(),
        wrapApp: (app) => MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider<EnterpriseCubit>.value(value: enterpriseCubit),
            BlocProvider<ManageNetworkCubit>.value(value: manageNetworkCubit),
            BlocProvider<AltmeChatSupportCubit>.value(value: chatCubit),
            BlocProvider<FlavorCubit>.value(value: flavorCubit),
          ],
          child: app,
        ),
      );
      await tester.pump();

      await expectLater(
        find.byType(SettingsPage),
        matchesGoldenFile('goldens/settings_root.png'),
      );
    });
  });
}
