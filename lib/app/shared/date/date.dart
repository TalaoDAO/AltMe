import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class UiDate {
  UiDate._();

  static final outputFormat = DateFormat('yyyy-MM-dd');

  static String displayRegionalDate(
    AppLocalizations localizations,
    String dateString,
  ) {
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

  static String formatStringDate(String dateTime) {
    try {
      final DateTime dt = DateTime.parse(dateTime);
      return formatDate(dt);
    } catch (e) {
      return '';
    }
  }

  static String formatDate(DateTime dateTime) {
    return outputFormat.format(dateTime);
  }

  static String? formatTime(String formattedString) {
    try {
      final DateTime dt = DateFormat('hh:mm:ss').parse(formattedString);
      return DateFormat.jm().format(dt);
    } on FormatException {
      return null;
    }
  }

  static String formatDateForCredentialCard(String date) {
    try {
      return DateFormat('ddFF MMM yyyy')
          .format(
            DateFormat('y-M-dThh:mm:ssZ').parse(
              date,
            ),
          )
          .replaceFirst('FF', 'th');
    } catch (_) {
      return '';
    }
  }
}
