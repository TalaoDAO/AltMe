import 'package:intl/intl.dart';

extension NumberFormatter on String {
  String format() {
    if (isEmpty || length < 3) return this;
    final formatter = NumberFormat('#,###');
    final value = this;
    final number = value.replaceAll(',', '');

    final splits = number.split('.');
    if (splits.length == 2) {
      final double intPart = double.parse(splits.first);
      return '${formatter.format(intPart)}.${splits.last}';
    } else if (splits.length == 1) {
      final double intPart = double.parse(splits.first);
      return formatter.format(intPart);
    } else {
      return this;
    }
  }
}
