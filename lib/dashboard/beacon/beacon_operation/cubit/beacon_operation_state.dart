part of 'beacon_operation_cubit.dart';

@JsonSerializable()
class BeaconOperationState extends Equatable {
  const BeaconOperationState({
    this.status = AppStatus.init,
    this.message,
    this.xtzUSDRate = 0,
    this.totalFee,
  });

  factory BeaconOperationState.fromJson(Map<String, dynamic> json) =>
      _$BeaconOperationStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final double xtzUSDRate;
  final int? totalFee;

  BeaconOperationState loading() {
    return BeaconOperationState(
      status: AppStatus.loading,
      totalFee: totalFee,
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
      totalFee: totalFee,
    );
  }

  BeaconOperationState copyWith({
    AppStatus status = AppStatus.idle,
    MessageHandler? messageHandler,
    int? totalFee,
    int? selectedIndex,
    double? xtzUSDRate,
  }) {
    return BeaconOperationState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      totalFee: totalFee ?? this.totalFee,
      xtzUSDRate: xtzUSDRate ?? this.xtzUSDRate,
    );
  }

  Map<String, dynamic> toJson() => _$BeaconOperationStateToJson(this);

  @override
  List<Object?> get props => [status, message, totalFee, xtzUSDRate];
}
