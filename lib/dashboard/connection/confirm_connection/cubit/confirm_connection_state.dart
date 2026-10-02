part of 'confirm_connection_cubit.dart';

@JsonSerializable()
class ConfirmConnectionState extends Equatable {
  const ConfirmConnectionState({this.status = AppStatus.init, this.message});

  factory ConfirmConnectionState.fromJson(Map<String, dynamic> json) =>
      _$ConfirmConnectionStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  ConfirmConnectionState loading() {
    const loadingState = ConfirmConnectionState(status: AppStatus.loading);
    return loadingState;
  }

  ConfirmConnectionState error({required MessageHandler messageHandler}) {
    final errorState = ConfirmConnectionState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
    return errorState;
  }

  ConfirmConnectionState copyWith({
    AppStatus appStatus = AppStatus.idle,
    MessageHandler? messageHandler,
    int? selectedIndex,
  }) {
    final confirmConnectionState = ConfirmConnectionState(
      status: appStatus,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
    return confirmConnectionState;
  }

  Map<String, dynamic> toJson() => _$ConfirmConnectionStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
