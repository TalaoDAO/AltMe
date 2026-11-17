// Runs on its own: golden tests error in the merged run of the whole suite.
@Tags(['skip_very_good_optimization'])
library;

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/wallet/wallet.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:wallet_ui/wallet_ui.dart';

import '../../../../../../helpers/helpers.dart';

class _MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class _MockAdvanceSettingsCubit extends MockCubit<AdvanceSettingsState>
    implements AdvanceSettingsCubit {}

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockWalletCubit extends MockCubit<WalletState> implements WalletCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

void main() {
  late _MockCredentialsCubit credentialsCubit;
  late _MockAdvanceSettingsCubit advanceSettingsCubit;
  late _MockProfileCubit profileCubit;
  late _MockWalletCubit walletCubit;
  late _MockLangCubit langCubit;
  late _MockQRCodeScanCubit qrCodeScanCubit;
  late DashboardCubit dashboardCubit;
  late MockNavigator navigator;

  void withCredentials(List<CredentialModel> credentials) {
    when(() => credentialsCubit.state).thenReturn(
      CredentialsState(
        status: CredentialsStatus.populate,
        credentials: credentials,
      ),
    );
  }

  setUp(() {
    credentialsCubit = _MockCredentialsCubit();
    when(() => credentialsCubit.loadAllCredentials()).thenAnswer((_) async {});
    advanceSettingsCubit = _MockAdvanceSettingsCubit();
    when(() => advanceSettingsCubit.state).thenReturn(
      const AdvanceSettingsState(
        isGamingEnabled: true,
        isIdentityEnabled: true,
        isProfessionalEnabled: true,
        isBlockchainAccountsEnabled: true,
        isEducationEnabled: true,
        isPassEnabled: true,
        isSocialMediaEnabled: true,
        isCommunityEnabled: true,
        isOtherEnabled: true,
        isFinanceEnabled: true,
        isHumanityProofEnabled: true,
        isWalletIntegrityEnabled: true,
      ),
    );
    profileCubit = _MockProfileCubit();
    // Credentials of a format the profile doesn't support are not listed.
    final profile = ProfileModel.empty();
    final setting = profile.profileSetting;
    final options = setting.selfSovereignIdentityOptions;
    when(() => profileCubit.state).thenReturn(
      ProfileState(
        model: profile.copyWith(
          profileSetting: setting.copyWith(
            selfSovereignIdentityOptions: options.copyWith(
              customOidc4vcProfile: options.customOidc4vcProfile.copyWith(
                formatsSupported: [VCFormatType.auto],
              ),
            ),
          ),
        ),
      ),
    );
    walletCubit = _MockWalletCubit();
    when(() => walletCubit.state).thenReturn(const WalletState());
    langCubit = _MockLangCubit();
    when(() => langCubit.state).thenReturn(
      const LangState(locale: Locale('en'), languageType: LanguageType.phone),
    );
    qrCodeScanCubit = _MockQRCodeScanCubit();
    when(() => qrCodeScanCubit.state).thenReturn(const QRCodeScanState());
    dashboardCubit = DashboardCubit();
    addTearDown(dashboardCubit.close);
    navigator = MockNavigator();
    when(navigator.canPop).thenReturn(true);
    when(() => navigator.push<void>(any())).thenAnswer((_) async {});
  });

  Future<void> pumpHome(
    WidgetTester tester, {
    Brightness brightness = Brightness.light,
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      MockNavigatorProvider(
        navigator: navigator,
        child: Builder(
          builder: (context) => ColoredBox(
            color: context.walletColors.backgroundAlternative,
            child: const HomeCredentialsListPage(),
          ),
        ),
      ),
      brightness: brightness,
      wrapApp: (app) => MultiBlocProvider(
        providers: [
          BlocProvider<CredentialsCubit>.value(value: credentialsCubit),
          BlocProvider<AdvanceSettingsCubit>.value(value: advanceSettingsCubit),
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<WalletCubit>.value(value: walletCubit),
          BlocProvider<LangCubit>.value(value: langCubit),
          BlocProvider<QRCodeScanCubit>.value(value: qrCodeScanCubit),
          BlocProvider<DashboardCubit>.value(value: dashboardCubit),
        ],
        child: app,
      ),
    );
    await tester.pumpAndSettle();
  }

  List<String> titles(WidgetTester tester) => tester
      .widgetList<WalletCredentialContainer>(
        find.byType(WalletCredentialContainer),
      )
      .map((container) => container.title)
      .toList();

  group('HomeCredentialsListPage', () {
    group('with credentials', () {
      setUp(
        () => withCredentials([
          loadCredentialFixture('mdl_with_portrait'),
          loadCredentialFixture('pid_sd_jwt_with_portrait'),
        ]),
      );

      testWidgets('lists each credential in a container under its category', (
        tester,
      ) async {
        await pumpHome(tester);

        expect(
          titles(tester),
          unorderedEquals(['Mobile Driving Licence', 'PID']),
        );
        expect(find.byType(WalletCredentialList), findsWidgets);
      });

      testWidgets('opens the credential detail on tap', (tester) async {
        await pumpHome(tester);

        await tester.tap(find.byType(WalletCredentialContainer).first);

        verify(() => navigator.push<void>(any())).called(1);
      });

      for (final brightness in Brightness.values) {
        testWidgets('golden ${brightness.name}', (tester) async {
          await pumpHome(tester, brightness: brightness);

          await expectLater(
            find.byType(HomeCredentialsListPage),
            matchesGoldenFile(
              'goldens/home_with_credentials_${brightness.name}.png',
            ),
          );
        });
      }
    });

    group('without credentials', () {
      setUp(() => withCredentials([]));

      testWidgets('shows the categories that show when empty, with an add '
          'button', (tester) async {
        await pumpHome(tester);

        expect(find.byType(WalletCredentialContainer), findsNothing);
        expect(find.byType(WalletCredentialList), findsWidgets);
        expect(find.text('Add cards'), findsWidgets);
      });

      testWidgets('the add button opens the Discover tab', (tester) async {
        await pumpHome(tester);

        await tester.tap(find.text('Add cards').first);

        expect(dashboardCubit.state.tab, DashboardTab.discover);
      });

      for (final brightness in Brightness.values) {
        testWidgets('golden ${brightness.name}', (tester) async {
          await pumpHome(tester, brightness: brightness);

          await expectLater(
            find.byType(HomeCredentialsListPage),
            matchesGoldenFile('goldens/home_empty_${brightness.name}.png'),
          );
        });
      }
    });

    testWidgets('shows the error view when loading failed', (tester) async {
      when(
        () => credentialsCubit.state,
      ).thenReturn(const CredentialsState(status: CredentialsStatus.error));
      await pumpHome(tester);

      expect(find.byType(ErrorView), findsOneWidget);
    });
  });
}
