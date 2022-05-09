import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class UiDate {
  UiDate._();

  static String displayDate(AppLocalizations localizations, String dateString) {
    if (dateString == '') return '';
    late DateTime date;
    try {
      date = DateFormat('y-M-d').parse(dateString);
    } on FormatException catch (_) {
      try {
        date = DateFormat('y-M-dThh:mm:ssZ').parse(dateString);
      } catch (e) {
        return '';
      }
    } catch (e) {
      return '';
    }

    return DateFormat.yMd(localizations.localeName).format(date);
  }
}
