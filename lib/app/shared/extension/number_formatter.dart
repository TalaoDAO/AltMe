import 'package:intl/intl.dart';

extension NumberFormatter on String {
  String formatNumber() {
    if (isEmpty || length < 3) return this;
    final formatter = NumberFormat('#,###');
    final value = this;
    final number = value.replaceAll(',', '');
    try {
      double.parse(number);
    } catch (e) {
      return this;
    }

    final splits = number.split('.');
    if (splits.length == 2) {
      final double intPart =
          double.parse(splits.first.isEmpty ? '0' : splits.first);
      return '''${formatter.format(intPart)}${splits.last.isEmpty ? '' : '.${splits.last}'}''';
    } else if (splits.length == 1) {
      final double intPart =
          double.parse(splits.first.isEmpty ? '0' : splits.first);
      return formatter.format(intPart);
    } else {
      return this;
    }
  }
}
