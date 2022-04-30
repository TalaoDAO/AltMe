import 'package:altme/app/shared/models/translation/translation.dart';
import 'package:altme/l10n/l10n.dart';

class GetTranslation {
  static String getTranslation(
    List<Translation> translations,
    AppLocalizations l10n,
  ) {
    String _translation;
    final translated =
        translations.where((element) => element.language == l10n.localeName);
    if (translated.isEmpty) {
      final List<Translation> translationList =
          translations.where((element) => element.language == 'en').toList();
      if (translationList.isEmpty) {
        _translation = '';
      } else {
        _translation = translationList.single.value;
      }
    } else {
      _translation = translated.single.value;
    }
    return _translation;
  }
}
