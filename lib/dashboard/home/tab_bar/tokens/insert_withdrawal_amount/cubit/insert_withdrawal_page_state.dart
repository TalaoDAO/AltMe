part of 'insert_withdrawal_page_cubit.dart';

@JsonSerializable()
class InsertWithdrawalPageState extends Equatable {
  const InsertWithdrawalPageState({
    required this.selectedToken,
    this.amount = 0.0,
    this.isValidWithdrawal = false,
  });

  factory InsertWithdrawalPageState.fromJson(Map<String, dynamic> json) =>
      _$InsertWithdrawalPageStateFromJson(json);

  final TokenModel selectedToken;
  final double amount;
  final bool isValidWithdrawal;

  InsertWithdrawalPageState copyWith({
    double? amount,
    bool? isValidWithdrawal,
    TokenModel? selectedToken,
  }) {
    return InsertWithdrawalPageState(
      selectedToken: selectedToken ?? this.selectedToken,
      amount: amount ?? this.amount,
      isValidWithdrawal: isValidWithdrawal ?? this.isValidWithdrawal,
    );
  }

  Map<String, dynamic> toJson() => _$InsertWithdrawalPageStateToJson(this);

  @override
  List<Object?> get props => [selectedToken, amount, isValidWithdrawal];
}
