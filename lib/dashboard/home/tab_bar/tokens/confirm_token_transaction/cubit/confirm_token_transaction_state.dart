part of 'confirm_token_transaction_cubit.dart';

@JsonSerializable()
class ConfirmTokenTransactionState extends Equatable {
  ConfirmTokenTransactionState({
    required this.withdrawalAddress,
    NetworkFeeModel? networkFee,
    this.status = AppStatus.init,
    this.message,
  }) : networkFee = networkFee ?? NetworkFeeModel.networks()[1];

  factory ConfirmTokenTransactionState.fromJson(Map<String, dynamic> json) =>
      _$ConfirmTokenTransactionStateFromJson(json);

  final String withdrawalAddress;
  final NetworkFeeModel networkFee;
  final AppStatus status;
  final StateMessage? message;

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
  }) {
    return copyWith(
      status: AppStatus.success,
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
  }) {
    return ConfirmTokenTransactionState(
      withdrawalAddress: withdrawalAddress ?? this.withdrawalAddress,
      networkFee: networkFee ?? this.networkFee,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$ConfirmTokenTransactionStateToJson(this);

  @override
  List<Object?> get props => [withdrawalAddress, status, message, networkFee];
}
