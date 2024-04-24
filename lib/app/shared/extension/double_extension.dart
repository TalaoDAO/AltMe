extension DoubleExtension on double {
  String decimalNumber(int n) {
    int number = 1;
    for (int i = 0; i < n; i++) {
      number *= 10;
    }

    final twoDecimalNumber = (this * number).floor() / number;
    return twoDecimalNumber.toString();
  }
}
