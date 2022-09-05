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
    List<OperationModel>? operations,
    TokenModel? selectedToken,
  }) {
    return copyWith(
      status: AppStatus.success,
      selectedToken: selectedToken,
      operations: operations ?? this.operations,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  SendReceiveHomeState copyWith({
    List<OperationModel>? operations,
    TokenModel? selectedToken,
    AppStatus? status,
    StateMessage? message,
  }) {
    return SendReceiveHomeState(
      operations: operations ?? this.operations,
      selectedToken: selectedToken ?? this.selectedToken,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() => _$SendReceiveHomeStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        operations,
        selectedToken,
      ];
}
