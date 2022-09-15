part of 'beacon_operation_cubit.dart';

@JsonSerializable()
class BeaconOperationState extends Equatable {
  const BeaconOperationState({
    this.status = AppStatus.init,
    this.message,
  });

  factory BeaconOperationState.fromJson(Map<String, dynamic> json) =>
      _$BeaconOperationStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  BeaconOperationState loading() {
    return const BeaconOperationState(status: AppStatus.loading);
  }

  BeaconOperationState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconOperationState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  BeaconOperationState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    return BeaconOperationState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$BeaconOperationStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
