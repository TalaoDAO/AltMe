import 'package:altme/app/shared/constants/altme_strings.dart';
import 'package:altme/theme/theme.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:secure_storage/secure_storage.dart';

class MockSecureStorage extends Mock implements SecureStorageProvider {}

void main() {
  late SecureStorageProvider mockSecureStorage;

  setUp(() {
    mockSecureStorage = MockSecureStorage();
  });

  group('ThemeCubit', () {
    test('initial state is correct', () {
      expect(ThemeCubit(mockSecureStorage).state, ThemeMode.light);
    });

    group('setTheme', () {
      test('emits correct theme for null', () async {
        final ThemeCubit themeCubit = ThemeCubit(mockSecureStorage);
        themeCubit.setTheme(null);
        expect(themeCubit.state, ThemeMode.light);
      });

      test('emits correct theme for ThemeMode.Light', () async {
        final ThemeCubit themeCubit = ThemeCubit(mockSecureStorage);
        themeCubit.setTheme(ThemeMode.light);
        expect(themeCubit.state, ThemeMode.light);
      });

      test('emits correct theme for ThemeMode.Dark', () async {
        final ThemeCubit themeCubit = ThemeCubit(mockSecureStorage);
        themeCubit.setTheme(ThemeMode.dark);
        expect(themeCubit.state, ThemeMode.dark);
      });

      test('emits correct theme for ThemeMode.System', () async {
        final ThemeCubit themeCubit = ThemeCubit(mockSecureStorage);
        themeCubit.setTheme(ThemeMode.system);
        expect(themeCubit.state, ThemeMode.system);
      });
    });

    group(
      'theme is set correctly',
      () {
        blocTest<ThemeCubit, ThemeMode>(
          'ThemeMode.Light',
          build: () => ThemeCubit(mockSecureStorage),
          act: (cubit) => cubit.setLightTheme(),
          setUp: () {
            when(
              () =>
                  mockSecureStorage.set(AltMeStrings.theme, AltMeStrings.light),
            ).thenAnswer((_) async {});
          },
          expect: () => <ThemeMode>[ThemeMode.light],
          verify: (_) {
            verify(
              () =>
                  mockSecureStorage.set(AltMeStrings.theme, AltMeStrings.light),
            ).called(1);
          },
        );

        blocTest<ThemeCubit, ThemeMode>(
          'ThemeMode.Dark',
          build: () => ThemeCubit(mockSecureStorage),
          act: (cubit) => cubit.setDarkTheme(),
          setUp: () {
            when(
              () => mockSecureStorage.set(
                AltMeStrings.theme,
                AltMeStrings.dark,
              ),
            ).thenAnswer((_) async {});
          },
          expect: () => <ThemeMode>[ThemeMode.dark],
          verify: (_) {
            verify(
              () => mockSecureStorage.set(
                AltMeStrings.theme,
                AltMeStrings.dark,
              ),
            ).called(1);
          },
        );

        blocTest<ThemeCubit, ThemeMode>(
          'ThemeMode.System',
          build: () => ThemeCubit(mockSecureStorage),
          act: (cubit) => cubit.setSystemTheme(),
          setUp: () {
            when(
              () => mockSecureStorage.set(
                AltMeStrings.theme,
                AltMeStrings.system,
              ),
            ).thenAnswer((_) async {});
          },
          expect: () => <ThemeMode>[ThemeMode.system],
          verify: (_) {
            verify(
              () => mockSecureStorage.set(
                AltMeStrings.theme,
                AltMeStrings.system,
              ),
            ).called(1);
          },
        );
      },
    );

    group('get saved theme', () {
      blocTest<ThemeCubit, ThemeMode>(
        'attempt to get saved theme',
        build: () => ThemeCubit(mockSecureStorage),
        act: (cubit) => cubit.getCurrentTheme(),
        setUp: () {
          when(
            () => mockSecureStorage.get(AltMeStrings.theme),
          ).thenAnswer((_) async => '');
        },
        verify: (_) {
          verify(() => mockSecureStorage.get(AltMeStrings.theme)).called(1);
        },
      );

      blocTest<ThemeCubit, ThemeMode>(
        'emit nothing if theme is empty',
        build: () => ThemeCubit(mockSecureStorage),
        act: (cubit) => cubit.getCurrentTheme(),
        setUp: () {
          when(
            () => mockSecureStorage.get(AltMeStrings.theme),
          ).thenAnswer((_) async => '');
        },
        expect: () => <ThemeMode>[],
      );

      blocTest<ThemeCubit, ThemeMode>(
        'emit [Theme.light] if light is returned',
        build: () => ThemeCubit(mockSecureStorage),
        act: (cubit) => cubit.getCurrentTheme(),
        setUp: () {
          when(
            () => mockSecureStorage.get(AltMeStrings.theme),
          ).thenAnswer(
            (_) async => AltMeStrings.light,
          );
        },
        expect: () => <ThemeMode>[ThemeMode.light],
      );

      blocTest<ThemeCubit, ThemeMode>(
        'emit [Theme.dark] if dark is returned',
        build: () => ThemeCubit(mockSecureStorage),
        act: (cubit) => cubit.getCurrentTheme(),
        setUp: () {
          when(
            () => mockSecureStorage.get(AltMeStrings.theme),
          ).thenAnswer(
            (_) async => AltMeStrings.dark,
          );
        },
        expect: () => <ThemeMode>[ThemeMode.dark],
      );

      blocTest<ThemeCubit, ThemeMode>(
        'emit [Theme.system] if system is returned',
        build: () => ThemeCubit(mockSecureStorage),
        act: (cubit) => cubit.getCurrentTheme(),
        setUp: () {
          when(
            () => mockSecureStorage.get(AltMeStrings.theme),
          ).thenAnswer(
            (_) async => AltMeStrings.system,
          );
        },
        expect: () => <ThemeMode>[ThemeMode.system],
      );

      blocTest<ThemeCubit, ThemeMode>(
        'emit [Theme.light] if random app_theme is returned',
        build: () => ThemeCubit(mockSecureStorage),
        act: (cubit) => cubit.getCurrentTheme(),
        setUp: () {
          when(
            () => mockSecureStorage.get(AltMeStrings.theme),
          ).thenAnswer((_) async => 'sdf');
        },
        expect: () => <ThemeMode>[ThemeMode.light],
      );
    });
  });
}
