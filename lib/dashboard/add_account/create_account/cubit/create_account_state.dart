part of 'create_account_cubit.dart';

@JsonSerializable()
class CreateAccountState extends Equatable {
  const CreateAccountState({this.status = AppStatus.init, this.message});

  factory CreateAccountState.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  CreateAccountState loading() {
    const loadingState = CreateAccountState(status: AppStatus.loading);
    return loadingState;
  }

  CreateAccountState error({required MessageHandler messageHandler}) {
    final errorState = CreateAccountState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
    return errorState;
  }

  CreateAccountState success({
    MessageHandler? messageHandler,
    CryptoAccount? cryptoAccount,
  }) {
    final successState = CreateAccountState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
    return successState;
  }

  Map<String, dynamic> toJson() => _$CreateAccountStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
