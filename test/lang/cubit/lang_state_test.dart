import 'dart:ui';

import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/lang/cubit/lang_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LangState', () {
    const locale = Locale('en', 'US');
    const languageType = LanguageType.en;

    test('supports value comparisons', () {
      expect(
        const LangState(locale: locale, languageType: languageType),
        const LangState(locale: locale, languageType: languageType),
      );
    });

    test('copyWith updates locale', () {
      const newLocale = Locale('fr', 'FR');
      expect(
        const LangState(locale: locale, languageType: languageType)
            .copyWith(locale: newLocale),
        const LangState(locale: newLocale, languageType: languageType),
      );
    });

    test('copyWith with no arguments returns the same instance', () {
      const state = LangState(locale: locale, languageType: languageType);
      expect(state.copyWith(), state);
    });
  });
}
