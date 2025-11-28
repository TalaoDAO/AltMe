import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  group('GetTranslation', () {
    late AppLocalizations l10n;
    setUp(() {
      l10n = MockAppLocalizations();
    });

    test('returns translation for the locale if available', () {
      final translations = [
        Translation('en', 'Hello'),
        Translation('es', 'Hola'),
      ];
      when(() => l10n.localeName).thenReturn('es');
      final result = GetTranslation.getTranslation(translations, l10n);
      expect(result, 'Hola');
    });

    test('falls back to English if locale translation is not available', () {
      final translations = [
        Translation('en', 'Hello'),
        Translation('es', 'Hola'),
      ];
      when(() => l10n.localeName).thenReturn('fr');
      final result = GetTranslation.getTranslation(translations, l10n);
      expect(result, 'Hello');
    });

    test('returns empty string if no translations are available', () {
      final translations = [Translation('fr', 'Bonjour')];
      when(() => l10n.localeName).thenReturn('es');
      final result = GetTranslation.getTranslation(translations, l10n);
      expect(result, '');
    });

    test('returns empty string if translations list is empty', () {
      final translations = <Translation>[];
      when(() => l10n.localeName).thenReturn('en');
      final result = GetTranslation.getTranslation(translations, l10n);
      expect(result, '');
    });
  });
}
