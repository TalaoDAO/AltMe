import 'dart:convert';
import 'dart:io';

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:altme/selective_disclosure/selective_disclosure.dart';
import 'package:altme/theme/app_theme/app_theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCredentialDetailsCubit extends MockCubit<CredentialDetailsState>
    implements CredentialDetailsCubit {}

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockProfileModel extends Mock implements ProfileModel {}

class _FakeProfileState extends Fake implements ProfileState {
  _FakeProfileState(this.model);

  @override
  final ProfileModel model;

  @override
  AppStatus get status => AppStatus.idle;
}

/// A credential of the Pixel 6 test phone, as stored by the wallet, without
/// its network background image.
CredentialModel _fixture(String name) => CredentialModel.fromJson(
  jsonDecode(
        File(
          'test/dashboard/home/tab_bar/credentials/detail/view/fixtures/'
          '$name.json',
        ).readAsStringSync(),
      )
      as Map<String, dynamic>,
);

/// The sandbox mDL, also without its `issuerSigned`.
CredentialModel _mdlWithPortrait() => _fixture('mdl_with_portrait');

/// The Greek demo PID, a `dc+sd-jwt` with the portrait in a disclosure.
CredentialModel _pidSdJwtWithPortrait() => _fixture('pid_sd_jwt_with_portrait');

const _mdlNameSpace = 'org.iso.18013.5.1';

Map<String, dynamic> _displayMap(
  CredentialModel credential, {
  PortraitClaim? hiddenClaim,
}) => SelectiveDisclosureDisplayMap(
  credentialModel: credential,
  isPresentation: false,
  languageCode: 'en',
  limitDisclosure: '',
  filters: const {},
  isDeveloperMode: false,
  displayMode: false,
  selectedClaimsKeyIds: const [],
  hiddenClaim: hiddenClaim,
).buildMap;

void main() {
  late CredentialModel mdl;
  late CredentialModel pid;

  setUpAll(() => registerFallbackValue(_mdlWithPortrait()));

  setUp(() {
    mdl = _mdlWithPortrait();
    pid = _pidSdJwtWithPortrait();
  });

  group('portrait of an mso_mdoc credential', () {
    test('is the first portrait claim with an image', () {
      final portrait = SelectiveDisclosure(mdl).portrait;

      expect(portrait, isNotNull);
      expect(portrait!.key, 'portrait');
      expect(portrait.parentKeyId, _mdlNameSpace);
      expect(portrait.data, startsWith('data:image/jpeg;base64,/9j/'));
    });

    test('is left out of the display map when hidden', () {
      Map<String, dynamic> elements({PortraitClaim? hiddenClaim}) {
        final map = _displayMap(mdl, hiddenClaim: hiddenClaim);
        // The name space, with its elements as value.
        final nameSpace = map.values.single as Map<String, dynamic>;
        return nameSpace['value'] as Map<String, dynamic>;
      }

      expect(elements().keys, contains('Portrait'));

      final hidden = elements(hiddenClaim: SelectiveDisclosure(mdl).portrait);
      expect(hidden.keys, isNot(contains('Portrait')));
      expect(hidden.keys, contains('Portrait Capture Date'));
      expect(hidden.length, elements().length - 1);
    });

    test('is not looked for in an ldp_vc credential', () {
      expect(
        SelectiveDisclosure(mdl.copyWith(format: 'ldp_vc')).portrait,
        isNull,
      );
    });
  });

  group('portrait of a dc+sd-jwt credential', () {
    test('is the top level portrait claim, from its disclosure', () {
      final portrait = SelectiveDisclosure(pid).portrait;

      expect(portrait, isNotNull);
      expect(portrait!.key, 'portrait');
      expect(portrait.parentKeyId, isNull);
      expect(portrait.data, startsWith('data:image/'));
    });

    test('is left out of the display map when hidden', () {
      Iterable<Object?> mapKeys({PortraitClaim? hiddenClaim}) => _displayMap(
        pid,
        hiddenClaim: hiddenClaim,
      ).values.map((claim) => (claim as Map<String, dynamic>)['mapKey']);

      expect(mapKeys(), contains('portrait'));

      final hidden = mapKeys(hiddenClaim: SelectiveDisclosure(pid).portrait);
      expect(hidden, isNot(contains('portrait')));
      expect(hidden, contains('family_name'));
      expect(hidden.length, mapKeys().length - 1);
    });
  });

  group('CredentialsDetailsView', () {
    late _MockCredentialDetailsCubit credentialDetailsCubit;
    late _MockProfileCubit profileCubit;
    late _MockLangCubit langCubit;

    setUp(() {
      credentialDetailsCubit = _MockCredentialDetailsCubit();
      when(() => credentialDetailsCubit.state).thenReturn(
        const CredentialDetailsState(
          status: AppStatus.idle,
          credentialStatus: CredentialStatus.active,
        ),
      );
      when(
        () => credentialDetailsCubit.verifyCredential(any()),
      ).thenAnswer((_) async {});

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
      when(
        () => profileCubit.state,
      ).thenReturn(_FakeProfileState(profileModel));

      langCubit = _MockLangCubit();
      when(() => langCubit.state).thenReturn(
        const LangState(locale: Locale('en'), languageType: LanguageType.phone),
      );
    });

    Future<void> pumpDetails(
      WidgetTester tester,
      CredentialModel credential,
    ) async {
      tester.view
        ..physicalSize = const Size(1080, 2400)
        ..devicePixelRatio = 2.625;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<ProfileCubit>.value(value: profileCubit),
            BlocProvider<LangCubit>.value(value: langCubit),
            BlocProvider<CredentialDetailsCubit>.value(
              value: credentialDetailsCubit,
            ),
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
            home: CredentialsDetailsView(
              credentialModel: credential,
              cardChatSupportCubit: null,
            ),
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

    /// The only image of the page is the portrait, on the card.
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

    testWidgets('shows the mDL portrait on the card, not in the list', (
      tester,
    ) async {
      await pumpDetails(tester, mdl);

      expectPortraitOnCardOnly();
      // Each claim is one SelectableText: title and value.
      expect(find.textContaining('Family Name'), findsOneWidget);
      expect(find.textContaining('Portrait Capture Date'), findsOneWidget);
      expect(
        find.textContaining(RegExp(r'^Portrait\b(?! Capture)')),
        findsNothing,
      );

      await expectLater(
        find.byType(CredentialsDetailsView),
        matchesGoldenFile('goldens/mdl_with_portrait_details.png'),
      );
    });

    testWidgets('shows the SD-JWT PID portrait on the card, not in the list', (
      tester,
    ) async {
      await pumpDetails(tester, pid);

      expectPortraitOnCardOnly();
      expect(find.textContaining('Family Name'), findsOneWidget);

      await expectLater(
        find.byType(CredentialsDetailsView),
        matchesGoldenFile('goldens/pid_sd_jwt_with_portrait_details.png'),
      );
    });
  });
}
