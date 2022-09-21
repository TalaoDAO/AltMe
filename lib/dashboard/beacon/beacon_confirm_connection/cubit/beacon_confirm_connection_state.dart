part of 'beacon_confirm_connection_cubit.dart';

@JsonSerializable()
class BeaconConfirmConnectionState extends Equatable {
  const BeaconConfirmConnectionState({
    this.status = AppStatus.init,
    this.message,
  });

  factory BeaconConfirmConnectionState.fromJson(Map<String, dynamic> json) =>
      _$BeaconConfirmConnectionStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  BeaconConfirmConnectionState loading() {
    return const BeaconConfirmConnectionState(status: AppStatus.loading);
  }

  BeaconConfirmConnectionState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconConfirmConnectionState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  BeaconConfirmConnectionState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    return BeaconConfirmConnectionState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$BeaconConfirmConnectionStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
