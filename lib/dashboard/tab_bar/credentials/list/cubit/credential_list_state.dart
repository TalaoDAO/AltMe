part of 'credential_list_cubit.dart';

@JsonSerializable()
class CredentialListState extends Equatable {
  CredentialListState({
    this.status = AppStatus.init,
    this.message,
    List<HomeCredential>? gamingCredentials,
    List<HomeCredential>? communityCredentials,
    List<HomeCredential>? identityCredentials,
    List<HomeCredential>? othersCredentials,
  })  : gamingCredentials = gamingCredentials ?? [],
        communityCredentials = communityCredentials ?? [],
        identityCredentials = identityCredentials ?? [],
        othersCredentials = othersCredentials ?? [];

  factory CredentialListState.fromJson(Map<String, dynamic> json) =>
      _$CredentialListStateFromJson(json);

  final AppStatus status;
  final List<HomeCredential> gamingCredentials;
  final List<HomeCredential> communityCredentials;
  final List<HomeCredential> identityCredentials;
  final List<HomeCredential> othersCredentials;
  final StateMessage? message;

  CredentialListState fetching() {
    return CredentialListState(
      status: AppStatus.fetching,
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      othersCredentials: othersCredentials,
    );
  }

  CredentialListState errorWhileFetching({
    required MessageHandler messageHandler,
  }) {
    return CredentialListState(
      status: AppStatus.errorWhileFetching,
      message: StateMessage.error(messageHandler: messageHandler),
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      othersCredentials: othersCredentials,
    );
  }

  CredentialListState loading() {
    return CredentialListState(
      status: AppStatus.loading,
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      othersCredentials: othersCredentials,
    );
  }

  CredentialListState error({required MessageHandler messageHandler}) {
    return CredentialListState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      othersCredentials: othersCredentials,
    );
  }

  CredentialListState populate({
    List<HomeCredential>? gamingCredentials,
    List<HomeCredential>? communityCredentials,
    List<HomeCredential>? identityCredentials,
    List<HomeCredential>? othersCredentials,
  }) {
    return CredentialListState(
      status: AppStatus.populate,
      gamingCredentials: gamingCredentials ?? this.gamingCredentials,
      communityCredentials: communityCredentials ?? this.communityCredentials,
      identityCredentials: identityCredentials ?? this.identityCredentials,
      othersCredentials: othersCredentials ?? this.othersCredentials,
    );
  }

  CredentialListState success({
    required AppStatus status,
    MessageHandler? messageHandler,
  }) {
    return CredentialListState(
      status: status,
      message: messageHandler == null
          ? null
          : StateMessage.success(messageHandler: messageHandler),
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      othersCredentials: othersCredentials,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialListStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        gamingCredentials,
        communityCredentials,
        identityCredentials,
        othersCredentials,
        message
      ];
}
