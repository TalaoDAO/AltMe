import 'package:altme/app/app.dart';
import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/lang/cubit/lang_cubit.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorageProvider extends Mock implements SecureStorageProvider {}

void main() {
  late MockSecureStorageProvider mockSecureStorageProvider;
  late LangCubit langCubit;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
    mockSecureStorageProvider = MockSecureStorageProvider();
    langCubit = LangCubit(secureStorageProvider: mockSecureStorageProvider);
  });

  tearDown(() {
    langCubit.close();
  });

  group('LangCubit', () {
    test(
      'initial state is LangState with Locale(en) and LanguageType.phone',
      () {
        expect(
          langCubit.state,
          const LangState(
            locale: Locale('en'),
            languageType: LanguageType.phone,
          ),
        );
      },
    );

    test('emits new state with recorded language locale', () async {
      when(
        () => mockSecureStorageProvider.get(SecureStorageKeys.language),
      ).thenAnswer((_) async => 'es');
      when(
        () => mockSecureStorageProvider.set(SecureStorageKeys.language, any()),
      ).thenAnswer((_) async {});

      await langCubit.checkLocale();
      expect(
        langCubit.state,
        const LangState(locale: Locale('es'), languageType: LanguageType.es),
      );
    });

    test('returns LanguageType.phone when no recorded language', () async {
      when(
        () => mockSecureStorageProvider.get(SecureStorageKeys.language),
      ).thenAnswer((_) async => null);
      when(
        () => mockSecureStorageProvider.set(SecureStorageKeys.language, any()),
      ).thenAnswer((_) async {});

      final languageType = await langCubit.getRecordedLanguage();
      expect(languageType, LanguageType.phone);
    });

    test('returns recorded language when available', () async {
      when(
        () => mockSecureStorageProvider.get(SecureStorageKeys.language),
      ).thenAnswer((_) async => 'es');

      final languageType = await langCubit.getRecordedLanguage();
      expect(languageType, LanguageType.es);
    });

    test('returns matching LanguageType enum value', () {
      final result = langCubit.getLanguageType('fr', LanguageType.phone);
      expect(result, LanguageType.fr);
    });

    test('returns default LanguageType when no match found', () {
      final result = langCubit.getLanguageType('unknown', LanguageType.phone);
      expect(result, LanguageType.phone);
    });

    test(
      'calls secureStorageProvider.set with correct key and value',
      () async {
        when(
          () =>
              mockSecureStorageProvider.set(SecureStorageKeys.language, any()),
        ).thenAnswer((_) async {});

        await langCubit.recordLanguage('fr');

        verify(
          () => mockSecureStorageProvider.set(SecureStorageKeys.language, 'fr'),
        ).called(1);
      },
    );
  });
}
