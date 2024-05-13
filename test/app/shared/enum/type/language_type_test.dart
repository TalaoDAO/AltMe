import 'package:altme/app/shared/enum/type/language_type.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAppLocalizations extends Mock implements AppLocalizations {
  @override
  String get phoneLanguage => 'Phone';

  @override
  String get catalan => 'Catalan';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get french => 'French';
}

void main() {
  group('LanguageType Extension Tests', () {
    test('LanguageType getTitle returns correct value', () {
      final l10n = MockAppLocalizations();
      expect(
          LanguageType.phone.getTitle(l10n: l10n, name: ''), equals('Phone'));
      expect(LanguageType.ca.getTitle(l10n: l10n, name: ''), equals('Catalan'));
      expect(LanguageType.en.getTitle(l10n: l10n, name: ''), equals('English'));
      expect(LanguageType.es.getTitle(l10n: l10n, name: ''), equals('Spanish'));
      expect(LanguageType.fr.getTitle(l10n: l10n, name: ''), equals('French'));
    });
  });
}
