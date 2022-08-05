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
  }) : super(TokenAmountCalculatorState(
            selectedToken: tokenSelectBoxController.selectedToken)) {
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

  void setSelectedToken({required TokenModel tokenModel}) {
    tokenSelectBoxController.removeListener(_onTokenSelectBoxChangeListener);
    tokenSelectBoxController.setSelectedAccount(selectedToken: tokenModel);
    emit(state.copyWith(selectedToken: tokenModel, amount: ''));
    tokenSelectBoxController.addListener(_onTokenSelectBoxChangeListener);
  }

  void setAmount({required String amount}) {
    emit(state.copyWith(amount: amount));
  }

  bool validateAmount({required String? amount}) {
    if (amount == null) return false;
    try {
      final insertedAmount = double.parse(amount.replaceAll(',', ''));
      final maxAmount = double.parse(
        state.selectedToken.calculatedBalance.replaceAll(',', ''),
      );
      if (insertedAmount > maxAmount) {
        return false;
      } else {
        return true;
      }
    } catch (e, s) {
      return true;
    }
  }

  @override
  Future<void> close() {
    tokenSelectBoxController.dispose();
    return super.close();
  }
}
