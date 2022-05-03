part of 'self_issued_credential_cubit.dart';

@JsonSerializable()
class SelfIssuedCredentialState extends Equatable {
  const SelfIssuedCredentialState({
    this.status = AppStatus.init,
    this.message,
  });

  factory SelfIssuedCredentialState.fromJson(Map<String, dynamic> json) =>
      _$SelfIssuedCredentialStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;

  SelfIssuedCredentialState loading() {
    return const SelfIssuedCredentialState(status: AppStatus.loading);
  }

  SelfIssuedCredentialState error({required MessageHandler messageHandler}) {
    return SelfIssuedCredentialState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
    );
  }

  SelfIssuedCredentialState success({MessageHandler? messageHandler}) {
    return SelfIssuedCredentialState(
      status: AppStatus.success,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
    );
  }

  Map<String, dynamic> toJson() => _$SelfIssuedCredentialStateToJson(this);

  @override
  List<Object?> get props => [status, message];
}
