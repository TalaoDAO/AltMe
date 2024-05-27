import 'package:altme/app/logger/logger.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
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
    Decimal validAmount = Decimal.parse('0');
    String insertedAmount = '';
    try {
      if (amount.isEmpty ||
          amount == '0' ||
          amount == '0.0' ||
          amount == '00') {
        validAmount = Decimal.parse('0');
        insertedAmount = '';
      } else {
        insertedAmount = amount.replaceAll(',', '');
        final bool isValid =
            isValidateAmount(amount: amount, selectedToken: selectedToken);
        validAmount = isValid
            ? Decimal.parse(amount.replaceAll(',', ''))
            : Decimal.parse('0');
      }
    } catch (e, s) {
      getLogger(runtimeType.toString())
          .e('error in calculate amount,e: $e, s: $s');
    }

    emit(
      state.copyWith(
        validAmount: validAmount.toString(),
        insertedAmount: insertedAmount,
      ),
    );

    insertWithdrawalPageCubit.setAmount(amount: validAmount.toString());
  }

  bool isValidateAmount({
    required String? amount,
    required TokenModel selectedToken,
  }) {
    if (amount == null) return false;
    try {
      final insertedAmount = Decimal.parse(amount.replaceAll(',', ''));
      if (insertedAmount <= Decimal.parse('0.0')) return false;
      final maxAmount = Decimal.parse(selectedToken.calculatedBalance);
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
