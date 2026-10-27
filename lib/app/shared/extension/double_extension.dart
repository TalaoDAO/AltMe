extension DoubleExtension on double {
  String decimalNumber(int n) {
    int number = 1;
    for (int i = 0; i < n; i++) {
      if (i > toString().split('.').toList().last.length) {
        break;
      }
      number *= 10;
    }

    final twoDecimalNumber = (this * number).floor() / number;
    final decimalString = twoDecimalNumber.toString();
    return decimalString;
  }
}
