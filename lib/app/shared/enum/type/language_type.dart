import 'package:altme/l10n/l10n.dart';

enum LanguageType {
  phone,
  ca,
  en,
  es,
  fr,
}

extension LanguageTypeX on LanguageType {
  String getTitle({
    required AppLocalizations l10n,
    required String name,
  }) {
    switch (this) {
      case LanguageType.phone:
        return l10n.phoneLanguage;
      case LanguageType.ca:
        return l10n.catalan;
      case LanguageType.en:
        return l10n.english;
      case LanguageType.es:
        return l10n.spanish;
      case LanguageType.fr:
        return l10n.french;
    }
  }
}
