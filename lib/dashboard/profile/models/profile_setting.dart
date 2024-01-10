import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';
import 'package:random_string/random_string.dart';

part 'profile_setting.g.dart';

@JsonSerializable()
class ProfileSetting extends Equatable {
  const ProfileSetting({
    this.blockchainOptions,
    this.discoverCardsOptions,
    required this.generalOptions,
    required this.helpCenterOptions,
    required this.selfSovereignIdentityOptions,
    required this.settingsMenu,
    required this.version,
    required this.walletSecurityOptions,
  });

  factory ProfileSetting.fromJson(Map<String, dynamic> json) =>
      _$ProfileSettingFromJson(json);

  factory ProfileSetting.initial() => ProfileSetting(
        blockchainOptions: BlockchainOptions.initial(),
        discoverCardsOptions: DiscoverCardsOptions.empty(),
        generalOptions: GeneralOptions.empty(),
        helpCenterOptions: HelpCenterOptions.initial(),
        selfSovereignIdentityOptions: SelfSovereignIdentityOptions.initial(),
        settingsMenu: SettingsMenu.initial(),
        version: '',
        walletSecurityOptions: WalletSecurityOptions.initial(),
      );

  final BlockchainOptions? blockchainOptions;
  final DiscoverCardsOptions? discoverCardsOptions;
  final GeneralOptions generalOptions;
  final HelpCenterOptions helpCenterOptions;
  final SelfSovereignIdentityOptions selfSovereignIdentityOptions;
  final SettingsMenu settingsMenu;
  final String version;
  final WalletSecurityOptions walletSecurityOptions;

  Map<String, dynamic> toJson() => _$ProfileSettingToJson(this);

  ProfileSetting copyWith({
    BlockchainOptions? blockchainOptions,
    DiscoverCardsOptions? discoverCardsOptions,
    GeneralOptions? generalOptions,
    HelpCenterOptions? helpCenterOptions,
    SelfSovereignIdentityOptions? selfSovereignIdentityOptions,
    SettingsMenu? settingsMenu,
    String? version,
    WalletSecurityOptions? walletSecurityOptions,
  }) =>
      ProfileSetting(
        blockchainOptions: blockchainOptions ?? this.blockchainOptions,
        discoverCardsOptions: discoverCardsOptions ?? this.discoverCardsOptions,
        generalOptions: generalOptions ?? this.generalOptions,
        helpCenterOptions: helpCenterOptions ?? this.helpCenterOptions,
        selfSovereignIdentityOptions:
            selfSovereignIdentityOptions ?? this.selfSovereignIdentityOptions,
        settingsMenu: settingsMenu ?? this.settingsMenu,
        version: version ?? this.version,
        walletSecurityOptions:
            walletSecurityOptions ?? this.walletSecurityOptions,
      );

  @override
  List<Object?> get props => [
        blockchainOptions,
        discoverCardsOptions,
        generalOptions,
        helpCenterOptions,
        selfSovereignIdentityOptions,
        settingsMenu,
        version,
        walletSecurityOptions,
      ];
}

@JsonSerializable()
class BlockchainOptions extends Equatable {
  const BlockchainOptions({
    required this.bnbSupport,
    required this.ethereumSupport,
    required this.fantomSupport,
    required this.hederaSupport,
    required this.infuraRpcNode,
    required this.polygonSupport,
    required this.tezosSupport,
    required this.tzproRpcNode,
    this.tzproApiKey,
    this.infuraApiKey,
  });

  factory BlockchainOptions.fromJson(Map<String, dynamic> json) =>
      _$BlockchainOptionsFromJson(json);

  factory BlockchainOptions.initial() => const BlockchainOptions(
        bnbSupport: true,
        ethereumSupport: true,
        fantomSupport: true,
        hederaSupport: true,
        infuraRpcNode: false,
        polygonSupport: true,
        tezosSupport: true,
        tzproRpcNode: false,
      );

  final bool bnbSupport;
  final bool ethereumSupport;
  final bool fantomSupport;
  final bool hederaSupport;
  final String? infuraApiKey;
  final bool infuraRpcNode;
  final bool polygonSupport;
  final bool tezosSupport;
  final String? tzproApiKey;
  final bool tzproRpcNode;

