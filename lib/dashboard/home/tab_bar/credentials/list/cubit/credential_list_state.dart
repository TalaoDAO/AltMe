part of 'credential_list_cubit.dart';

@JsonSerializable()
class CredentialListState extends Equatable {
  CredentialListState({
    this.status = AppStatus.init,
    this.message,
    List<HomeCredential>? gamingCredentials,
    List<HomeCredential>? communityCredentials,
    List<HomeCredential>? identityCredentials,
    List<HomeCredential>? proofOfOwnershipCredentials,
    List<HomeCredential>? othersCredentials,
    List<CredentialSubjectType>? gamingCategories,
    List<CredentialSubjectType>? communityCategories,
    List<CredentialSubjectType>? identityCategories,
  })  : gamingCredentials = gamingCredentials ?? [],
        communityCredentials = communityCredentials ?? [],
        identityCredentials = identityCredentials ?? [],
        proofOfOwnershipCredentials = proofOfOwnershipCredentials ?? [],
        othersCredentials = othersCredentials ?? [],
        gamingCategories = gamingCategories ??
            [
              CredentialSubjectType.tezVoucher,
            ],
        communityCategories = communityCategories ??
            [
              // CredentialSubjectType.talaoCommunityCard
            ],
        identityCategories = identityCategories ??
            [
              CredentialSubjectType.emailPass,
              CredentialSubjectType.over18,
              CredentialSubjectType.identityCard,
            ];

  factory CredentialListState.fromJson(Map<String, dynamic> json) =>
      _$CredentialListStateFromJson(json);

  final AppStatus status;
  final List<HomeCredential> gamingCredentials;
  final List<HomeCredential> communityCredentials;
  final List<HomeCredential> identityCredentials;
  final List<HomeCredential> proofOfOwnershipCredentials;
  final List<HomeCredential> othersCredentials;
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
      proofOfOwnershipCredentials: proofOfOwnershipCredentials,
      othersCredentials: othersCredentials,
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
      proofOfOwnershipCredentials: proofOfOwnershipCredentials,
      othersCredentials: othersCredentials,
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
      proofOfOwnershipCredentials: proofOfOwnershipCredentials,
      othersCredentials: othersCredentials,
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
      proofOfOwnershipCredentials: proofOfOwnershipCredentials,
      othersCredentials: othersCredentials,
      gamingCategories: gamingCategories,
      communityCategories: communityCategories,
      identityCategories: identityCategories,
    );
  }

  CredentialListState populate({
    List<HomeCredential>? gamingCredentials,
    List<HomeCredential>? communityCredentials,
    List<HomeCredential>? identityCredentials,
    List<HomeCredential>? proofOfOwnershipCredentials,
    List<HomeCredential>? othersCredentials,
    List<CredentialSubjectType>? gamingCategories,
    List<CredentialSubjectType>? communityCategories,
    List<CredentialSubjectType>? identityCategories,
  }) {
    return CredentialListState(
      status: AppStatus.populate,
      gamingCredentials: gamingCredentials ?? this.gamingCredentials,
      communityCredentials: communityCredentials ?? this.communityCredentials,
      identityCredentials: identityCredentials ?? this.identityCredentials,
      proofOfOwnershipCredentials:
          proofOfOwnershipCredentials ?? this.proofOfOwnershipCredentials,
      othersCredentials: othersCredentials ?? this.othersCredentials,
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
      proofOfOwnershipCredentials: proofOfOwnershipCredentials,
      othersCredentials: othersCredentials,
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
        proofOfOwnershipCredentials,
        othersCredentials,
        message,
        gamingCategories,
        communityCategories,
        identityCategories,
      ];
}
