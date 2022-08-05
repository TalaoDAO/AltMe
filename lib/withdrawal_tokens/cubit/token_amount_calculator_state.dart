part of 'token_amount_calculator_cubit.dart';

@JsonSerializable()
class TokenAmountCalculatorState extends Equatable {
  const TokenAmountCalculatorState({
    this.amount = '',
    required this.selectedToken,
  });

  factory TokenAmountCalculatorState.fromJson(Map<String, dynamic> json) =>
      _$TokenAmountCalculatorStateFromJson(json);

  final String amount;
  final TokenModel selectedToken;

  TokenAmountCalculatorState copyWith({
    String? amount,
    TokenModel? selectedToken,
  }) {
    return TokenAmountCalculatorState(
      amount: amount ?? this.amount,
      selectedToken: selectedToken ?? this.selectedToken,
    );
  }

  Map<String, dynamic> toJson() => _$TokenAmountCalculatorStateToJson(this);

  @override
  List<Object?> get props => [amount, selectedToken];
}
