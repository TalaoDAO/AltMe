part of 'token_amount_calculator_cubit.dart';

@JsonSerializable()
class TokenAmountCalculatorState extends Equatable {
  const TokenAmountCalculatorState({
    this.validAmount = '0',
    this.insertedAmount = '',
  });

  factory TokenAmountCalculatorState.fromJson(Map<String, dynamic> json) =>
      _$TokenAmountCalculatorStateFromJson(json);

  final String validAmount;
  final String insertedAmount;

  TokenAmountCalculatorState copyWith({
    String? validAmount,
    String? insertedAmount,
  }) {
    return TokenAmountCalculatorState(
      insertedAmount: insertedAmount ?? this.insertedAmount,
      validAmount: validAmount ?? this.validAmount,
    );
  }

  Map<String, dynamic> toJson() => _$TokenAmountCalculatorStateToJson(this);

  @override
  List<Object?> get props => [
        validAmount,
        insertedAmount,
      ];
}
