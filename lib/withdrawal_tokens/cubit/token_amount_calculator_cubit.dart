import 'package:altme/dashboard/dashboard.dart';
import 'package:altme/withdrawal_tokens/withdrawal_tokens.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token_amount_calculator_state.dart';

part 'token_amount_calculator_cubit.g.dart';

class TokenAmountCalculatorCubit extends Cubit<TokenAmountCalculatorState> {
  TokenAmountCalculatorCubit({
    required this.tokenSelectBoxController,
    required this.controller,
  }) : super(
          TokenAmountCalculatorState(
            selectedToken: tokenSelectBoxController.selectedToken,
          ),
        ) {
    _init();
  }

  void _init() {
    tokenSelectBoxController.addListener(_onTokenSelectBoxChangeListener);
  }

  void _onTokenSelectBoxChangeListener() {
    setSelectedToken(tokenModel: tokenSelectBoxController.selectedToken);
    setAmount(amount: '');
  }

  final TokenSelectBoxController tokenSelectBoxController;
  final TokenAmountCalculatorController controller;

  void setSelectedToken({required TokenModel tokenModel}) {
    tokenSelectBoxController.removeListener(_onTokenSelectBoxChangeListener);
    tokenSelectBoxController.setSelectedAccount(selectedToken: tokenModel);
    emit(state.copyWith(selectedToken: tokenModel, amount: ''));
    tokenSelectBoxController.addListener(_onTokenSelectBoxChangeListener);
  }

  void setAmount({required String amount}) {
    emit(state.copyWith(amount: amount));
    if (isValidateAmount(amount: amount)) {
      controller.setAmount(
        insertedAmount: double.parse(
          amount.replaceAll(',', ''),
        ),
      );
    } else {
      controller.setAmount(insertedAmount: 0);
    }
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
    controller.dispose();
    return super.close();
  }
}
