// Runs on its own: golden tests error in the merged run of the whole suite.
@Tags(['skip_very_good_optimization'])
library;

import 'dart:async';

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
import 'package:secure_storage/secure_storage.dart';
import 'package:wallet_ui/wallet_ui.dart';

import '../../../helpers/helpers.dart';

class _MockCredentialsRepository extends Mock
    implements CredentialsRepository {}

class _MockSecureStorageProvider extends Mock
    implements SecureStorageProvider {}

class _MockProfileCubit extends MockCubit<ProfileState>
    implements ProfileCubit {}

class _MockLangCubit extends MockCubit<LangState> implements LangCubit {}

class _MockQRCodeScanCubit extends MockCubit<QRCodeScanState>
    implements QRCodeScanCubit {}

class _MockCredentialsCubit extends MockCubit<CredentialsState>
    implements CredentialsCubit {}

void main() {
  late _MockCredentialsRepository repository;
  late _MockSecureStorageProvider secureStorage;
  late _MockProfileCubit profileCubit;
  late _MockLangCubit langCubit;
  late _MockQRCodeScanCubit qrCodeScanCubit;
  late _MockCredentialsCubit credentialsCubit;
  late List<CredentialModel> credentials;

  setUp(() {
    credentials = [
      loadCredentialFixture('mdl_with_portrait'),
      loadCredentialFixture('pid_sd_jwt_with_portrait'),
    ];
    repository = _MockCredentialsRepository();
    when(() => repository.findAll()).thenAnswer((_) async => credentials);
    secureStorage = _MockSecureStorageProvider();
    when(
      () => secureStorage.get(SecureStorageKeys.ssiKey),
    ).thenAnswer((_) async => 'key');

    profileCubit = _MockProfileCubit();
    when(
      () => profileCubit.state,
    ).thenReturn(ProfileState(model: ProfileModel.empty()));
    langCubit = _MockLangCubit();
    when(() => langCubit.state).thenReturn(
      const LangState(locale: Locale('en'), languageType: LanguageType.phone),
    );
    qrCodeScanCubit = _MockQRCodeScanCubit();
    when(() => qrCodeScanCubit.state).thenReturn(const QRCodeScanState());
    credentialsCubit = _MockCredentialsCubit();
    when(() => credentialsCubit.state).thenReturn(const CredentialsState());
  });

  Future<SearchCubit> pumpSearch(
    WidgetTester tester, {
    Brightness brightness = Brightness.light,
    bool settle = true,
  }) async {
    tester.view
      ..physicalSize = const Size(1080, 2400)
      ..devicePixelRatio = 2.625;
    addTearDown(tester.view.reset);

    final cubit = SearchCubit(
      repository: repository,
      secureStorageProvider: secureStorage,
    );
    addTearDown(cubit.close);
    await tester.pumpApp(
      const SearchView(),
      brightness: brightness,
      wrapApp: (app) => MultiBlocProvider(
        providers: [
          BlocProvider<SearchCubit>.value(value: cubit),
          BlocProvider<ProfileCubit>.value(value: profileCubit),
          BlocProvider<LangCubit>.value(value: langCubit),
          BlocProvider<QRCodeScanCubit>.value(value: qrCodeScanCubit),
          BlocProvider<CredentialsCubit>.value(value: credentialsCubit),
        ],
        child: app,
      ),
    );
    if (settle) {
      await tester.pumpAndSettle();
    } else {
      await tester.pump();
    }
    return cubit;
  }

  /// The titles of the credential containers, in order. A card image draws its
  /// own text, so the title can be found twice.
  List<String> titles(WidgetTester tester) => tester
      .widgetList<WalletCredentialContainer>(
        find.byType(WalletCredentialContainer),
      )
      .map((container) => container.title)
      .toList();

  Future<void> type(WidgetTester tester, String text) async {
    await tester.enterText(find.byType(TextField), text);
    await tester.pumpAndSettle();
  }

  group('SearchView', () {
    testWidgets('lists every credential before anything is typed', (
      tester,
    ) async {
      await pumpSearch(tester);

      expect(titles(tester), ['Mobile Driving Licence', 'PID']);
      expect(find.byType(SearchEmptyView), findsNothing);
      expect(find.byTooltip('Clear search'), findsNothing);
    });

    testWidgets('goes from typing to results to empty and back', (
      tester,
    ) async {
      await pumpSearch(tester);

      await type(tester, 'licence');
      expect(titles(tester), ['Mobile Driving Licence']);
      expect(find.byType(SearchEmptyView), findsNothing);

      await type(tester, 'nothing like this');
      expect(find.byType(SearchEmptyView), findsOneWidget);
      expect(find.text('No results'), findsOneWidget);
      expect(
        find.text(
          'Nothing in your wallet matches “nothing like this”. '
          'Try another word.',
        ),
        findsOneWidget,
      );
      expect(titles(tester), isEmpty);

      await tester.tap(find.byTooltip('Clear search'));
      await tester.pumpAndSettle();
      expect(find.byType(SearchEmptyView), findsNothing);
      expect(titles(tester), ['Mobile Driving Licence', 'PID']);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty,
      );
    });

    testWidgets('shows the shimmer while loading', (tester) async {
      final completer = Completer<List<CredentialModel>>();
      when(() => repository.findAll()).thenAnswer((_) => completer.future);
      await pumpSearch(tester, settle: false);

      expect(find.byType(SearchListShimmer), findsOneWidget);
      completer.complete(credentials);
      await tester.pumpAndSettle();
      expect(find.byType(SearchListShimmer), findsNothing);
      expect(titles(tester), ['Mobile Driving Licence', 'PID']);
    });

    group('goldens', () {
      testWidgets('default', (tester) async {
        await pumpSearch(tester);

        await expectLater(
          find.byType(SearchView),
          matchesGoldenFile('goldens/search_default.png'),
        );
      });

      testWidgets('typing', (tester) async {
        await pumpSearch(tester);
        await tester.tap(find.byType(TextField));
        await tester.enterText(find.byType(TextField), 'lic');
        await tester.pump();

        await expectLater(
          find.byType(SearchView),
          matchesGoldenFile('goldens/search_typing.png'),
        );
      });

      for (final brightness in Brightness.values) {
        testWidgets('results ${brightness.name}', (tester) async {
          await pumpSearch(tester, brightness: brightness);
          await type(tester, 'licence');

          await expectLater(
            find.byType(SearchView),
            matchesGoldenFile('goldens/search_results_${brightness.name}.png'),
          );
        });
      }

      testWidgets('empty', (tester) async {
        await pumpSearch(tester);
        await type(tester, 'xylophone');

        await expectLater(
          find.byType(SearchView),
          matchesGoldenFile('goldens/search_empty.png'),
        );
      });
    });
  });
}
