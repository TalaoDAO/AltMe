import 'dart:async';

import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/withdrawal_tokens/widgets/widgets.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_amount_calculator_state.dart';

part 'token_amount_calculator_cubit.g.dart';

class TokenAmountCalculatorCubit extends Cubit<TokenAmountCalculatorState> {
  TokenAmountCalculatorCubit({
    required TokenModel selectedToken,
    this.onAmountChanged,
  }) : super(
          TokenAmountCalculatorState(
            selectedToken: selectedToken,
          ),
        );

  final OnAmountChanged? onAmountChanged;

  void setSelectedToken({required TokenModel tokenModel}) {
    emit(state.copyWith(selectedToken: tokenModel, amount: ''));
    onAmountChanged?.call(0);
  }

  void setAmount({required String amount}) {
    emit(
      state.copyWith(
        amount: amount,
        validAmount: isValidateAmount(amount: amount)
            ? double.parse(
                amount.replaceAll(',', ''),
              )
            : 0.0,
      ),
    );
    onAmountChanged?.call(state.validAmount);
  }

  bool isValidateAmount({required String? amount}) {
    if (amount == null) return false;
    try {
      final insertedAmount = double.parse(amount.replaceAll(',', ''));
      if (insertedAmount <= 0.00001) return false;
      final maxAmount = double.parse(
        state.selectedToken.calculatedBalance.replaceAll(',', ''),
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
