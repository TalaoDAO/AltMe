part of 'credentials_cubit.dart';

@JsonSerializable()
class CredentialsState extends Equatable {
  const CredentialsState({
    this.status = CredentialsStatus.init,
    this.message,
    this.credentials = const [],
    this.dummyCredentials = const {},
  });

  factory CredentialsState.fromJson(Map<String, dynamic> json) =>
      _$CredentialsStateFromJson(json);

  final CredentialsStatus status;
  final List<CredentialModel> credentials;
  final Map<CredentialCategory, List<DiscoverDummyCredential>> dummyCredentials;
  final StateMessage? message;

  CredentialsState loading() {
    final credentialsState = CredentialsState(
      status: CredentialsStatus.loading,
      credentials: credentials,
      message: null,
      dummyCredentials: dummyCredentials,
    );
    return credentialsState;
  }

  CredentialsState error({required MessageHandler messageHandler}) {
    final credentialsState = CredentialsState(
      status: CredentialsStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      credentials: credentials,
      dummyCredentials: dummyCredentials,
    );
    return credentialsState;
  }

  CredentialsState copyWith({
    required CredentialsStatus status,
    MessageHandler? messageHandler,
    List<CredentialModel>? credentials,
    Map<CredentialCategory, List<DiscoverDummyCredential>>? dummyCredentials,
  }) {
    final credentialsState = CredentialsState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      credentials: credentials ?? this.credentials,
      dummyCredentials: dummyCredentials ?? this.dummyCredentials,
    );
    return credentialsState;
  }

  Map<String, dynamic> toJson() => _$CredentialsStateToJson(this);

  @override
  List<Object?> get props => [status, message, credentials, dummyCredentials];
}
