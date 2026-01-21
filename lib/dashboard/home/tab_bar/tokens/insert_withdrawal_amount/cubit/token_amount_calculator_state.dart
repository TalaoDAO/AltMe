part of 'token_amount_calculator_cubit.dart';

@JsonSerializable()
class TokenAmountCalculatorState extends Equatable {
  const TokenAmountCalculatorState({
    this.validAmount = '0',
    this.insertedAmount = '',
    this.status = AppStatus.idle,
  });

  factory TokenAmountCalculatorState.fromJson(Map<String, dynamic> json) =>
      _$TokenAmountCalculatorStateFromJson(json);

  final String validAmount;
  final String insertedAmount;
  final AppStatus status;

  TokenAmountCalculatorState loading() {
    return copyWith(status: AppStatus.loading);
  }

  TokenAmountCalculatorState copyWith({
    AppStatus status = AppStatus.idle,
    String? validAmount,
    String? insertedAmount,
  }) {
    return TokenAmountCalculatorState(
      status: status,
      insertedAmount: insertedAmount ?? this.insertedAmount,
      validAmount: validAmount ?? this.validAmount,
    );
  }

  Map<String, dynamic> toJson() => _$TokenAmountCalculatorStateToJson(this);

  @override
  List<Object?> get props => [status, validAmount, insertedAmount];
}
