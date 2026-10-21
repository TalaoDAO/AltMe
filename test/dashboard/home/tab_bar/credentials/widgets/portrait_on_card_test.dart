import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/oidc4vc/model/credential_acceptance_data.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class _MockProfileModel extends Mock implements ProfileModel {}

class _FakeProfileState extends Fake implements ProfileState {
  _FakeProfileState(this.model);

  @override
  final ProfileModel model;

  @override
  AppStatus get status => AppStatus.idle;
}

/// The credentials of the credential details tests, with a portrait.
CredentialModel _fixture(String name) => CredentialModel.fromJson(
  jsonDecode(
        File(
          'test/dashboard/home/tab_bar/credentials/detail/view/fixtures/'
          '$name.json',
        ).readAsStringSync(),
      )
      as Map<String, dynamic>,
);

void main() {
  late CredentialModel mdl;
  late CredentialModel pid;
  late _MockProfileCubit profileCubit;
  late _MockLangCubit langCubit;
  late _MockQRCodeScanCubit qrCodeScanCubit;

  setUp(() {
    mdl = _fixture('mdl_with_portrait');
    pid = _fixture('pid_sd_jwt_with_portrait');

    final profileModel = _MockProfileModel();
    when(() => profileModel.profileSetting).thenReturn(
      ProfileSetting(
        walletSecurityOptions: WalletSecurityOptions.initial(),
        selfSovereignIdentityOptions: SelfSovereignIdentityOptions.initial(),
        generalOptions: GeneralOptions.empty(),
        helpCenterOptions: HelpCenterOptions.initial(),
        settingsMenu: SettingsMenu.initial(),
        version: '1.0.0',
      ),
    );
    when(() => profileModel.isDeveloperMode).thenReturn(false);
    when(() => profileModel.profileType).thenReturn(ProfileType.defaultOne);
    profileCubit = _MockProfileCubit();
    when(() => profileCubit.state).thenReturn(_FakeProfileState(profileModel));

    langCubit = _MockLangCubit();
    when(() => langCubit.state).thenReturn(
      const LangState(locale: Locale('en'), languageType: LanguageType.phone),
    );

    qrCodeScanCubit = _MockQRCodeScanCubit();
    when(() => qrCodeScanCubit.state).thenReturn(const QRCodeScanState());
  });

  Future<void> pumpHome(WidgetTester tester, Widget home) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<LangCubit>.value(value: langCubit),
          BlocProvider<QRCodeScanCubit>.value(value: qrCodeScanCubit),
        ],
        child: MaterialApp(
          theme: AppTheme.seedThemeData(Brightness.dark, null),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: home,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Images decode outside the fake async zone of widget tests.
    await tester.runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        await precacheImage((element.widget as Image).image, element);
      }
    });
    await tester.pumpAndSettle();
  }

  Widget inList(Widget child) => Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: child,
    ),
  );

  /// The only image is the portrait, on the card.
  void expectPortraitOnCardOnly() {
    expect(find.byType(Image), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(DefaultCardBody),
        matching: find.byType(Image),
      ),
      findsOneWidget,
    );
  }

  group('credentials list', () {
    testWidgets('shows the mDL portrait on the card', (tester) async {
      await pumpHome(
        tester,
        inList(
          CredentialsDisplayItem(
            credentialModel: mdl,
            onTap: () {},
            isDiscover: false,
          ),
        ),
      );

      expectPortraitOnCardOnly();
    });

    testWidgets('shows the SD-JWT PID portrait on the card', (tester) async {
      await pumpHome(
        tester,
        inList(
          CredentialsDisplayItem(
            credentialModel: pid,
            onTap: () {},
            isDiscover: false,
          ),
        ),
      );

      expectPortraitOnCardOnly();
      await expectLater(
        find.byType(CredentialsDisplayItem),
        matchesGoldenFile('goldens/pid_sd_jwt_with_portrait_list_card.png'),
      );
    });

    testWidgets('shows the portrait on the card of a selectable credential', (
      tester,
    ) async {
      await pumpHome(
        tester,
        inList(
          CredentialsDisplayItem(
            credentialModel: pid,
            onTap: () {},
            isDiscover: false,
            selected: false,
          ),
        ),
      );

      expectPortraitOnCardOnly();
    });
  });

  group('CredentialDisplay in a list', () {
    Future<void> pumpListCard(WidgetTester tester, {required bool show}) =>
        pumpHome(
          tester,
          inList(
            CredentialDisplay(
              credentialModel: mdl,
              credDisplayType: CredDisplayType.List,
              profileSetting: profileCubit.state.model.profileSetting,
              isDiscover: false,
              showPortrait: show,
            ),
          ),
        );

    testWidgets('shows the portrait when asked to', (tester) async {
      await pumpListCard(tester, show: true);

      expectPortraitOnCardOnly();
    });

    testWidgets('does not show the portrait by default', (tester) async {
      await pumpListCard(tester, show: false);

      expect(find.byType(Image), findsNothing);
    });
  });

  group('Oidc4vcCredentialPickView', () {
    testWidgets('shows the mDL portrait on the card, not in the claims', (
      tester,
    ) async {
      await pumpHome(
        tester,
        BlocProvider(
          create: (_) => Oidc4vcCredentialPickCubit(),
          child: Oidc4vcCredentialPickView(
            items: [
              CredentialAcceptanceItem(
                credentialDisplayName: 'mDL',
                claims: const [],
                credentialModel: mdl,
              ),
            ],
            issuerName: 'Issuer',
            isTrusted: true,
            uri: Uri.parse('openid-credential-offer://'),
            oidc4vcParameters: Oidc4vcParameters(
              oidc4vciDraftType: OIDC4VCIDraftType.final1,
              useOAuthAuthorizationServerLink: false,
              initialUri: Uri(),
              userPinRequired: false,
              issuerState: null,
              issuer: 'https://issuer.example',
            ),
          ),
        ),
      );

      expectPortraitOnCardOnly();
      expect(find.textContaining('Family Name'), findsOneWidget);
      expect(find.textContaining('Portrait Capture Date'), findsOneWidget);
      expect(
        find.textContaining(RegExp(r'^Portrait\b(?! Capture)')),
        findsNothing,
      );
    });
  });
}
