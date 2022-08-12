import 'dart:async';

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
    final bool isValid =
        isValidateAmount(amount: amount, selectedToken: selectedToken);

    final insertedAmount = double.parse(amount.replaceAll(',', ''));

    emit(
      state.copyWith(
        amount: amount,
        validAmount: isValid ? insertedAmount : 0.0,
      ),
    );
    insertWithdrawalPageCubit.setAmount(amount: insertedAmount);
  }

  bool isValidateAmount({
    required String? amount,
    required TokenModel selectedToken,
  }) {
    if (amount == null) return false;
    try {
      final insertedAmount = double.parse(amount.replaceAll(',', ''));
      if (insertedAmount <= 0.00001) return false;
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

  @override
  Future<void> close() {
    return super.close();
  }
}
