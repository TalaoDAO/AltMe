part of 'missing_credentials_cubit.dart';

@JsonSerializable()
class MissingCredentialsState extends Equatable {
  MissingCredentialsState({
    this.status = AppStatus.init,
    this.message,
    List<HomeCredential>? dummyCredentials,
  }) : dummyCredentials = dummyCredentials ?? [];

  factory MissingCredentialsState.fromJson(Map<String, dynamic> json) =>
      _$MissingCredentialsStateFromJson(json);

  final AppStatus status;
  final List<HomeCredential> dummyCredentials;
  final StateMessage? message;

  MissingCredentialsState loading({String? MissingCredentialsText}) {
    return MissingCredentialsState(
      status: AppStatus.loading,
      dummyCredentials: dummyCredentials,
    );
  }

  MissingCredentialsState error({required MessageHandler messageHandler}) {
    return MissingCredentialsState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      dummyCredentials: dummyCredentials,
    );
  }

  MissingCredentialsState copyWith({
    required AppStatus status,
    StateMessage? message,
    List<HomeCredential>? dummyCredentials,
  }) {
    return MissingCredentialsState(
      status: status,
      message: message,
      dummyCredentials: dummyCredentials ?? this.dummyCredentials,
    );
  }

  Map<String, dynamic> toJson() => _$MissingCredentialsStateToJson(this);

  @override
  List<Object?> get props => [status, message, dummyCredentials];
}
