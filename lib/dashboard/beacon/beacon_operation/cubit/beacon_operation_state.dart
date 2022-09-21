part of 'beacon_operation_cubit.dart';

@JsonSerializable()
class BeaconOperationState extends Equatable {
  BeaconOperationState({
    NetworkFeeModel? networkFee,
    this.status = AppStatus.init,
    this.message,
    this.xtzUSDRate = 0,
  }) : networkFee = networkFee ?? NetworkFeeModel.networks()[1];

  factory BeaconOperationState.fromJson(Map<String, dynamic> json) =>
      _$BeaconOperationStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final NetworkFeeModel networkFee;
  final double xtzUSDRate;

  BeaconOperationState loading() {
    return BeaconOperationState(
      status: AppStatus.loading,
      networkFee: networkFee,
      xtzUSDRate: xtzUSDRate,
    );
  }

  BeaconOperationState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconOperationState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      networkFee: networkFee,
      xtzUSDRate: xtzUSDRate,
    );
  }

  BeaconOperationState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    NetworkFeeModel? networkFee,
    int? selectedIndex,
    double? xtzUSDRate,
  }) {
    return BeaconOperationState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      networkFee: networkFee ?? this.networkFee,
      xtzUSDRate: xtzUSDRate ?? this.xtzUSDRate,
    );
  }

  Map<String, dynamic> toJson() => _$BeaconOperationStateToJson(this);

  @override
  List<Object?> get props => [status, message, networkFee, xtzUSDRate];
}
