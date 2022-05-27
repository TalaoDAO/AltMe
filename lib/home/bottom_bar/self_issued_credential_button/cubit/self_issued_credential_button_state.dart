part of 'self_issued_credential_button_cubit.dart';

@JsonSerializable()
class SelfIssuedCredentialButtonState extends Equatable {
  const SelfIssuedCredentialButtonState({
    this.status = AppStatus.init,
    this.message,
  });

  factory SelfIssuedCredentialButtonState.fromJson(Map<String, dynamic> json) =>
      _$SelfIssuedCredentialButtonStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  SelfIssuedCredentialButtonState loading() {
    return const SelfIssuedCredentialButtonState(status: AppStatus.loading);
  }

  SelfIssuedCredentialButtonState error({
    required MessageHandler messageHandler,
  }) {
    return SelfIssuedCredentialButtonState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  SelfIssuedCredentialButtonState success({MessageHandler? messageHandler}) {
    return SelfIssuedCredentialButtonState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() =>
      _$SelfIssuedCredentialButtonStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
