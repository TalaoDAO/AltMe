part of 'token_select_box_cubit.dart';

@JsonSerializable()
class TokenSelectBoxState extends Equatable {
  const TokenSelectBoxState({
    this.amount = '',
    required this.selectedToken,
  });

  factory TokenSelectBoxState.fromJson(Map<String, dynamic> json) =>
      _$TokenSelectBoxStateFromJson(json);

  final String amount;
  final TokenModel selectedToken;

  TokenSelectBoxState copyWith({
    String? amount,
    TokenModel? selectedToken,
  }) {
    return TokenSelectBoxState(
      amount: amount ?? this.amount,
      selectedToken: selectedToken ?? this.selectedToken,
    );
  }

  Map<String, dynamic> toJson() => _$TokenSelectBoxStateToJson(this);

  @override
  List<Object?> get props => [amount, selectedToken];
}
