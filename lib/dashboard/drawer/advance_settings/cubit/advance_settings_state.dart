part of 'advance_settings_cubit.dart';

@JsonSerializable()
class AdvanceSettingsState extends Equatable {
  const AdvanceSettingsState({
    required this.isGamingEnabled,
    required this.isIdentityEnabled,
    required this.isProfessionalEnabled,
    required this.isBlockchainAccountsEnabled,
    required this.isEducationEnabled,
    required this.isPassEnabled,
    required this.isSocialMediaEnabled,
    required this.isCommunityEnabled,
    required this.isOtherEnabled,
    required this.isFinanceEnabled,
    required this.isHumanityProofEnabled,
    required this.isWalletIntegrityEnabled,
  });

  factory AdvanceSettingsState.fromJson(Map<String, dynamic> json) =>
      _$AdvanceSettingsStateFromJson(json);

  final bool isGamingEnabled;
  final bool isIdentityEnabled;
  final bool isProfessionalEnabled;
  final bool isBlockchainAccountsEnabled;
  final bool isEducationEnabled;
  final bool isPassEnabled;
  final bool isSocialMediaEnabled;
  final bool isCommunityEnabled;
  final bool isOtherEnabled;
  final bool isFinanceEnabled;
  final bool isHumanityProofEnabled;
  final bool isWalletIntegrityEnabled;

  Map<String, dynamic> toJson() => _$AdvanceSettingsStateToJson(this);

  Map<CredentialCategory, bool> get categoryIsEnabledMap {
    return {
      CredentialCategory.advantagesCards: isGamingEnabled,
      CredentialCategory.identityCards: isIdentityEnabled,
      CredentialCategory.professionalCards: isProfessionalEnabled,
      CredentialCategory.blockchainAccountsCards: isBlockchainAccountsEnabled,
      CredentialCategory.educationCards: isEducationEnabled,
      CredentialCategory.contactInfoCredentials: isCommunityEnabled,
      CredentialCategory.othersCards: isOtherEnabled,
      CredentialCategory.financeCards: isFinanceEnabled,
      CredentialCategory.humanityProofCards: isHumanityProofEnabled,
      CredentialCategory.socialMediaCards: isSocialMediaEnabled,
      CredentialCategory.walletIntegrity: isWalletIntegrityEnabled,
    };
  }

  AdvanceSettingsState copyWith({
    bool? isGamingEnabled,
    bool? isIdentityEnabled,
    bool? isProfessionalEnabled,
    bool? isBlockchainAccountsEnabled,
    bool? isEducationEnabled,
    bool? isPassEnabled,
    bool? isSocialMediaEnabled,
    bool? isCommunityEnabled,
    bool? isOtherEnabled,
    bool? isFinanceEnabled,
    bool? isHumanityProofEnabled,
    bool? isWalletIntegrityEnabled,
  }) {
    return AdvanceSettingsState(
      isGamingEnabled: isGamingEnabled ?? this.isGamingEnabled,
      isIdentityEnabled: isIdentityEnabled ?? this.isIdentityEnabled,
      isProfessionalEnabled:
          isProfessionalEnabled ?? this.isProfessionalEnabled,
      isBlockchainAccountsEnabled:
          isBlockchainAccountsEnabled ?? this.isBlockchainAccountsEnabled,
      isEducationEnabled: isEducationEnabled ?? this.isEducationEnabled,
      isPassEnabled: isPassEnabled ?? this.isPassEnabled,
      isSocialMediaEnabled: isSocialMediaEnabled ?? this.isSocialMediaEnabled,
      isCommunityEnabled: isCommunityEnabled ?? this.isCommunityEnabled,
      isOtherEnabled: isOtherEnabled ?? this.isOtherEnabled,
      isFinanceEnabled: isFinanceEnabled ?? this.isFinanceEnabled,
      isHumanityProofEnabled:
          isHumanityProofEnabled ?? this.isHumanityProofEnabled,
      isWalletIntegrityEnabled:
          isWalletIntegrityEnabled ?? this.isWalletIntegrityEnabled,
    );
  }

  @override
  List<Object?> get props => [
    isGamingEnabled,
    isIdentityEnabled,
    isProfessionalEnabled,
    isBlockchainAccountsEnabled,
    isEducationEnabled,
    isPassEnabled,
    isSocialMediaEnabled,
    isCommunityEnabled,
    isOtherEnabled,
    isFinanceEnabled,
    isHumanityProofEnabled,
    isWalletIntegrityEnabled,
  ];
}
