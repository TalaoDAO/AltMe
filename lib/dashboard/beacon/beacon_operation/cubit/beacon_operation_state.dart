part of 'beacon_operation_cubit.dart';

@JsonSerializable()
class BeaconOperationState extends Equatable {
  const BeaconOperationState({
    this.status = AppStatus.init,
    this.message,
    this.xtzUSDRate = 0,
    this.selectedFee =
        const NetworkFeeModel(fee: 257 / 1e6, networkSpeed: NetworkSpeed.slow),
    this.baseFee =
        const NetworkFeeModel(fee: 257 / 1e6, networkSpeed: NetworkSpeed.slow),
  });

  factory BeaconOperationState.fromJson(Map<String, dynamic> json) =>
      _$BeaconOperationStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final double xtzUSDRate;
  final NetworkFeeModel selectedFee;
  final NetworkFeeModel baseFee;

  BeaconOperationState loading() {
    return BeaconOperationState(
      status: AppStatus.loading,
      selectedFee: selectedFee,
      xtzUSDRate: xtzUSDRate,
    );
  }

  BeaconOperationState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconOperationState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      xtzUSDRate: xtzUSDRate,
      selectedFee: selectedFee,
    );
  }

  BeaconOperationState copyWith({
    AppStatus? status,
    MessageHandler? messageHandler,
    NetworkFeeModel? selectedFee,
    NetworkFeeModel? baseFee,
    int? selectedIndex,
    double? xtzUSDRate,
  }) {
    return BeaconOperationState(
      status: status ?? this.status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      selectedFee: selectedFee ?? this.selectedFee,
      baseFee: baseFee ?? this.baseFee,
      xtzUSDRate: xtzUSDRate ?? this.xtzUSDRate,
    );
  }

  Map<String, dynamic> toJson() => _$BeaconOperationStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        selectedFee,
        xtzUSDRate,
        baseFee,
      ];
}
