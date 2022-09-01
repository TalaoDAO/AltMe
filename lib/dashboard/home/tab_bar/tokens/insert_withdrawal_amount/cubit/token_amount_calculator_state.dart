part of 'token_amount_calculator_cubit.dart';

@JsonSerializable()
class TokenAmountCalculatorState extends Equatable {
  const TokenAmountCalculatorState({
    this.amount = '',
    this.validAmount = 0.0,
    this.insertedAmount = 0.0,
  });

  factory TokenAmountCalculatorState.fromJson(Map<String, dynamic> json) =>
      _$TokenAmountCalculatorStateFromJson(json);

  final String amount;
  final double validAmount;
  final double insertedAmount;

  TokenAmountCalculatorState copyWith({
    String? amount,
    double? validAmount,
    double? insertedAmount,
    TokenModel? selectedToken,
  }) {
    return TokenAmountCalculatorState(
      amount: amount ?? this.amount,
      insertedAmount: insertedAmount ?? this.insertedAmount,
      validAmount: validAmount ?? this.validAmount,
    );
  }

  Map<String, dynamic> toJson() => _$TokenAmountCalculatorStateToJson(this);

  @override
  List<Object?> get props => [
        amount,
        validAmount,
        insertedAmount,
      ];
}
