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

  @override
  Future<void> close() {
    tokenSelectBoxController.dispose();
    return super.close();
  }
}
