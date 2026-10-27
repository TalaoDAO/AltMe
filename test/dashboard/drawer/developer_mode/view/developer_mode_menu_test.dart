import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/flavor/flavor.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:protocol_trace/protocol_trace.dart';

import '../../../../helpers/helpers.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockFlavorCubit extends MockCubit<FlavorMode> implements FlavorCubit {
  @override
  final state = FlavorMode.development;
}

void main() {
  late _MockProfileCubit profileCubit;
  late _MockFlavorCubit flavorCubit;
  late MockNavigator navigator;

  ProfileState state({
    bool isDeveloperMode = false,
    bool displayDeveloperMode = true,
  }) {
    final model = ProfileModel.empty();
    final setting = model.profileSetting;
    return ProfileState(
      model: model.copyWith(
        isDeveloperMode: isDeveloperMode,
        profileSetting: setting.copyWith(
          settingsMenu: setting.settingsMenu.copyWith(
            displayDeveloperMode: displayDeveloperMode,
          ),
        ),
      ),
    );
  }

  setUp(() {
    profileCubit = _MockProfileCubit();
    flavorCubit = _MockFlavorCubit();
    navigator = MockNavigator();
    when(navigator.canPop).thenReturn(true);
    when(() => navigator.push<void>(any())).thenAnswer((_) async {});
    when(
      () => profileCubit.setDeveloperModeStatus(enabled: any(named: 'enabled')),
    ).thenAnswer((_) async {});
  });

  tearDown(() => ProtocolTrace.current = null);

  Future<void> pumpMenu(WidgetTester tester, ProfileState state) {
    when(() => profileCubit.state).thenReturn(state);
    return tester.pumpApp(
      MockNavigatorProvider(
        navigator: navigator,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            // The drawer logo reads the flavor.
            BlocProvider<FlavorCubit>.value(value: flavorCubit),
          ],
          child: const DeveloperModeMenu(),
        ),
      ),
    );
  }

  Switch developerModeSwitch(WidgetTester tester) =>
      tester.widget<Switch>(find.byKey(const Key('developerMode')));

  group('DeveloperModeMenu', () {
    testWidgets('has the developer mode switch, off by default', (
      tester,
    ) async {
      await pumpMenu(tester, state());

      expect(find.text('Developer Mode'), findsOneWidget);
      expect(developerModeSwitch(tester).value, isFalse);
    });

    testWidgets('shows the switch on when developer mode is active', (
      tester,
    ) async {
      await pumpMenu(tester, state(isDeveloperMode: true));

      expect(developerModeSwitch(tester).value, isTrue);
    });

    testWidgets('switches developer mode on', (tester) async {
      await pumpMenu(tester, state());

      await tester.tap(find.byKey(const Key('developerMode')));
      await tester.pump();

      verify(
        () => profileCubit.setDeveloperModeStatus(enabled: true),
      ).called(1);
    });

    testWidgets('switches developer mode off', (tester) async {
      await pumpMenu(tester, state(isDeveloperMode: true));

      await tester.tap(find.byKey(const Key('developerMode')));
      await tester.pump();

      verify(
        () => profileCubit.setDeveloperModeStatus(enabled: false),
      ).called(1);
    });

    testWidgets('has no switch when the profile hides developer mode', (
      tester,
    ) async {
      await pumpMenu(tester, state(displayDeveloperMode: false));

      expect(find.byKey(const Key('developerMode')), findsNothing);
    });

    testWidgets('has the BLE mode checkboxes in place', (tester) async {
      await pumpMenu(tester, state());

      expect(find.text('Proximity (BLE)'), findsOneWidget);
      expect(find.byType(CheckboxListTile), findsNWidgets(2));
      expect(find.text('Peripheral server'), findsOneWidget);
      expect(find.text('Central client'), findsOneWidget);
    });

    testWidgets('has no protocol trace logs entry when tracing is off', (
      tester,
    ) async {
      await pumpMenu(tester, state());

      expect(find.text('Protocol Trace Logs'), findsNothing);
    });

    testWidgets('opens the protocol trace logs when tracing is on', (
      tester,
    ) async {
      final directory = Directory.systemTemp.createTempSync('trace_menu_test');
      addTearDown(() => directory.deleteSync(recursive: true));
      ProtocolTrace.current = ProtocolTrace(
        directory: directory,
        appName: 'test',
      );
      await pumpMenu(tester, state());

      expect(find.text('Protocol Trace Logs'), findsOneWidget);
      expect(find.text('View and delete recorded trace files'), findsOneWidget);

      await tester.tap(find.text('Protocol Trace Logs'));
      await tester.pump();

      verify(
        () => navigator.push<void>(
          any(that: isRoute<void>(whereName: equals('/ProtocolTraceLogsPage'))),
        ),
      ).called(1);
    });

    testWidgets('keeps the BLE checkboxes and the trace logs without the '
        'switch', (tester) async {
      final directory = Directory.systemTemp.createTempSync('trace_menu_test');
      addTearDown(() => directory.deleteSync(recursive: true));
      ProtocolTrace.current = ProtocolTrace(
        directory: directory,
        appName: 'test',
      );
      await pumpMenu(tester, state(displayDeveloperMode: false));

      expect(find.byKey(const Key('developerMode')), findsNothing);
      expect(find.byType(CheckboxListTile), findsNWidgets(2));
      expect(find.text('Protocol Trace Logs'), findsOneWidget);
    });
  });
}
