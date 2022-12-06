part of 'sign_payload_cubit.dart';

@JsonSerializable()
class SignPayloadState extends Equatable {
  const SignPayloadState({
    this.status = AppStatus.init,
    this.message,
    this.payloadMessage,
  });

  factory SignPayloadState.fromJson(Map<String, dynamic> json) =>
      _$SignPayloadStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final String? payloadMessage;

  SignPayloadState loading() {
    return SignPayloadState(
      status: AppStatus.loading,
      payloadMessage: payloadMessage,
    );
  }

  SignPayloadState error({
    required MessageHandler messageHandler,
  }) {
    return SignPayloadState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      payloadMessage: payloadMessage,
    );
  }

  SignPayloadState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    String? payloadMessage,
  }) {
    return SignPayloadState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      payloadMessage: payloadMessage ?? this.payloadMessage,
    );
  }

  Map<String, dynamic> toJson() => _$SignPayloadStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        payloadMessage,
      ];
}
