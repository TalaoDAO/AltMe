import 'package:altme/app/logger/logger.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_amount_calculator_state.dart';

part 'token_amount_calculator_cubit.g.dart';

class TokenAmountCalculatorCubit extends Cubit<TokenAmountCalculatorState> {
  TokenAmountCalculatorCubit({
    required this.insertWithdrawalPageCubit,
  }) : super(const TokenAmountCalculatorState());

  final InsertWithdrawalPageCubit insertWithdrawalPageCubit;

  void setAmount({
    required String amount,
    required TokenModel selectedToken,
  }) {
    double validAmount = 0;
    double insertedAmount = 0;
    try {
      if (amount.isEmpty || amount == '0' || amount == '0.0') {
        insertedAmount = 0;
        validAmount = 0;
      } else {
        insertedAmount = double.parse(amount.replaceAll(',', ''));
        final bool isValid =
            isValidateAmount(amount: amount, selectedToken: selectedToken);
        validAmount = isValid ? double.parse(amount.replaceAll(',', '')) : 0.0;
      }
    } catch (e, s) {
      getLogger(runtimeType.toString())
          .e('error in calculate amount,e: $e, s: $s');
    }

    emit(
      state.copyWith(
        amount: amount,
        validAmount: validAmount,
        insertedAmount: insertedAmount,
      ),
    );

    insertWithdrawalPageCubit.setAmount(amount: validAmount);
  }

  bool isValidateAmount({
    required String? amount,
    required TokenModel selectedToken,
  }) {
    if (amount == null) return false;
    try {
      final insertedAmount = double.parse(amount.replaceAll(',', ''));
      if (insertedAmount <= 0.0) return false;
      final maxAmount = double.parse(
        selectedToken.calculatedBalance.replaceAll(',', ''),
      );
      if (insertedAmount > maxAmount) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}
