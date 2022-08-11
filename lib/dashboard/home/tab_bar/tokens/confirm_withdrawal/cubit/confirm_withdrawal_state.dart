part of 'confirm_withdrawal_cubit.dart';

@JsonSerializable()
class ConfirmWithdrawalState extends Equatable {
  const ConfirmWithdrawalState({
    required this.withdrawalAddress,
    required this.selectedToken,
    required this.amount,
    required this.networkFee,
  });

  factory ConfirmWithdrawalState.fromJson(Map<String, dynamic> json) =>
      _$ConfirmWithdrawalStateFromJson(json);

  final String withdrawalAddress;
  final TokenModel selectedToken;
  final double amount;
  final NetworkFeeModel networkFee;

  ConfirmWithdrawalState copyWith({
    String? withdrawalAddress,
    TokenModel? selectedToken,
    NetworkFeeModel? networkFee,
    double? amount,
  }) {
    return ConfirmWithdrawalState(
      withdrawalAddress: withdrawalAddress ?? this.withdrawalAddress,
      selectedToken: selectedToken ?? this.selectedToken,
      networkFee: networkFee ?? this.networkFee,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() => _$ConfirmWithdrawalStateToJson(this);

  @override
  List<Object?> get props =>
      [withdrawalAddress, selectedToken, amount, networkFee];
}
