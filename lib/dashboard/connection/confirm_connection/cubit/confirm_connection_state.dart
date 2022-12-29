part of 'confirm_connection_cubit.dart';

@JsonSerializable()
class ConfirmConnectionState extends Equatable {
  const ConfirmConnectionState({
    this.status = AppStatus.init,
    this.message,
  });

  factory ConfirmConnectionState.fromJson(Map<String, dynamic> json) =>
      _$ConfirmConnectionStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  ConfirmConnectionState loading() {
    return const ConfirmConnectionState(status: AppStatus.loading);
  }

  ConfirmConnectionState error({
    required MessageHandler messageHandler,
  }) {
    return ConfirmConnectionState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  ConfirmConnectionState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    return ConfirmConnectionState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$ConfirmConnectionStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
