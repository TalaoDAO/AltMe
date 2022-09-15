part of 'beacon_sign_payload_cubit.dart';

@JsonSerializable()
class BeaconSignPayloadState extends Equatable {
  const BeaconSignPayloadState({
    this.status = AppStatus.init,
    this.message,
  });

  factory BeaconSignPayloadState.fromJson(Map<String, dynamic> json) =>
      _$BeaconSignPayloadStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  BeaconSignPayloadState loading() {
    return const BeaconSignPayloadState(status: AppStatus.loading);
  }

  BeaconSignPayloadState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconSignPayloadState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  BeaconSignPayloadState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    return BeaconSignPayloadState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$BeaconSignPayloadStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
