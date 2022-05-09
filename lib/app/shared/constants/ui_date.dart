import 'package:intl/intl.dart';

abstract class UIDate {
  static String displayDate(String dateString) {
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
    // TODO(Taleb): check if Intl.getCurrentLocale() return true value
    return DateFormat.yMd(Intl.getCurrentLocale()).format(date);
  }
}