  Map<String, dynamic> toJson() => _$BlockchainOptionsToJson(this);

  BlockchainOptions copyWth({
    bool? bnbSupport,
    bool? ethereumSupport,
    bool? fantomSupport,
    bool? hederaSupport,
    String? infuraApiKey,
    bool? infuraRpcNode,
    bool? polygonSupport,
    bool? tezosSupport,
    String? tzproApiKey,
    bool? tzproRpcNode,
  }) {
    return BlockchainOptions(
      bnbSupport: bnbSupport ?? this.bnbSupport,
      ethereumSupport: ethereumSupport ?? this.ethereumSupport,
      fantomSupport: fantomSupport ?? this.fantomSupport,
      hederaSupport: hederaSupport ?? this.hederaSupport,
      infuraRpcNode: infuraRpcNode ?? this.infuraRpcNode,
      polygonSupport: polygonSupport ?? this.polygonSupport,
      tezosSupport: tezosSupport ?? this.tezosSupport,
      tzproRpcNode: tzproRpcNode ?? this.tzproRpcNode,
      infuraApiKey: infuraApiKey ?? this.infuraApiKey,
      tzproApiKey: tzproApiKey ?? this.tzproApiKey,
    );
  }

  @override
  List<Object?> get props => [
        bnbSupport,
        ethereumSupport,
        fantomSupport,
        hederaSupport,
        infuraApiKey,
        infuraRpcNode,
        polygonSupport,
        tezosSupport,
        tzproApiKey,
        tzproRpcNode,
      ];
}

@JsonSerializable()
class DiscoverCardsOptions extends Equatable {
  const DiscoverCardsOptions({
    required this.displayDefi,
    required this.displayHumanity,
    required this.displayOver13,
    required this.displayOver15,
    required this.displayOver18,
    required this.displayRewardsCategory,
    required this.displayVerifiableId,
  });

  factory DiscoverCardsOptions.fromJson(Map<String, dynamic> json) =>
      _$DiscoverCardsOptionsFromJson(json);

  factory DiscoverCardsOptions.empty() => const DiscoverCardsOptions(
        displayDefi: true,
        displayHumanity: true,
        displayOver13: false,
        displayOver15: true,
        displayOver18: true,
        displayRewardsCategory: true,
        displayVerifiableId: true,
      );

  final bool displayDefi;
  final bool displayHumanity;
  final bool displayOver13;
  final bool displayOver15;
  final bool displayOver18;
  final bool displayRewardsCategory;
  final bool displayVerifiableId;

  Map<String, dynamic> toJson() => _$DiscoverCardsOptionsToJson(this);

  DiscoverCardsOptions copyWith({
    bool? displayDefi,
    bool? displayHumanity,
    bool? displayOver13,
    bool? displayOver15,
    bool? displayOver18,
    bool? displayRewardsCategory,
    bool? displayVerifiableId,
  }) {
    return DiscoverCardsOptions(
      displayDefi: displayDefi ?? this.displayDefi,
      displayHumanity: displayHumanity ?? this.displayHumanity,
      displayOver13: displayOver13 ?? this.displayOver13,
      displayOver15: displayOver15 ?? this.displayOver15,
      displayOver18: displayOver18 ?? this.displayOver18,
      displayRewardsCategory:
          displayRewardsCategory ?? this.displayRewardsCategory,
      displayVerifiableId: displayVerifiableId ?? this.displayVerifiableId,
    );
  }

  @override
  List<Object?> get props => [
        displayDefi,
        displayHumanity,
        displayOver13,
        displayOver15,
        displayOver18,
        displayRewardsCategory,
        displayVerifiableId,
      ];
}

@JsonSerializable()
class GeneralOptions extends Equatable {
  const GeneralOptions({
    required this.walletType,
    required this.companyName,
    required this.companyWebsite,
    required this.companyLogo,
    required this.tagLine,
    this.splashScreenTitle,
    required this.profileName,
    required this.profileVersion,
    required this.published,
    required this.profileId,
    required this.customerPlan,
  });

  factory GeneralOptions.fromJson(Map<String, dynamic> json) =>
      _$GeneralOptionsFromJson(json);

