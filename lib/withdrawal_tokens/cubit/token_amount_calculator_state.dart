part of 'token_amount_calculator_cubit.dart';

@JsonSerializable()
class TokenAmountCalculatorState extends Equatable {
  const TokenAmountCalculatorState({
    this.amount = '',
    this.validAmount = 0.0,
    required this.selectedToken,
  });

  factory TokenAmountCalculatorState.fromJson(Map<String, dynamic> json) =>
      _$TokenAmountCalculatorStateFromJson(json);

  final String amount;
  final double validAmount;
  final TokenModel selectedToken;

  TokenAmountCalculatorState copyWith({
    String? amount,
    double? validAmount,
    TokenModel? selectedToken,
  }) {
    return TokenAmountCalculatorState(
      amount: amount ?? this.amount,
      validAmount: validAmount ?? this.validAmount,
      selectedToken: selectedToken ?? this.selectedToken,
    );
  }

  Map<String, dynamic> toJson() => _$TokenAmountCalculatorStateToJson(this);

  @override
  List<Object?> get props => [amount, selectedToken, validAmount];
}
