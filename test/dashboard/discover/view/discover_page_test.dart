// Runs on its own: golden tests error in the merged run of the whole suite.
@Tags(['skip_very_good_optimization'])
library;

import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/credentials/cubit/credentials_cubit.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:wallet_ui/wallet_ui.dart';

import '../../../helpers/helpers.dart';

class _MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockHomeCubit extends MockCubit<HomeState> implements HomeCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

const _carnet = DiscoverDummyCredential(
  credentialSubjectType: CredentialSubjectType.defaultCredential,
  display: Display(
    name: 'Carnet Jove',
    backgroundColor: '#2446C0',
    textColor: '#FFFFFF',
  ),
  websiteLinkExtern: 'https://example.org/carnet-jove',
  longDescriptionExtern: 'The youth card of the Generalitat Valenciana.',
  whyGetThisCardExtern: 'It gives you discounts on culture and transport.',
  expirationDateDetailsExtern: 'Valid for three years.',
  howToGetItExtern: 'Sign in with your digital certificate.',
);

const _diploma = DiscoverDummyCredential(
  credentialSubjectType: CredentialSubjectType.defaultCredential,
  display: Display(
    name: 'University diploma',
    backgroundColor: '#003399',
    textColor: '#FFFFFF',
  ),
);

void main() {
  late _MockCredentialsCubit credentialsCubit;
  late _MockProfileCubit profileCubit;
  late _MockHomeCubit homeCubit;
  late _MockLangCubit langCubit;
  late _MockQRCodeScanCubit qrCodeScanCubit;

  setUp(() {
    credentialsCubit = _MockCredentialsCubit();
    when(() => credentialsCubit.loadAllCredentials()).thenAnswer((_) async {});
    when(() => credentialsCubit.state).thenReturn(
      const CredentialsState(
        status: CredentialsStatus.populate,
        dummyCredentials: {
          CredentialCategory.identityCards: [_carnet],
          CredentialCategory.educationCards: [_diploma],
          CredentialCategory.othersCards: [],
        },
      ),
    );
    profileCubit = _MockProfileCubit();
    when(
      () => profileCubit.state,
    ).thenReturn(ProfileState(model: ProfileModel.empty()));
    homeCubit = _MockHomeCubit();
    when(
      () => homeCubit.state,
    ).thenReturn(const HomeState(homeStatus: HomeStatus.hasWallet));
    langCubit = _MockLangCubit();
    when(() => langCubit.state).thenReturn(
      const LangState(locale: Locale('en'), languageType: LanguageType.phone),
    );
    qrCodeScanCubit = _MockQRCodeScanCubit();
    when(() => qrCodeScanCubit.state).thenReturn(const QRCodeScanState());
  });

  Future<void> pumpDiscover(
    WidgetTester tester, {
    Widget home = const DiscoverPage(),
    Brightness brightness = Brightness.light,
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      Builder(
        builder: (context) => ColoredBox(
          color: context.walletColors.backgroundAlternative,
          child: home,
        ),
      ),
      brightness: brightness,
      wrapApp: (app) => MultiBlocProvider(
        providers: [
          BlocProvider<CredentialsCubit>.value(value: credentialsCubit),
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<LangCubit>.value(value: langCubit),
          BlocProvider<QRCodeScanCubit>.value(value: qrCodeScanCubit),
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

  group('DiscoverPage', () {
    testWidgets('lists the catalogue by category and skips empty ones', (
      tester,
    ) async {
      await pumpDiscover(tester);

      expect(
        titles(tester),
        unorderedEquals(['Carnet Jove', 'University diploma']),
      );
      expect(find.byType(WalletCredentialList), findsNWidgets(2));
    });

    testWidgets('opens the detail page of a credential', (tester) async {
      await pumpDiscover(tester);

      await tester.tap(find.byType(WalletCredentialContainer).first);
      await tester.pumpAndSettle();

      expect(find.byType(DiscoverDetailsPage), findsOneWidget);
      expect(find.text('Card details'), findsOneWidget);
    });

    testWidgets('asks to create a wallet when there is none', (tester) async {
      when(() => homeCubit.state).thenReturn(const HomeState());
      await pumpDiscover(tester);

      await tester.tap(find.byType(WalletCredentialContainer).first);
      await tester.pumpAndSettle();

      expect(find.byType(WalletDialog), findsOneWidget);
      expect(find.byType(DiscoverDetailsPage), findsNothing);
    });

    for (final brightness in Brightness.values) {
      testWidgets('catalogue golden ${brightness.name}', (tester) async {
        await pumpDiscover(tester, brightness: brightness);

        await expectLater(
          find.byType(DiscoverPage),
          matchesGoldenFile(
            'goldens/discover_catalogue_${brightness.name}.png',
          ),
        );
      });
    }
  });

  group('DiscoverDetailsView', () {
    var calls = 0;

    setUp(() => calls = 0);

    Widget details(DiscoverDummyCredential credential) => DiscoverDetailsView(
      dummyCredential: credential,
      buttonText: 'Get This Card',
      onCallBack: () => calls++,
    );

    testWidgets('shows each detail in its own card', (tester) async {
      await pumpDiscover(tester, home: details(_carnet));

      expect(find.byType(WalletEntityCard), findsOneWidget);
      expect(find.text('Website'), findsOneWidget);
      final cards = tester
          .widgetList<WalletDescriptionCard>(find.byType(WalletDescriptionCard))
          .toList();
      expect(cards.map((card) => card.title), [
        'Carnet Jove',
        'Why get this card',
        'Validity period',
        'How to get it',
      ]);
    });

    testWidgets('omits the cards of the details a credential lacks', (
      tester,
    ) async {
      await pumpDiscover(tester, home: details(_diploma));

      expect(find.byType(WalletEntityCard), findsNothing);
      expect(find.byType(WalletDescriptionCard), findsNothing);
    });

    testWidgets('the button runs the callback', (tester) async {
      await pumpDiscover(tester, home: details(_carnet));

      await tester.tap(find.widgetWithText(WalletButton, 'Get This Card'));

      expect(calls, 1);
    });

    for (final brightness in Brightness.values) {
      testWidgets('golden ${brightness.name}', (tester) async {
        await pumpDiscover(
          tester,
          home: details(_carnet),
          brightness: brightness,
        );

        await expectLater(
          find.byType(DiscoverDetailsView),
          matchesGoldenFile('goldens/discover_detail_${brightness.name}.png'),
        );
      });
    }
  });
}
