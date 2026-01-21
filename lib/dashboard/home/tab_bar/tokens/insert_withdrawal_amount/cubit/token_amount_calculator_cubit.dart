import 'package:altme/app/app.dart';
import 'package:altme/dashboard/dashboard.dart';
import 'package:bloc/bloc.dart';
import 'package:decimal/decimal.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_amount_calculator_state.dart';

part 'token_amount_calculator_cubit.g.dart';

class TokenAmountCalculatorCubit extends Cubit<TokenAmountCalculatorState> {
  TokenAmountCalculatorCubit({required this.insertWithdrawalPageCubit})
    : super(const TokenAmountCalculatorState());

  final InsertWithdrawalPageCubit insertWithdrawalPageCubit;

  void setAmount({required String amount, required TokenModel selectedToken}) {
    Decimal validAmount = Decimal.parse('0');
    String insertedAmount = '';
    try {
      emit(state.loading());
      if (amount.isEmpty) {
        validAmount = Decimal.parse('0');
        insertedAmount = '';
      } else if (amount == '0' || amount == '00') {
        validAmount = Decimal.parse('0');
        insertedAmount = '0';
      } else if (amount == '.') {
        validAmount = Decimal.parse('0.');
        insertedAmount = '0.';
      } else {
        String trimmedAmount = amount;

        // Check if the amount starts with zero(s) but not a decimal number
        if (RegExp(r'^0+(\d+)').hasMatch(amount)) {
          trimmedAmount = amount.replaceAll(RegExp('^0+'), '');
        }

        insertedAmount = trimmedAmount.replaceAll(',', '');
        final bool isValid = isValidateAmount(
          amount: trimmedAmount,
          selectedToken: selectedToken,
        );
        validAmount = isValid
            ? Decimal.parse(trimmedAmount.replaceAll(',', ''))
            : Decimal.parse('0');
      }
    } catch (e, s) {
      emit(state.copyWith(status: AppStatus.idle));
      getLogger(
        runtimeType.toString(),
      ).e('error in calculate amount,e: $e, s: $s');
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
    if (amount == null || amount.isEmpty) return true;
    // true => to avoid error => No balance
    try {
      final insertedAmount = Decimal.parse(amount.replaceAll(',', ''));
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
