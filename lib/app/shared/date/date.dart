import 'package:altme/app/logger/logger.dart';
import 'package:altme/l10n/arb/app_localizations.dart';
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
      date = DateFormat('y-M-d').parse(dateString, true).toLocal();
    } on FormatException catch (_) {
      try {
        date = DateFormat('y-M-dThh:mm:ssZ').parse(dateString, true).toLocal();
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

  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return outputFormat.format(dateTime);
  }

  static String formatDatetime(DateTime dateTime) {
    final date = '${dateTime.year}.${dateTime.month}.${dateTime.day}';
    final time = '${dateTime.hour}:${dateTime.minute}:${dateTime.second}';

    return '$date $time';
  }

  static String? formatTime(String formattedString) {
    try {
      final DateTime dt = DateFormat(
        'hh:mm:ss',
      ).parse(formattedString, true).toLocal();
      return DateFormat.jm().format(dt);
    } on FormatException {
      return null;
    }
  }

  static String formatDateForCredentialCard(String date) {
    try {
      if (isTimestampString(date)) {
        final double doubleValue = double.parse(date);
        final int intValue = doubleValue.toInt();
        final DateTime dt = DateTime.fromMillisecondsSinceEpoch(
          intValue * 1000,
        );
        return formatDate(dt);
      } else {
        return outputFormat.format(
          DateFormat('y-M-dThh:mm:ssZ').parse(date, true).toLocal(),
        );
      }
    } catch (e) {
      //getLogger('date').e('e: $e, s: $s');
      return '';
    }
  }

  static bool isTimestampString(String input) {
    try {
      final double doubleValue = double.parse(input);
      doubleValue.toInt();
      return true;
    } catch (e) {
      return false;
    }
  }

  static String? normalFormat(String? date) {
    try {
      if (date?.isEmpty ?? true) {
        return null;
      }
      return DateFormat(
        'dd-MM-yyyy HH:mm',
      ).format(DateFormat('y-M-dThh:mm:ssZ').parse(date!, true).toLocal());
    } catch (e, s) {
      getLogger('date').e('e: $e, s: $s');
      return null;
    }
  }

  static DateTime parseExpirationDate(String input) {
    if (RegExp(r'^\d+$').hasMatch(input)) {
      // numeric date string
      final int timestamp = int.parse(input);
      return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    } else {
      // ISO 8601 formatted date string
      return DateTime.parse(input);
    }
  }
}
