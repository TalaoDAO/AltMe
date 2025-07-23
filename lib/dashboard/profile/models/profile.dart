import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/models/profile_setting.dart';
import 'package:altme/oidc4vc/model/oidc4vci_stack.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

part 'profile.g.dart';

@JsonSerializable()
// ignore: must_be_immutable
class ProfileModel extends Equatable {
  ProfileModel({
    required this.walletType,
    required this.walletProtectionType,
    required this.isDeveloperMode,
    required this.profileType,
    required this.profileSetting,
    this.enterpriseWalletName,
    this.oidc4VCIStack,
  }) {
    oidc4VCIStack ??= Oidc4VCIStack.initial();
  }

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.empty() => ProfileModel(
        walletType: WalletType.personal,
        walletProtectionType: WalletProtectionType.pinCode,
        isDeveloperMode: false,
        profileType: ProfileType.custom,
        profileSetting: ProfileSetting.initial(),
      );

  factory ProfileModel.ebsiV3({
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) =>
      ProfileModel(
        enterpriseWalletName: enterpriseWalletName,
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
              formatsSupported: const [VCFormatType.jwtVc],
              displayMode: false,
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

  // factory ProfileModel.ebsiV4({
  //   required WalletType walletType,
  //   required WalletProtectionType walletProtectionType,
  //   required bool isDeveloperMode,
  //   required String? clientId,
  //   required String? clientSecret,
  //   String? enterpriseWalletName,
  // }) =>
  //     ProfileModel(
  //       enterpriseWalletName: enterpriseWalletName,
  //       walletType: walletType,
  //       walletProtectionType: walletProtectionType,
  //       isDeveloperMode: isDeveloperMode,
  //       profileType: ProfileType.ebsiV4,
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
  //           displayOver18Jwt: false,
  //           displayOver21: false,
  //           displayOver50: false,
  //           displayChainborn: false,
  //           displayTezotopia: false,
  //           displayVerifiableId: false,
  //           displayVerifiableIdJwt: false,
  //           displayOver65: false,
  //           displayEmailPass: false,
  //           displayEmailPassJwt: false,
  //           displayPhonePass: false,
  //           displayPhonePassJwt: false,
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
  //             defaultDid: Parameters.didKeyTypeForEbsiV3,
  //             oidc4vciDraft: OIDC4VCIDraftType.draft13,
  //             oidc4vpDraft: OIDC4VPDraftType.draft10,
  //             scope: false,
  //             securityLevel: true,
  //             proofHeader: ProofHeaderType.kid,
  //             siopv2Draft: SIOPV2DraftType.draft12,
  //             clientType: ClientType.did,
  //             clientId: clientId,
  //             clientSecret: clientSecret,
  //             vcFormatType: VCFormatType.auto,
  //             proofType: ProofType.jwt,
  //             formatsSupported: const [
  //               VCFormatType.jwtVcJson,
  //               VCFormatType.jwtVcJsonLd,
  //               VCFormatType.vcSdJWT,
  //             ],
  //             displayMode: false,
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

  factory ProfileModel.defaultOne({
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) =>
      ProfileModel(
        enterpriseWalletName: enterpriseWalletName,
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
              oidc4vpDraft: OIDC4VPDraftType.draft20,
              scope: false,
              securityLevel: false,
              proofHeader: ProofHeaderType.kid, // N/A
              siopv2Draft: SIOPV2DraftType.draft12,
              clientType: ClientType.did,
              clientId: clientId,
              clientSecret: clientSecret,
              vcFormatType: VCFormatType.auto,
              proofType: ProofType.jwt,
              formatsSupported: const [
                VCFormatType.jwtVcJson,
                VCFormatType.jwtVcJsonLd,
                VCFormatType.vcSdJWT,
                VCFormatType.ldpVc,
              ],
              displayMode: false,
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

  factory ProfileModel.diipv3({
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) =>
      ProfileModel(
        enterpriseWalletName: enterpriseWalletName,
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
            displayPhonePassSdJwt: true,
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
              oidc4vpDraft: OIDC4VPDraftType.draft20,
              scope: true,
              securityLevel: true,
              proofHeader: ProofHeaderType.kid,
              siopv2Draft: SIOPV2DraftType.draft12,
              clientType: ClientType.did,
              clientId: clientId,
              clientSecret: clientSecret,
              vcFormatType: VCFormatType.auto,

              /// pas ldp_vc
              proofType: ProofType.jwt,
              formatsSupported: const [
                VCFormatType.jwtVcJson,
                VCFormatType.jwtVcJsonLd,
                VCFormatType.vcSdJWT,
              ],
              displayMode: false,
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

  factory ProfileModel.diipv4({
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) =>
      ProfileModel(
        enterpriseWalletName: enterpriseWalletName,
        walletType: walletType,
        walletProtectionType: walletProtectionType,
        isDeveloperMode: isDeveloperMode,
        profileType: ProfileType.diipv4,
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
            displayPhonePassSdJwt: true,
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
              oidc4vciDraft: OIDC4VCIDraftType.draft15,
              oidc4vpDraft: OIDC4VPDraftType.draft28,
              scope: true,
              securityLevel: true,
              proofHeader: ProofHeaderType.kid,
              siopv2Draft: SIOPV2DraftType.draft12,
              clientType: ClientType.did,
              clientId: clientId,
              clientSecret: clientSecret,
              vcFormatType: VCFormatType.auto,

              /// pas ldp_vc
              proofType: ProofType.jwt,
              formatsSupported: const [
                VCFormatType.jwtVcJson,
                VCFormatType.jwtVcJsonLd,
                VCFormatType.dcSdJWT,
              ],
              displayMode: false,
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

  final WalletType walletType;
  final WalletProtectionType walletProtectionType;
  final bool isDeveloperMode;
  final ProfileSetting profileSetting;
  final ProfileType profileType;
  final String? enterpriseWalletName;
  late Oidc4VCIStack? oidc4VCIStack;

  @override
  List<Object?> get props => [
        walletType,
        walletProtectionType,
        isDeveloperMode,
        profileType,
        enterpriseWalletName,
        profileSetting,
        oidc4VCIStack,
      ];

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    WalletType? walletType,
    WalletProtectionType? walletProtectionType,
    bool? isDeveloperMode,
    ProfileType? profileType,
    ProfileSetting? profileSetting,
    String? enterpriseWalletName,
    Oidc4VCIStack? oidc4VCIStack,
  }) {
    return ProfileModel(
      walletType: walletType ?? this.walletType,
      walletProtectionType: walletProtectionType ?? this.walletProtectionType,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      profileType: profileType ?? this.profileType,
      profileSetting: profileSetting ?? this.profileSetting,
      enterpriseWalletName: enterpriseWalletName ?? this.enterpriseWalletName,
      oidc4VCIStack: oidc4VCIStack ?? this.oidc4VCIStack,
    );
  }
}
