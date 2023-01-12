part of 'confirm_token_transaction_cubit.dart';

@JsonSerializable()
class ConfirmTokenTransactionState extends Equatable {
  ConfirmTokenTransactionState({
    required this.withdrawalAddress,
    NetworkFeeModel? networkFee,
    this.status = AppStatus.init,
    this.message,
    this.transactionHash,
  }) : networkFee = networkFee ?? NetworkFeeModel.networks()[1];

  factory ConfirmTokenTransactionState.fromJson(Map<String, dynamic> json) =>
      _$ConfirmTokenTransactionStateFromJson(json);

  final String withdrawalAddress;
  final NetworkFeeModel networkFee;
  final AppStatus status;
  final StateMessage? message;
  final String? transactionHash;

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
    AppStatus? status,
    StateMessage? message,
    String? transactionHash,
  }) {
    return ConfirmTokenTransactionState(
      withdrawalAddress: withdrawalAddress ?? this.withdrawalAddress,
      networkFee: networkFee ?? this.networkFee,
      status: status ?? this.status,
      message: message ?? this.message,
      transactionHash: transactionHash ?? this.transactionHash,
    );
  }

  Map<String, dynamic> toJson() => _$ConfirmTokenTransactionStateToJson(this);

  @override
  List<Object?> get props => [
        withdrawalAddress,
        status,
        message,
        networkFee,
        transactionHash,
      ];
}
