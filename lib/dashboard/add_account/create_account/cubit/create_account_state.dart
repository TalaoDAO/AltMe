part of 'create_account_cubit.dart';

@JsonSerializable()
class CreateAccountState extends Equatable {
  const CreateAccountState({
    this.status = AppStatus.init,
    this.message,
  });

  factory CreateAccountState.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  CreateAccountState loading() {
    return const CreateAccountState(
      status: AppStatus.loading,
    );
  }

  CreateAccountState error({required MessageHandler messageHandler}) {
    return CreateAccountState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  CreateAccountState success({
    MessageHandler? messageHandler,
    CryptoAccount? cryptoAccount,
  }) {
    return CreateAccountState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$CreateAccountStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
      ];
}
