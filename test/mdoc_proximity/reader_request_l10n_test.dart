import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:altme/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  AppLocalizations of(String language) =>
      lookupAppLocalizations(Locale(language));

  group('reader request strings', () {
    test('count the claims of a request in every language', () {
      const expected = {
        'en': ('1 claim', '2 claims'),
        'fr': ('1 attribut', '2 attributs'),
        'es': ('1 atributo', '2 atributos'),
        'ca': ('1 atribut', '2 atributs'),
        'el': ('1 χαρακτηριστικό', '2 χαρακτηριστικά'),
      };

      for (final MapEntry(key: language, value: (one, other))
          in expected.entries) {
        expect(
          of(language).mdocReaderRequestClaimCount(1),
          one,
          reason: language,
        );
        expect(
          of(language).mdocReaderRequestClaimCount(2),
          other,
          reason: language,
        );
      }
    });

    test('number the documents of a request in every language', () {
      for (final language in ['en', 'fr', 'es', 'ca', 'el']) {
        expect(
          of(language).mdocReaderRequestDocument(2),
          endsWith(' 2'),
          reason: language,
        );
      }
    });

    test('are translated in every language', () {
      // `flutter gen-l10n` lists the keys a language falls back to English on.
      final untranslated =
          jsonDecode(File('lib/l10n/untranslated.json').readAsStringSync())
              as Map<String, dynamic>;

      for (final MapEntry(key: language, value: keys) in untranslated.entries) {
        expect(
          [
            for (final key in (keys as List<dynamic>).cast<String>())
              if (key.startsWith('mdocReaderRequest') ||
                  key == 'mdocReaderMyRequests' ||
                  key == 'mdocReaderAddRequest')
                key,
          ],
          isEmpty,
          reason: language,
        );
      }
    });
  });
}