  factory GeneralOptions.empty() => GeneralOptions(
        walletType: WalletAppType.altme,
        companyName: '',
        companyWebsite: '',
        companyLogo: '',
        tagLine: '',
        splashScreenTitle: '',
        profileName: '',
        profileVersion: '',
        published: DateTime.now(),
        profileId: '',
        customerPlan: '',
      );

  final WalletAppType walletType;
  final String companyName;
  final String companyWebsite;
  final String companyLogo;
  final String tagLine;
  final String? splashScreenTitle;
  final String profileName;
  final String profileVersion;
  final DateTime published;
  final String profileId;
  final String customerPlan;

  Map<String, dynamic> toJson() => _$GeneralOptionsToJson(this);

  GeneralOptions copyWith({
    WalletAppType? walletType,
    String? companyName,
    String? companyWebsite,
    String? companyLogo,
    String? splashScreenTitle,
    String? tagLine,
    String? profileName,
    String? profileVersion,
    DateTime? published,
    String? profileId,
    String? customerPlan,
  }) {
    return GeneralOptions(
      walletType: walletType ?? this.walletType,
      companyName: companyName ?? this.companyName,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyLogo: companyLogo ?? this.companyLogo,
      tagLine: tagLine ?? this.tagLine,
      splashScreenTitle: splashScreenTitle ?? this.splashScreenTitle,
      profileName: profileName ?? this.profileName,
      profileVersion: profileVersion ?? this.profileVersion,
      published: published ?? this.published,
      profileId: profileId ?? this.profileId,
      customerPlan: customerPlan ?? this.customerPlan,
    );
  }

  @override
  List<Object?> get props => [
        walletType,
        companyName,
        companyWebsite,
        companyLogo,
        tagLine,
        splashScreenTitle,
        profileName,
        profileVersion,
        published,
        profileId,
        customerPlan,
      ];
}

@JsonSerializable()
class HelpCenterOptions extends Equatable {
  const HelpCenterOptions({
    required this.customChatSupport,
    this.customChatSupportName,
    this.customEmail,
    required this.customEmailSupport,
    required this.displayChatSupport,
    required this.displayEmailSupport,
  });

  factory HelpCenterOptions.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterOptionsFromJson(json);

  factory HelpCenterOptions.initial() => const HelpCenterOptions(
        customChatSupport: false,
        customEmailSupport: false,
        displayChatSupport: true,
        displayEmailSupport: true,
      );

  final bool customChatSupport;
  final String? customChatSupportName;
  final String? customEmail;
  final bool customEmailSupport;
  final bool displayChatSupport;
  final bool displayEmailSupport;

  Map<String, dynamic> toJson() => _$HelpCenterOptionsToJson(this);

  HelpCenterOptions copyWith({
    bool? customChatSupport,
    String? customChatSupportName,
    String? customEmail,
    bool? customEmailSupport,
    bool? displayChatSupport,
    bool? displayEmailSupport,
  }) =>
      HelpCenterOptions(
        customChatSupport: customChatSupport ?? this.customChatSupport,
        customEmailSupport: customEmailSupport ?? this.customEmailSupport,
        displayChatSupport: displayChatSupport ?? this.displayChatSupport,
        displayEmailSupport: displayEmailSupport ?? this.displayEmailSupport,
        customChatSupportName:
            customChatSupportName ?? this.customChatSupportName,
        customEmail: customEmail ?? this.customEmail,
      );

  @override
  List<Object?> get props => [
        customChatSupport,
        customChatSupportName,
        customEmail,
        customEmailSupport,
        displayChatSupport,
        displayEmailSupport,
      ];
}

@JsonSerializable()
class SelfSovereignIdentityOptions extends Equatable {
  const SelfSovereignIdentityOptions({
    required this.customOidc4vcProfile,
    required this.displayManageDecentralizedId,
  });

  factory SelfSovereignIdentityOptions.fromJson(Map<String, dynamic> json) =>
      _$SelfSovereignIdentityOptionsFromJson(json);

  factory SelfSovereignIdentityOptions.initial() =>
      SelfSovereignIdentityOptions(
        customOidc4vcProfile: CustomOidc4VcProfile.initial(),
        displayManageDecentralizedId: true,
      );

