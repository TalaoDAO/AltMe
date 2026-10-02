import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/models/profile_setting.dart';
import 'package:altme/oidc4vc/model/oidc4vci_stack.dart';
// import 'package:http/http.dart' as http;
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:trusted_list/trusted_list.dart';

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
    this.trustedList,
  }) {
    oidc4VCIStack ??= Oidc4VCIStack.initial();
  }
  // final TrustedList? trustedList;

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.empty() => ProfileModel(
    walletType: WalletType.personal,
    walletProtectionType: WalletProtectionType.pinCode,
    isDeveloperMode: false,
    profileType: ProfileType.custom,
    profileSetting: ProfileSetting.initial(),
  );

  factory ProfileModel.defaultOne({
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) => ProfileModel(
    enterpriseWalletName: enterpriseWalletName,
    walletType: walletType,
    walletProtectionType: walletProtectionType,
    isDeveloperMode: isDeveloperMode,
    profileType: ProfileType.defaultOne,
    profileSetting: ProfileSetting(
      blockchainOptions: BlockchainOptions.initial(),
      generalOptions: GeneralOptions.empty(),
      helpCenterOptions: HelpCenterOptions.initial(),
      discoverCardsOptions: DiscoverCardsOptions.none(),
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
        trustedList: false,
      ),
    ),
  );

  factory ProfileModel.diipv5({
    required WalletType walletType,
    required WalletProtectionType walletProtectionType,
    required bool isDeveloperMode,
    required String? clientId,
    required String? clientSecret,
    String? enterpriseWalletName,
  }) => ProfileModel(
    enterpriseWalletName: enterpriseWalletName,
    walletType: walletType,
    walletProtectionType: walletProtectionType,
    isDeveloperMode: isDeveloperMode,
    profileType: ProfileType.diipv5,
    profileSetting: ProfileSetting(
      blockchainOptions: BlockchainOptions.initial(),
      generalOptions: GeneralOptions.empty(),
      helpCenterOptions: HelpCenterOptions.initial(),
      discoverCardsOptions: DiscoverCardsOptions.none(),
      selfSovereignIdentityOptions: SelfSovereignIdentityOptions(
        displayManageDecentralizedId: true,
        customOidc4vcProfile: CustomOidc4VcProfile(
          pushAuthorizationRequest: false,
          statusListCache: true,
          clientAuthentication: ClientAuthentication.clientId,
          credentialManifestSupport: false,
          cryptoHolderBinding: true,
          defaultDid: DidKeyType.p256,
          dpopSupport: false,
          oidc4vciDraft: OIDC4VCIDraftType.final1,
          oidc4vpDraft: OIDC4VPDraftType.final1,
          scope: true,
          securityLevel: false,
          proofHeader: ProofHeaderType.jwk, // N/A
          siopv2Draft: SIOPV2DraftType.draft12,
          clientType: ClientType.p256JWKThumprint,
          clientId: clientId,
          clientSecret: clientSecret,
          vcFormatType: VCFormatType.ldpVc,
          proofType: ProofType.jwt,
          formatsSupported: const [
            VCFormatType.jwtVcJson,
            VCFormatType.dcSdJWT,
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
        trustedList: true,
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
  final TrustedList? trustedList;

  @override
  List<Object?> get props => [
    walletType,
    walletProtectionType,
    isDeveloperMode,
    profileType,
    enterpriseWalletName,
    profileSetting,
    oidc4VCIStack,
    trustedList,
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
    TrustedList? trustedList,
  }) {
    final profileModel = ProfileModel(
      walletType: walletType ?? this.walletType,
      walletProtectionType: walletProtectionType ?? this.walletProtectionType,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      profileType: profileType ?? this.profileType,
      profileSetting: profileSetting ?? this.profileSetting,
      enterpriseWalletName: enterpriseWalletName ?? this.enterpriseWalletName,
      oidc4VCIStack: oidc4VCIStack ?? this.oidc4VCIStack,
      trustedList: trustedList ?? this.trustedList,
    );
    return profileModel;
  }
}
