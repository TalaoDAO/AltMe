part of 'confirm_withdrawal_cubit.dart';

@JsonSerializable()
class ConfirmWithdrawalState extends Equatable {
  ConfirmWithdrawalState({
    required this.withdrawalAddress,
    NetworkFeeModel? networkFee,
    this.status = AppStatus.init,
    this.message,
  }) : networkFee = networkFee ?? NetworkFeeModel.networks()[1];

  factory ConfirmWithdrawalState.fromJson(Map<String, dynamic> json) =>
      _$ConfirmWithdrawalStateFromJson(json);

  final String withdrawalAddress;
  final NetworkFeeModel networkFee;
  final AppStatus status;
  final StateMessage? message;

  ConfirmWithdrawalState loading() {
    return copyWith(
      status: AppStatus.loading,
    );
  }

  ConfirmWithdrawalState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  ConfirmWithdrawalState success({
    MessageHandler? messageHandler,
  }) {
    return copyWith(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  ConfirmWithdrawalState copyWith({
    String? withdrawalAddress,
    NetworkFeeModel? networkFee,
    AppStatus? status,
    StateMessage? message,
  }) {
    return ConfirmWithdrawalState(
      withdrawalAddress: withdrawalAddress ?? this.withdrawalAddress,
      networkFee: networkFee ?? this.networkFee,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$ConfirmWithdrawalStateToJson(this);

  @override
  List<Object?> get props => [withdrawalAddress, status, message, networkFee];
}
