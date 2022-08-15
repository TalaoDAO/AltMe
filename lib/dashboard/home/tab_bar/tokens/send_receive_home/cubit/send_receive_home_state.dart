part of 'send_receive_home_cubit.dart';

@JsonSerializable()
class SendReceiveHomeState extends Equatable {
  const SendReceiveHomeState({
    this.operations,
    this.status = AppStatus.init,
    this.message,
  });

  factory SendReceiveHomeState.fromJson(Map<String, dynamic> json) =>
      _$SendReceiveHomeStateFromJson(json);

  final dynamic operations;
  final AppStatus status;
  final StateMessage? message;

  SendReceiveHomeState loading() {
    return copyWith(
      status: AppStatus.loading,
    );
  }

  SendReceiveHomeState error({
    required MessageHandler messageHandler,
  }) {
    return copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  SendReceiveHomeState success({
    MessageHandler? messageHandler,
  }) {
    return copyWith(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  SendReceiveHomeState copyWith({
    dynamic operations,
    AppStatus? status,
    StateMessage? message,
  }) {
    return SendReceiveHomeState(
      operations: operations ?? this.operations,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$SendReceiveHomeStateToJson(this);

  @override
  List<Object?> get props => [status, message, operations];
}
