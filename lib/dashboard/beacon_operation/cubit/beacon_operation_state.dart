part of 'beacon_operation_cubit.dart';

@JsonSerializable()
class BeaconOperationState extends Equatable {
  BeaconOperationState({
    NetworkFeeModel? networkFee,
    this.status = AppStatus.init,
    this.message,
  }) : networkFee = networkFee ?? NetworkFeeModel.networks()[1];

  factory BeaconOperationState.fromJson(Map<String, dynamic> json) =>
      _$BeaconOperationStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final NetworkFeeModel networkFee;

  BeaconOperationState loading() {
    return BeaconOperationState(
      status: AppStatus.loading,
      networkFee: networkFee,
    );
  }

  BeaconOperationState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconOperationState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      networkFee: networkFee,
    );
  }

  BeaconOperationState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    NetworkFeeModel? networkFee,
    int? selectedIndex,
  }) {
    return BeaconOperationState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      networkFee: networkFee ?? this.networkFee,
    );
  }

  Map<String, dynamic> toJson() => _$BeaconOperationStateToJson(this);

  @override
  List<Object?> get props => [status, message, networkFee];
}
