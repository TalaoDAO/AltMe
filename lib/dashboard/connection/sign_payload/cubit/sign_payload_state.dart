part of 'sign_payload_cubit.dart';

@JsonSerializable()
class SignPayloadState extends Equatable {
  const SignPayloadState({
    this.status = AppStatus.init,
    this.message,
    this.payloadMessage,
    this.dAppName = '',
  });

  factory SignPayloadState.fromJson(Map<String, dynamic> json) =>
      _$SignPayloadStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final String? payloadMessage;
  final String dAppName;

  SignPayloadState loading() {
    return copyWith(status: AppStatus.loading);
  }

  SignPayloadState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  SignPayloadState copyWith({
    AppStatus status = AppStatus.idle,
    StateMessage? message,
    String? payloadMessage,
    String? dAppName,
  }) {
    return SignPayloadState(
      status: status,
      message: message,
      payloadMessage: payloadMessage ?? this.payloadMessage,
      dAppName: dAppName ?? this.dAppName,
    );
  }

  Map<String, dynamic> toJson() => _$SignPayloadStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        payloadMessage,
        dAppName,
      ];
}
