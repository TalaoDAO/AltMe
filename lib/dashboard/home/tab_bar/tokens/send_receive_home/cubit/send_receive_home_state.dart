part of 'send_receive_home_cubit.dart';

@JsonSerializable()
class SendReceiveHomeState extends Equatable {
  const SendReceiveHomeState({
    this.operations = const [],
    required this.selectedToken,
    this.status = AppStatus.init,
    this.message,
  });

  factory SendReceiveHomeState.fromJson(Map<String, dynamic> json) =>
      _$SendReceiveHomeStateFromJson(json);

  final List<OperationModel> operations;
  final TokenModel selectedToken;
  final AppStatus status;
  final StateMessage? message;

  SendReceiveHomeState loading() {
    final state = copyWith(status: AppStatus.loading);
    return state;
  }

  SendReceiveHomeState error({required MessageHandler messageHandler}) {
    final state = copyWith(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
    return state;
  }

  SendReceiveHomeState success({
    MessageHandler? messageHandler,
    List<OperationModel>? operations,
    TokenModel? selectedToken,
  }) {
    final state = copyWith(
      status: AppStatus.success,
      selectedToken: selectedToken,
      operations: operations ?? this.operations,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
    return state;
  }

  SendReceiveHomeState copyWith({
    List<OperationModel>? operations,
    TokenModel? selectedToken,
    AppStatus? status,
    StateMessage? message,
  }) {
    final state = SendReceiveHomeState(
      operations: operations ?? this.operations,
      selectedToken: selectedToken ?? this.selectedToken,
      status: status ?? this.status,
      message: message ?? this.message,
    );
    return state;
  }

  Map<String, dynamic> toJson() => _$SendReceiveHomeStateToJson(this);

  @override
  List<Object?> get props => [status, message, operations, selectedToken];
}