  final CustomOidc4VcProfile customOidc4vcProfile;
  final bool displayManageDecentralizedId;

  Map<String, dynamic> toJson() => _$SelfSovereignIdentityOptionsToJson(this);

  SelfSovereignIdentityOptions copyWith({
    CustomOidc4VcProfile? customOidc4vcProfile,
    bool? displayManageDecentralizedId,
  }) =>
      SelfSovereignIdentityOptions(
        customOidc4vcProfile: customOidc4vcProfile ?? this.customOidc4vcProfile,
        displayManageDecentralizedId:
            displayManageDecentralizedId ?? this.displayManageDecentralizedId,
      );

  @override
  List<Object?> get props => [
        customOidc4vcProfile,
        displayManageDecentralizedId,
      ];
}

@JsonSerializable()
class CustomOidc4VcProfile extends Equatable {
  const CustomOidc4VcProfile({
    required this.clientAuthentication,
    required this.credentialManifestSupport,
    required this.cryptoHolderBinding,
    required this.defaultDid,
    required this.oidc4vciDraft,
    required this.oidc4vpDraft,
    required this.scope,
    required this.securityLevel,
    required this.siopv2Draft,
    required this.subjectSyntaxeType,
    required this.userPinDigits,
    required this.clientId,
    required this.clientSecret,
  });

  factory CustomOidc4VcProfile.fromJson(Map<String, dynamic> json) =>
      _$CustomOidc4VcProfileFromJson(json);

  factory CustomOidc4VcProfile.initial() => CustomOidc4VcProfile(
        clientAuthentication: ClientAuthentication.clientId,
        credentialManifestSupport: false,
        cryptoHolderBinding: true,
        defaultDid: DidKeyType.p256,
        oidc4vciDraft: OIDC4VCIDraftType.draft11,
        oidc4vpDraft: OIDC4VPDraftType.draft18,
        scope: false,
        securityLevel: false,
        siopv2Draft: SIOPV2DraftType.draft12,
        subjectSyntaxeType: SubjectSyntax.did,
        userPinDigits: UserPinDigits.six,
        clientId: Parameters.clientId,
        clientSecret: randomString(12),
      );

  final ClientAuthentication clientAuthentication;
  final bool credentialManifestSupport;
  @JsonKey(name: 'client_id')
  final String? clientId;
  @JsonKey(name: 'client_secret')
  final String? clientSecret;
  final bool cryptoHolderBinding;
  final DidKeyType defaultDid;
  final OIDC4VCIDraftType oidc4vciDraft;
  final OIDC4VPDraftType oidc4vpDraft;
  final bool scope;
  final bool securityLevel;
  final SIOPV2DraftType siopv2Draft;
  final SubjectSyntax subjectSyntaxeType;
  final UserPinDigits userPinDigits;

  Map<String, dynamic> toJson() => _$CustomOidc4VcProfileToJson(this);

  CustomOidc4VcProfile copyWith({
    ClientAuthentication? clientAuthentication,
    bool? credentialManifestSupport,
    String? clientId,
    String? clientSecret,
    bool? cryptoHolderBinding,
    DidKeyType? defaultDid,
    OIDC4VCIDraftType? oidc4vciDraft,
    OIDC4VPDraftType? oidc4vpDraft,
    bool? scope,
    bool? securityLevel,
    SIOPV2DraftType? siopv2Draft,
    SubjectSyntax? subjectSyntaxeType,
    UserPinDigits? userPinDigits,
  }) =>
      CustomOidc4VcProfile(
        clientAuthentication: clientAuthentication ?? this.clientAuthentication,
        credentialManifestSupport:
            credentialManifestSupport ?? this.credentialManifestSupport,
        cryptoHolderBinding: cryptoHolderBinding ?? this.cryptoHolderBinding,
        defaultDid: defaultDid ?? this.defaultDid,
        oidc4vciDraft: oidc4vciDraft ?? this.oidc4vciDraft,
        oidc4vpDraft: oidc4vpDraft ?? this.oidc4vpDraft,
        scope: scope ?? this.scope,
        securityLevel: securityLevel ?? this.securityLevel,
        siopv2Draft: siopv2Draft ?? this.siopv2Draft,
        subjectSyntaxeType: subjectSyntaxeType ?? this.subjectSyntaxeType,
        userPinDigits: userPinDigits ?? this.userPinDigits,
        clientId: clientId ?? this.clientId,
        clientSecret: clientSecret ?? this.clientSecret,
      );

