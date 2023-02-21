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
    this.educationCredentials = const [],
    this.passCredentials = const [],
    this.othersCredentials = const [],
    this.myProfessionalCredentials = const [],
    List<CredentialSubjectType>? gamingCategories,
    List<CredentialSubjectType>? communityCategories,
    List<CredentialSubjectType>? identityCategories,
    List<CredentialSubjectType>? myProfessionalCategories,
  })  : gamingCategories =
            gamingCategories ?? List.from(DiscoverList.gamingCategories),
        communityCategories =
            communityCategories ?? List.from(DiscoverList.communityCategories),
        identityCategories =
            identityCategories ?? List.from(DiscoverList.identityCategories),
        myProfessionalCategories = myProfessionalCategories ??
            List.from(DiscoverList.myProfessionalCategories);

  factory CredentialListState.fromJson(Map<String, dynamic> json) =>
      _$CredentialListStateFromJson(json);

  final AppStatus status;
  final List<HomeCredential> gamingCredentials;
  final List<HomeCredential> communityCredentials;
  final List<HomeCredential> identityCredentials;
  final List<HomeCredential> blockchainAccountsCredentials;
  final List<HomeCredential> educationCredentials;
  final List<HomeCredential> passCredentials;
  final List<HomeCredential> othersCredentials;
  final List<HomeCredential> myProfessionalCredentials;
  final List<CredentialSubjectType> gamingCategories;
  final List<CredentialSubjectType> communityCategories;
  final List<CredentialSubjectType> identityCategories;
  final List<CredentialSubjectType> myProfessionalCategories;
  final StateMessage? message;

  CredentialListState fetching() {
    return CredentialListState(
      status: AppStatus.fetching,
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      blockchainAccountsCredentials: blockchainAccountsCredentials,
      educationCredentials: educationCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
      myProfessionalCategories: myProfessionalCategories,
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
      educationCredentials: educationCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
      myProfessionalCategories: myProfessionalCategories,
    );
  }

  CredentialListState loading() {
    return CredentialListState(
      status: AppStatus.loading,
      gamingCredentials: gamingCredentials,
      communityCredentials: communityCredentials,
      identityCredentials: identityCredentials,
      blockchainAccountsCredentials: blockchainAccountsCredentials,
      educationCredentials: educationCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
      myProfessionalCategories: myProfessionalCategories,
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
      educationCredentials: educationCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
      myProfessionalCategories: myProfessionalCategories,
    );
  }

  CredentialListState populate({
    List<HomeCredential>? gamingCredentials,
    List<HomeCredential>? communityCredentials,
    List<HomeCredential>? identityCredentials,
    List<HomeCredential>? blockchainAccountsCredentials,
    List<HomeCredential>? educationCredentials,
    List<HomeCredential>? passCredentials,
    List<HomeCredential>? othersCredentials,
    List<HomeCredential>? myProfessionalCredentials,
    List<CredentialSubjectType>? gamingCategories,
    List<CredentialSubjectType>? communityCategories,
    List<CredentialSubjectType>? identityCategories,
    List<CredentialSubjectType>? myProfessionalCategories,
  }) {
    return CredentialListState(
      status: AppStatus.populate,
      gamingCredentials: gamingCredentials ?? this.gamingCredentials,
      communityCredentials: communityCredentials ?? this.communityCredentials,
      identityCredentials: identityCredentials ?? this.identityCredentials,
      blockchainAccountsCredentials:
          blockchainAccountsCredentials ?? this.blockchainAccountsCredentials,
      educationCredentials: educationCredentials ?? this.educationCredentials,
      passCredentials: passCredentials ?? this.passCredentials,
      othersCredentials: othersCredentials ?? this.othersCredentials,
      myProfessionalCredentials:
          myProfessionalCredentials ?? this.myProfessionalCredentials,
      gamingCategories: gamingCategories ?? this.gamingCategories,
      communityCategories: communityCategories ?? this.communityCategories,
      identityCategories: identityCategories ?? this.identityCategories,
      myProfessionalCategories:
          myProfessionalCategories ?? this.myProfessionalCategories,
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
      educationCredentials: educationCredentials,
      passCredentials: passCredentials,
      othersCredentials: othersCredentials,
      myProfessionalCredentials: myProfessionalCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
      myProfessionalCategories: myProfessionalCategories,
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
        educationCredentials,
        passCredentials,
        othersCredentials,
        message,
        gamingCategories,
        communityCategories,
        identityCategories,
        myProfessionalCredentials,
        myProfessionalCategories
      ];
}
