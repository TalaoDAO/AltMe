import 'package:altme/dashboard/dashboard.dart';
import 'package:flutter/foundation.dart';

class TokenAmountCalculatorController extends ChangeNotifier {
  TokenAmountCalculatorController({double insertedAmount = 0.0})
      : _insertedAmount = insertedAmount;

  double _insertedAmount;

  double get insertedAmount => _insertedAmount;

  void setAmount({required double insertedAmount}) {
    _insertedAmount = insertedAmount;
    notifyListeners();
  }
}
