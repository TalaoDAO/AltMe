part of 'credentials_cubit.dart';

@JsonSerializable()
class CredentialsState extends Equatable {
  const CredentialsState({
    this.status = CredentialsStatus.init,
    this.message,
    this.credentials = const [],
  });

  factory CredentialsState.fromJson(Map<String, dynamic> json) =>
      _$CredentialsStateFromJson(json);

  final CredentialsStatus status;
  final List<CredentialModel> credentials;
  final StateMessage? message;

  CredentialsState loading() {
    return CredentialsState(
      status: CredentialsStatus.loading,
      credentials: credentials,
      message: null,
    );
  }

  CredentialsState error({required MessageHandler messageHandler}) {
    return CredentialsState(
      status: CredentialsStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
    );
  }

  CredentialsState copyWith({
    required CredentialsStatus status,
    MessageHandler? messageHandler,
    List<CredentialModel>? credentials,
  }) {
    return CredentialsState(
      status: status,
      message: messageHandler == null
          ? message
          : StateMessage.success(messageHandler: messageHandler),
      credentials: credentials ?? this.credentials,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialsStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        message,
        credentials,
      ];
}
