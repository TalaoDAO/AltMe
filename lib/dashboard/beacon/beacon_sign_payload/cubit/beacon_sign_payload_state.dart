part of 'beacon_sign_payload_cubit.dart';

@JsonSerializable()
class BeaconSignPayloadState extends Equatable {
  const BeaconSignPayloadState({
    this.status = AppStatus.init,
    this.message,
    this.payloadMessage,
  });

  factory BeaconSignPayloadState.fromJson(Map<String, dynamic> json) =>
      _$BeaconSignPayloadStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final String? payloadMessage;

  BeaconSignPayloadState loading() {
    return BeaconSignPayloadState(
      status: AppStatus.loading,
      payloadMessage: payloadMessage,
    );
  }

  BeaconSignPayloadState error({
    required MessageHandler messageHandler,
  }) {
    return BeaconSignPayloadState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      payloadMessage: payloadMessage,
    );
  }

  BeaconSignPayloadState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    String? payloadMessage,
  }) {
    return BeaconSignPayloadState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      payloadMessage: payloadMessage ?? this.payloadMessage,
    );
  }

  Map<String, dynamic> toJson() => _$BeaconSignPayloadStateToJson(this);

  @override
  List<Object?> get props => [status, message, payloadMessage];
}
