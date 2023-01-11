part of 'confirm_token_transaction_cubit.dart';

@JsonSerializable()
class ConfirmTokenTransactionState extends Equatable {
  const ConfirmTokenTransactionState({
    required this.withdrawalAddress,
    required this.selectedToken,
    required this.selectedAccountSecretKey,
    this.networkFee,
    required this.tokenAmount,
    required this.totalAmount,
    this.networkFees,
    this.status = AppStatus.init,
    this.message,
    this.transactionHash,
  });

  factory ConfirmTokenTransactionState.fromJson(Map<String, dynamic> json) =>
      _$ConfirmTokenTransactionStateFromJson(json);

  final String withdrawalAddress;
  final NetworkFeeModel? networkFee;
  final List<NetworkFeeModel>? networkFees;
  final AppStatus status;
  final StateMessage? message;
  final String? transactionHash;
  final double tokenAmount;
  final double totalAmount;
  final TokenModel selectedToken;
  final String selectedAccountSecretKey;

  ConfirmTokenTransactionState loading() {
    return copyWith(
      status: AppStatus.loading,
      withdrawalAddress: withdrawalAddress,
      networkFee: networkFee,
    );
  }

  ConfirmTokenTransactionState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      withdrawalAddress: withdrawalAddress,
      networkFee: networkFee,
    );
  }

  ConfirmTokenTransactionState success({
    MessageHandler? messageHandler,
    String? transactionHash,
  }) {
    return copyWith(
      status: AppStatus.success,
      transactionHash: transactionHash,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      withdrawalAddress: withdrawalAddress,
      networkFee: networkFee,
    );
  }

  ConfirmTokenTransactionState copyWith({
    String? withdrawalAddress,
    NetworkFeeModel? networkFee,
    List<NetworkFeeModel>? networkFees,
    AppStatus? status,
    StateMessage? message,
    String? transactionHash,
    double? tokenAmount,
    double? totalAmount,
    TokenModel? selectedToken,
    String? selectedAccountSecretKey,
  }) {
    return ConfirmTokenTransactionState(
      withdrawalAddress: withdrawalAddress ?? this.withdrawalAddress,
      networkFee: networkFee ?? this.networkFee,
      networkFees: networkFees ?? this.networkFees,
      status: status ?? this.status,
      message: message ?? this.message,
      transactionHash: transactionHash ?? this.transactionHash,
      tokenAmount: tokenAmount ?? this.tokenAmount,
      selectedToken: selectedToken ?? this.selectedToken,
      selectedAccountSecretKey:
          selectedAccountSecretKey ?? this.selectedAccountSecretKey,
      totalAmount: totalAmount ?? this.totalAmount,
    );
  }

  Map<String, dynamic> toJson() => _$ConfirmTokenTransactionStateToJson(this);

  @override
  List<Object?> get props => [
        withdrawalAddress,
        status,
        message,
        networkFee,
        networkFees,
        tokenAmount,
        totalAmount,
        selectedToken,
        transactionHash,
        selectedAccountSecretKey,
      ];
}