  @override
  List<Object?> get props => [
        clientAuthentication,
        credentialManifestSupport,
        clientId,
        clientSecret,
        cryptoHolderBinding,
        defaultDid,
        oidc4vciDraft,
        oidc4vpDraft,
        scope,
        securityLevel,
        siopv2Draft,
        subjectSyntaxeType,
        userPinDigits,
      ];
}

@JsonSerializable()
class SettingsMenu extends Equatable {
  const SettingsMenu({
    required this.displayDeveloperMode,
    required this.displayHelpCenter,
    required this.displayProfile,
  });

  factory SettingsMenu.fromJson(Map<String, dynamic> json) =>
      _$SettingsMenuFromJson(json);

  factory SettingsMenu.initial() => const SettingsMenu(
        displayDeveloperMode: true,
        displayHelpCenter: true,
        displayProfile: true,
      );

  final bool displayDeveloperMode;
  final bool displayHelpCenter;
  final bool displayProfile;

  Map<String, dynamic> toJson() => _$SettingsMenuToJson(this);

  SettingsMenu copyWith({
    bool? displayDeveloperMode,
    bool? displayHelpCenter,
    bool? displayProfile,
  }) =>
      SettingsMenu(
        displayDeveloperMode: displayDeveloperMode ?? this.displayDeveloperMode,
        displayHelpCenter: displayHelpCenter ?? this.displayHelpCenter,
        displayProfile: displayProfile ?? this.displayProfile,
      );

  @override
  List<Object?> get props => [
        displayDeveloperMode,
        displayHelpCenter,
        displayProfile,
      ];
}

@JsonSerializable()
class WalletSecurityOptions extends Equatable {
  const WalletSecurityOptions({
    required this.confirmSecurityVerifierAccess,
    required this.displaySecurityAdvancedSettings,
    required this.secureSecurityAuthenticationWithPinCode,
    required this.verifySecurityIssuerWebsiteIdentity,
  });

  factory WalletSecurityOptions.fromJson(Map<String, dynamic> json) =>
      _$WalletSecurityOptionsFromJson(json);

  factory WalletSecurityOptions.initial() => const WalletSecurityOptions(
        confirmSecurityVerifierAccess: false,
        displaySecurityAdvancedSettings: true,
        secureSecurityAuthenticationWithPinCode: false,
        verifySecurityIssuerWebsiteIdentity: false,
      );

  final bool confirmSecurityVerifierAccess;
  final bool displaySecurityAdvancedSettings;
  final bool secureSecurityAuthenticationWithPinCode;
  final bool verifySecurityIssuerWebsiteIdentity;

  Map<String, dynamic> toJson() => _$WalletSecurityOptionsToJson(this);

  WalletSecurityOptions copyWith({
    bool? confirmSecurityVerifierAccess,
    bool? displaySecurityAdvancedSettings,
    bool? secureSecurityAuthenticationWithPinCode,
    bool? verifySecurityIssuerWebsiteIdentity,
  }) =>
      WalletSecurityOptions(
        confirmSecurityVerifierAccess:
            confirmSecurityVerifierAccess ?? this.confirmSecurityVerifierAccess,
        displaySecurityAdvancedSettings: displaySecurityAdvancedSettings ??
            this.displaySecurityAdvancedSettings,
        secureSecurityAuthenticationWithPinCode:
            secureSecurityAuthenticationWithPinCode ??
                this.secureSecurityAuthenticationWithPinCode,
        verifySecurityIssuerWebsiteIdentity:
            verifySecurityIssuerWebsiteIdentity ??
                this.verifySecurityIssuerWebsiteIdentity,
      );

  @override
  List<Object?> get props => [
        confirmSecurityVerifierAccess,
        displaySecurityAdvancedSettings,
        secureSecurityAuthenticationWithPinCode,
        verifySecurityIssuerWebsiteIdentity,
      ];
}
