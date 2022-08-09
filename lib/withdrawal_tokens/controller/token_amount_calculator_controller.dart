import 'package:bloc/bloc.dart';

class TokenAmountCalculatorController extends Cubit<double> {
  TokenAmountCalculatorController({double insertedAmount = 0.0})
      : super(insertedAmount);

  void setAmount({required double insertedAmount}) {
    emit(insertedAmount);
  }
}
