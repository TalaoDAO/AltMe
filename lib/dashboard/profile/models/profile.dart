import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/models/profile_setting.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileModel extends Equatable {
  const ProfileModel({
    required this.polygonIdNetwork,
    required this.walletType,
    required this.walletProtectionType,
    required this.isDeveloperMode,
    required this.profileType,
    required this.profileSetting,
    this.enterpriseWalletName,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.empty() => ProfileModel(
        polygonIdNetwork: PolygonIdNetwork.PolygonMainnet,
        walletType: WalletType.personal,
        walletProtectionType: WalletProtectionType.pinCode,
        isDeveloperMode: false,
        profileType: ProfileType.custom,
        profileSetting: ProfileSetting.initial(),
      );

  factory ProfileModel.ebsiV3({
    required PolygonIdNetwork polygonIdNetwork,
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) =>
      ProfileModel(
        enterpriseWalletName: enterpriseWalletName,
        polygonIdNetwork: polygonIdNetwork,
        walletType: walletType,
        walletProtectionType: walletProtectionType,
        isDeveloperMode: isDeveloperMode,
        profileType: ProfileType.ebsiV3,
        profileSetting: ProfileSetting(
          blockchainOptions: BlockchainOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          discoverCardsOptions: const DiscoverCardsOptions(
            displayDefi: false,
            displayHumanity: false,
            displayHumanityJwt: false,
            displayOver13: false,
            displayOver15: false,
            displayOver18: false,
            displayOver18Jwt: false,
            displayOver21: false,
            displayOver50: false,
            displayChainborn: false,
            displayTezotopia: false,
            displayVerifiableId: false,
            displayVerifiableIdJwt: true,
            displayOver65: false,
            displayEmailPass: false,
            displayEmailPassJwt: false,
            displayPhonePass: false,
            displayPhonePassJwt: false,
            displayAgeRange: false,
            displayGender: false,
            displayExternalIssuer: [],
          ),
          selfSovereignIdentityOptions: SelfSovereignIdentityOptions(
            displayManageDecentralizedId: true,
            customOidc4vcProfile: CustomOidc4VcProfile(
              clientAuthentication: ClientAuthentication.clientId,
              credentialManifestSupport: false,
              cryptoHolderBinding: true,
              defaultDid: Parameters.didKeyTypeForEbsiV3,
              oidc4vciDraft: OIDC4VCIDraftType.draft11,
              oidc4vpDraft: OIDC4VPDraftType.draft10,
              scope: false,
              securityLevel: true,
              proofHeader: ProofHeaderType.kid,
              siopv2Draft: SIOPV2DraftType.draft12,
              clientType: ClientType.did,
              clientId: clientId,
              clientSecret: clientSecret,
              vcFormatType: VCFormatType.jwtVc,
              proofType: ProofType.jwt,
            ),
          ),
          settingsMenu: SettingsMenu.initial(),
          version: '',
          walletSecurityOptions: const WalletSecurityOptions(
            confirmSecurityVerifierAccess: true,
            displaySecurityAdvancedSettings: true,
            secureSecurityAuthenticationWithPinCode: true,
            verifySecurityIssuerWebsiteIdentity: true,
          ),
        ),
      );

  factory ProfileModel.ebsiV4({
    required PolygonIdNetwork polygonIdNetwork,
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) =>
      ProfileModel(
        enterpriseWalletName: enterpriseWalletName,
        polygonIdNetwork: polygonIdNetwork,
        walletType: walletType,
        walletProtectionType: walletProtectionType,
        isDeveloperMode: isDeveloperMode,
        profileType: ProfileType.ebsiV4,
        profileSetting: ProfileSetting(
          blockchainOptions: BlockchainOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          discoverCardsOptions: const DiscoverCardsOptions(
            displayDefi: false,
            displayHumanity: false,
            displayHumanityJwt: false,
            displayOver13: false,
            displayOver15: false,
            displayOver18: false,
            displayOver18Jwt: false,
            displayOver21: false,
            displayOver50: false,
            displayChainborn: false,
            displayTezotopia: false,
            displayVerifiableId: false,
            displayVerifiableIdJwt: true,
            displayOver65: false,
            displayEmailPass: false,
            displayEmailPassJwt: false,
            displayPhonePass: false,
            displayPhonePassJwt: false,
            displayAgeRange: false,
            displayGender: false,
            displayExternalIssuer: [],
          ),
          selfSovereignIdentityOptions: SelfSovereignIdentityOptions(
            displayManageDecentralizedId: true,
            customOidc4vcProfile: CustomOidc4VcProfile(
              clientAuthentication: ClientAuthentication.clientId,
              credentialManifestSupport: false,
              cryptoHolderBinding: true,
              defaultDid: Parameters.didKeyTypeForEbsiV3,
              oidc4vciDraft: OIDC4VCIDraftType.draft13,
              oidc4vpDraft: OIDC4VPDraftType.draft10,
              scope: false,
              securityLevel: true,
              proofHeader: ProofHeaderType.kid,
              siopv2Draft: SIOPV2DraftType.draft12,
              clientType: ClientType.did,
              clientId: clientId,
              clientSecret: clientSecret,
              vcFormatType: VCFormatType.auto,
              proofType: ProofType.jwt,
            ),
          ),
          settingsMenu: SettingsMenu.initial(),
          version: '',
          walletSecurityOptions: const WalletSecurityOptions(
            confirmSecurityVerifierAccess: true,
            displaySecurityAdvancedSettings: true,
            secureSecurityAuthenticationWithPinCode: true,
            verifySecurityIssuerWebsiteIdentity: true,
          ),
        ),
      );

  factory ProfileModel.defaultOne({
    required PolygonIdNetwork polygonIdNetwork,
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) =>
      ProfileModel(
        enterpriseWalletName: enterpriseWalletName,
        polygonIdNetwork: polygonIdNetwork,
        walletType: walletType,
        walletProtectionType: walletProtectionType,
        isDeveloperMode: isDeveloperMode,
        profileType: ProfileType.defaultOne,
        profileSetting: ProfileSetting(
          blockchainOptions: BlockchainOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          discoverCardsOptions: const DiscoverCardsOptions(
            displayDefi: false,
            displayHumanity: false,
            displayOver13: false,
            displayOver15: false,
            displayOver18: true,
            displayOver21: false,
            displayOver50: false,
            displayVerifiableId: true,
            displayVerifiableIdSdJwt: false,
            displayOver65: false,
            displayAgeRange: false,
            displayGender: false,
            displayEmailPass: true,
            displayEmailPassJwt: false,
            displayEmailPassSdJwt: false,
            displayPhonePass: true,
            displayPhonePassJwt: false,
            displayExternalIssuer: [],
          ),
          selfSovereignIdentityOptions: SelfSovereignIdentityOptions(
            displayManageDecentralizedId: true,
            customOidc4vcProfile: CustomOidc4VcProfile(
              clientAuthentication: ClientAuthentication.clientId,
              credentialManifestSupport: false,
              cryptoHolderBinding: true,
              defaultDid: Parameters.didKeyTypeForDefault,
              oidc4vciDraft: OIDC4VCIDraftType.draft13,
              oidc4vpDraft: OIDC4VPDraftType.draft18,
              scope: false,
              securityLevel: false,
              proofHeader: ProofHeaderType.kid, // N/A
              siopv2Draft: SIOPV2DraftType.draft12,
              clientType: ClientType.did,
              clientId: clientId,
              clientSecret: clientSecret,
              vcFormatType: VCFormatType.auto,
              proofType: ProofType.ldpVp,
            ),
          ),
          settingsMenu: SettingsMenu.initial(),
          version: '',
          walletSecurityOptions: const WalletSecurityOptions(
            confirmSecurityVerifierAccess: true,
            displaySecurityAdvancedSettings: true,
            secureSecurityAuthenticationWithPinCode: true,
            verifySecurityIssuerWebsiteIdentity: true,
          ),
        ),
      );

  // factory ProfileModel.diipv2point1({
  //   required PolygonIdNetwork polygonIdNetwork,
  //   required WalletType walletType,
  //   required WalletProtectionType walletProtectionType,
  //   required bool isDeveloperMode,
  //   required String? clientId,
  //   required String? clientSecret,
  //   String? enterpriseWalletName,
  // }) =>
  //     ProfileModel(
  //       enterpriseWalletName: enterpriseWalletName,
  //       polygonIdNetwork: polygonIdNetwork,
  //       walletType: walletType,
  //       walletProtectionType: walletProtectionType,
  //       isDeveloperMode: isDeveloperMode,
  //       profileType: ProfileType.diipv2point1,
  //       profileSetting: ProfileSetting(
  //         blockchainOptions: BlockchainOptions.initial(),
  //         generalOptions: GeneralOptions.empty(),
  //         helpCenterOptions: HelpCenterOptions.initial(),
  //         discoverCardsOptions: const DiscoverCardsOptions(
  //           displayDefi: false,
  //           displayHumanity: false,
  //           displayHumanityJwt: false,
  //           displayOver13: false,
  //           displayOver15: false,
  //           displayOver18: false,
  //           displayOver18Jwt: true,
  //           displayOver21: false,
  //           displayOver50: false,
  //           displayChainborn: false,
  //           displayTezotopia: false,
  //           displayVerifiableId: true,
  //           displayVerifiableIdJwt: true,
  //           displayOver65: false,
  //           displayEmailPass: true,
  //           displayEmailPassJwt: true,
  //           displayPhonePass: false,
  //           displayPhonePassJwt: true,
  //           displayAgeRange: false,
  //           displayGender: false,
  //           displayExternalIssuer: [],
  //         ),
  //         selfSovereignIdentityOptions: SelfSovereignIdentityOptions(
  //           displayManageDecentralizedId: true,
  //           customOidc4vcProfile: CustomOidc4VcProfile(
  //             clientAuthentication: ClientAuthentication.clientId,
  //             credentialManifestSupport: false,
  //             cryptoHolderBinding: true,
  //             defaultDid: Parameters.didKeyTypeForDutch,
  //             oidc4vciDraft: OIDC4VCIDraftType.draft13,
  //             oidc4vpDraft: OIDC4VPDraftType.draft10,
  //             scope: true,
  //             securityLevel: true,
  //             proofHeader: ProofHeaderType.kid,
  //             siopv2Draft: SIOPV2DraftType.draft12,
  //             clientType: ClientType.did,
  //             clientId: clientId,
  //             clientSecret: clientSecret,
  //             vcFormatType: VCFormatType.jwtVcJson,
  //             proofType: ProofType.jwt,
  //           ),
  //         ),
  //         settingsMenu: SettingsMenu.initial(),
  //         version: '',
  //         walletSecurityOptions: const WalletSecurityOptions(
  //           confirmSecurityVerifierAccess: true,
  //           displaySecurityAdvancedSettings: true,
  //           secureSecurityAuthenticationWithPinCode: true,
  //           verifySecurityIssuerWebsiteIdentity: true,
  //         ),
  //       ),
  //     );

  factory ProfileModel.diipv3({
    required PolygonIdNetwork polygonIdNetwork,
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) =>
      ProfileModel(
        enterpriseWalletName: enterpriseWalletName,
        polygonIdNetwork: polygonIdNetwork,
        walletType: walletType,
        walletProtectionType: walletProtectionType,
        isDeveloperMode: isDeveloperMode,
        profileType: ProfileType.diipv3,
        profileSetting: ProfileSetting(
          blockchainOptions: BlockchainOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          discoverCardsOptions: const DiscoverCardsOptions(
            displayDefi: false,
            displayHumanity: false,
            displayHumanityJwt: false,
            displayOver13: false,
            displayOver15: false,
            displayOver18: false,
            displayOver18Jwt: false,
            displayOver18SdJwt: true,
            displayOver21: false,
            displayOver50: false,
            displayChainborn: false,
            displayTezotopia: false,
            displayVerifiableId: false,
            displayVerifiableIdJwt: false,
            displayOver65: false,
            displayEmailPass: false,
            displayEmailPassJwt: false,
            displayPhonePass: false,
            displayPhonePassJwt: false,
            displayAgeRange: false,
            displayGender: false,
            displayExternalIssuer: [],
            displayEmailPassSdJwt: true,
            displayVerifiableIdSdJwt: true,
          ),
          selfSovereignIdentityOptions: SelfSovereignIdentityOptions(
            displayManageDecentralizedId: true,
            customOidc4vcProfile: CustomOidc4VcProfile(
              clientAuthentication: ClientAuthentication.clientId,
              credentialManifestSupport: true,
              cryptoHolderBinding: true,
              defaultDid: Parameters.didKeyTypeForOwfBaselineProfile,
              oidc4vciDraft: OIDC4VCIDraftType.draft13,
              oidc4vpDraft: OIDC4VPDraftType.draft18,
              scope: true,
              securityLevel: true,
              proofHeader: ProofHeaderType.kid,
              siopv2Draft: SIOPV2DraftType.draft12,
              clientType: ClientType.did,
              clientId: clientId,
              clientSecret: clientSecret,
              vcFormatType: VCFormatType.auto,
              proofType: ProofType.jwt,
            ),
          ),
          settingsMenu: SettingsMenu.initial(),
          version: '',
          walletSecurityOptions: const WalletSecurityOptions(
            confirmSecurityVerifierAccess: true,
            displaySecurityAdvancedSettings: true,
            secureSecurityAuthenticationWithPinCode: true,
            verifySecurityIssuerWebsiteIdentity: true,
          ),
        ),
      );

  final PolygonIdNetwork polygonIdNetwork;
  final WalletType walletType;
  final WalletProtectionType walletProtectionType;
  final bool isDeveloperMode;
  final ProfileSetting profileSetting;
  final ProfileType profileType;
  final String? enterpriseWalletName;

  @override
  List<Object?> get props => [
        polygonIdNetwork,
        walletType,
        walletProtectionType,
        isDeveloperMode,
        profileType,
        enterpriseWalletName,
        profileSetting,
      ];

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    PolygonIdNetwork? polygonIdNetwork,
    WalletType? walletType,
    WalletProtectionType? walletProtectionType,
    bool? isDeveloperMode,
    ProfileType? profileType,
    ProfileSetting? profileSetting,
    String? enterpriseWalletName,
  }) {
    return ProfileModel(
      polygonIdNetwork: polygonIdNetwork ?? this.polygonIdNetwork,
      walletType: walletType ?? this.walletType,
      walletProtectionType: walletProtectionType ?? this.walletProtectionType,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      profileType: profileType ?? this.profileType,
      profileSetting: profileSetting ?? this.profileSetting,
      enterpriseWalletName: enterpriseWalletName ?? this.enterpriseWalletName,
    );
  }
}
