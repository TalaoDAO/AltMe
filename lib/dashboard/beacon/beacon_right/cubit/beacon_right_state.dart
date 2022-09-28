part of 'beacon_right_cubit.dart';

@JsonSerializable()
class BeaconRightState extends Equatable {
  const BeaconRightState({
    this.status = AppStatus.init,
    this.message,
  });

  factory BeaconRightState.fromJson(Map<String, dynamic> json) =>
      _$BeaconRightStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  BeaconRightState loading() {
    return const BeaconRightState(status: AppStatus.loading);
  }

  BeaconRightState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconRightState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  BeaconRightState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    return BeaconRightState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$BeaconRightStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
