part of 'credential_list_cubit.dart';

@JsonSerializable()
class CredentialListState extends Equatable {
  CredentialListState({
    this.status = AppStatus.init,
    this.message,
    this.gamingCredentials = const [],
    this.communityCredentials = const [],
    this.identityCredentials = const [],
    this.blockchainAccountsCredentials = const [],
    this.passCredentials = const [],
    this.othersCredentials = const [],
    this.myProfessionalCredentials = const [],
    List<CredentialSubjectType>? gamingCategories,
    List<CredentialSubjectType>? communityCategories,
    List<CredentialSubjectType>? identityCategories,
  })  : gamingCategories =
            gamingCategories ?? List.from(DiscoverList.gamingCategories),
        communityCategories =
            communityCategories ?? List.from(DiscoverList.communityCategories),
        identityCategories =
            identityCategories ?? List.from(DiscoverList.identityCategories);

  factory CredentialListState.fromJson(Map<String, dynamic> json) =>
      _$CredentialListStateFromJson(json);

  final AppStatus status;
  final List<HomeCredential> gamingCredentials;
  final List<HomeCredential> communityCredentials;
  final List<HomeCredential> identityCredentials;
  final List<HomeCredential> blockchainAccountsCredentials;
  final List<HomeCredential> passCredentials;
  final List<HomeCredential> othersCredentials;
  final List<HomeCredential> myProfessionalCredentials;
  final List<CredentialSubjectType> gamingCategories;
  final List<CredentialSubjectType> communityCategories;
  final List<CredentialSubjectType> identityCategories;
  final StateMessage? message;

  CredentialListState fetching() {
    return CredentialListState(
      status: AppStatus.fetching,
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      blockchainAccountsCredentials: blockchainAccountsCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
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
      blockchainAccountsCredentials: blockchainAccountsCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
    );
  }

  CredentialListState loading() {
    return CredentialListState(
      status: AppStatus.loading,
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      blockchainAccountsCredentials: blockchainAccountsCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
    );
  }

  CredentialListState error({required MessageHandler messageHandler}) {
    return CredentialListState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      blockchainAccountsCredentials: blockchainAccountsCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
    );
  }

  CredentialListState populate({
    List<HomeCredential>? gamingCredentials,
    List<HomeCredential>? communityCredentials,
    List<HomeCredential>? identityCredentials,
    List<HomeCredential>? blockchainAccountsCredentials,
    List<HomeCredential>? passCredentials,
    List<HomeCredential>? othersCredentials,
    List<HomeCredential>? myProfessionalCredentials,
    List<CredentialSubjectType>? gamingCategories,
    List<CredentialSubjectType>? communityCategories,
    List<CredentialSubjectType>? identityCategories,
  }) {
    return CredentialListState(
      status: AppStatus.populate,
      gamingCredentials: gamingCredentials ?? this.gamingCredentials,
      communityCredentials: communityCredentials ?? this.communityCredentials,
      identityCredentials: identityCredentials ?? this.identityCredentials,
      blockchainAccountsCredentials:
          blockchainAccountsCredentials ?? this.blockchainAccountsCredentials,
      passCredentials: passCredentials ?? this.passCredentials,
      othersCredentials: othersCredentials ?? this.othersCredentials,
      myProfessionalCredentials:
          myProfessionalCredentials ?? this.myProfessionalCredentials,
      gamingCategories: gamingCategories ?? this.gamingCategories,
      communityCategories: communityCategories ?? this.communityCategories,
      identityCategories: identityCategories ?? this.identityCategories,
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
      blockchainAccountsCredentials: blockchainAccountsCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialListStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        gamingCredentials,
        communityCredentials,
        identityCredentials,
        blockchainAccountsCredentials,
        passCredentials,
        othersCredentials,
        message,
        gamingCategories,
        communityCategories,
        identityCategories,
        myProfessionalCredentials,
      ];
}
