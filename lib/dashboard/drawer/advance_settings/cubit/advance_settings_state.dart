part of 'advance_settings_cubit.dart';

@JsonSerializable()
class AdvanceSettingsState extends Equatable {
  const AdvanceSettingsState({
    required this.isGamingEnabled,
    required this.isIdentityEnabled,
    required this.isBlockchainAccountsEnabled,
    required this.isEducationEnabled,
    required this.isPassEnabled,
    required this.isSocialMediaEnabled,
    required this.isCommunityEnabled,
    required this.isOtherEnabled,
  });

  factory AdvanceSettingsState.fromJson(Map<String, dynamic> json) =>
      _$AdvanceSettingsStateFromJson(json);

  final bool isGamingEnabled;
  final bool isIdentityEnabled;
  final bool isBlockchainAccountsEnabled;
  final bool isEducationEnabled;
  final bool isPassEnabled;
  final bool isSocialMediaEnabled;
  final bool isCommunityEnabled;
  final bool isOtherEnabled;

  Map<String, dynamic> toJson() => _$AdvanceSettingsStateToJson(this);

  Map<CredentialCategory, bool> get categoryIsEnabledMap {
    return {
      CredentialCategory.gamingCards: isGamingEnabled,
      CredentialCategory.identityCards: isIdentityEnabled,
      CredentialCategory.blockchainAccountsCards: isBlockchainAccountsEnabled,
      CredentialCategory.educationCards: isEducationEnabled,
      CredentialCategory.passCards: isPassEnabled,
      CredentialCategory.communityCards: isCommunityEnabled,
      CredentialCategory.othersCards: isOtherEnabled,
    };
  }

  AdvanceSettingsState copyWith({
    bool? isGamingEnabled,
    bool? isIdentityEnabled,
    bool? isBlockchainAccountsEnabled,
    bool? isEducationEnabled,
    bool? isPassEnabled,
    bool? isSocialMediaEnabled,
    bool? isCommunityEnabled,
    bool? isOtherEnabled,
  }) {
    return AdvanceSettingsState(
      isGamingEnabled: isGamingEnabled ?? this.isGamingEnabled,
      isIdentityEnabled: isIdentityEnabled ?? this.isIdentityEnabled,
      isBlockchainAccountsEnabled:
          isBlockchainAccountsEnabled ?? this.isBlockchainAccountsEnabled,
      isEducationEnabled: isEducationEnabled ?? this.isEducationEnabled,
      isPassEnabled: isPassEnabled ?? this.isPassEnabled,
      isSocialMediaEnabled: isSocialMediaEnabled ?? this.isSocialMediaEnabled,
      isCommunityEnabled: isCommunityEnabled ?? this.isCommunityEnabled,
      isOtherEnabled: isOtherEnabled ?? this.isOtherEnabled,
    );
  }

  @override
  List<Object?> get props => [
        isGamingEnabled,
        isIdentityEnabled,
        isBlockchainAccountsEnabled,
        isEducationEnabled,
        isPassEnabled,
        isSocialMediaEnabled,
        isCommunityEnabled,
        isOtherEnabled,
      ];
}
