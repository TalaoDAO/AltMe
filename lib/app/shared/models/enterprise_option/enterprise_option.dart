import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'enterprise_option.g.dart';

@JsonSerializable()
class EnterpriseOption extends Equatable {
  const EnterpriseOption({
    this.blockchainOptions,
    this.exp,
    this.generalOptions,
    this.helpCenterOptions,
    this.iat,
    this.iss,
    this.jti,
    this.published,
    this.selfSovereignIdentityOptions,
    this.settingsMenu,
    this.version,
    this.walletSecurityOptions,
  });

  factory EnterpriseOption.fromJson(Map<String, dynamic> json) =>
      _$EnterpriseOptionFromJson(json);

  final BlockchainOptions? blockchainOptions;
  final int? exp;
  final GeneralOptions? generalOptions;
  final HelpCenterOptions? helpCenterOptions;
  final int? iat;
  final String? iss;
  final String? jti;
  final DateTime? published;
  final SelfSovereignIdentityOptions? selfSovereignIdentityOptions;
  final SettingsMenu? settingsMenu;
  final String? version;
  final WalletSecurityOptions? walletSecurityOptions;

  Map<String, dynamic> toJson() => _$EnterpriseOptionToJson(this);

  @override
  List<Object?> get props => [
        blockchainOptions,
        exp,
        generalOptions,
        helpCenterOptions,
        iat,
        iss,
        jti,
        published,
        selfSovereignIdentityOptions,
        settingsMenu,
        version,
        walletSecurityOptions,
      ];
}

@JsonSerializable()
class BlockchainOptions extends Equatable {
  const BlockchainOptions({
    this.bnbSupport,
    this.ethereumSupport,
    this.fantomSupport,
    this.hederaSupport,
    this.infuraApiKey,
    this.infuraRpcNode,
    this.polygonSupport,
    this.tezosSupport,
    this.tzproApiKey,
    this.tzproRpcNode,
  });

  factory BlockchainOptions.fromJson(Map<String, dynamic> json) =>
      _$BlockchainOptionsFromJson(json);

  final bool? bnbSupport;
  final bool? ethereumSupport;
  final bool? fantomSupport;
  final bool? hederaSupport;
  final String? infuraApiKey;
  final bool? infuraRpcNode;
  final bool? polygonSupport;
  final bool? tezosSupport;
  final String? tzproApiKey;
  final bool? tzproRpcNode;

  Map<String, dynamic> toJson() => _$BlockchainOptionsToJson(this);

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
class GeneralOptions extends Equatable {
  const GeneralOptions({
    this.companyLogo,
    this.companyName,
    this.companyWebsite,
    this.customerPlan,
    this.profileName,
    this.profileVersion,
    this.walletType,
  });

  factory GeneralOptions.fromJson(Map<String, dynamic> json) =>
      _$GeneralOptionsFromJson(json);

  final String? companyLogo;
  final String? companyName;
  final String? companyWebsite;
  final String? customerPlan;
  final String? profileName;
  final String? profileVersion;
  final String? walletType;

  Map<String, dynamic> toJson() => _$GeneralOptionsToJson(this);

  @override
  List<Object?> get props => [
        companyLogo,
        companyName,
        companyWebsite,
        customerPlan,
        profileName,
        profileVersion,
        walletType,
      ];
}

@JsonSerializable()
class HelpCenterOptions extends Equatable {
  const HelpCenterOptions({
    this.customChatSupport,
    this.customChatSupportName,
    this.customEmail,
    this.customEmailSupport,
    this.displayChatSupport,
    this.displayEmailSupport,
  });

  factory HelpCenterOptions.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterOptionsFromJson(json);

  final bool? customChatSupport;
  final String? customChatSupportName;
  final String? customEmail;
  final bool? customEmailSupport;
  final bool? displayChatSupport;
  final bool? displayEmailSupport;

  Map<String, dynamic> toJson() => _$HelpCenterOptionsToJson(this);

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
    this.customOidc4VcProfile,
    this.displayManageDecentralizedId,
    this.displaySsiAdvancedSettings,
    this.displayVerifiableDataRegistry,
    this.oidv4VcProfile,
  });

  factory SelfSovereignIdentityOptions.fromJson(Map<String, dynamic> json) =>
      _$SelfSovereignIdentityOptionsFromJson(json);

  final CustomOidc4VcProfile? customOidc4VcProfile;
  final bool? displayManageDecentralizedId;
  final bool? displaySsiAdvancedSettings;
  final bool? displayVerifiableDataRegistry;
  final String? oidv4VcProfile;

  Map<String, dynamic> toJson() => _$SelfSovereignIdentityOptionsToJson(this);

  @override
  List<Object?> get props => [
        customOidc4VcProfile,
        displayManageDecentralizedId,
        displaySsiAdvancedSettings,
        displayVerifiableDataRegistry,
        oidv4VcProfile,
      ];
}

@JsonSerializable()
class CustomOidc4VcProfile extends Equatable {
  const CustomOidc4VcProfile({
    this.clientAuthentication,
    this.clientId,
    this.clientSecret,
    this.cryptoHolderBinding,
    this.defaultDid,
    this.oidc4VciDraft,
    this.oidc4VpDraft,
    this.scope,
    this.securityLevel,
    this.siopv2Draft,
    this.subjectSyntaxeType,
    this.userPinDigits,
  });

  factory CustomOidc4VcProfile.fromJson(Map<String, dynamic> json) =>
      _$CustomOidc4VcProfileFromJson(json);

  final String? clientAuthentication;
  final String? clientId;
  final String? clientSecret;
  final bool? cryptoHolderBinding;
  final String? defaultDid;
  final String? oidc4VciDraft;
  final String? oidc4VpDraft;
  final bool? scope;
  final String? securityLevel;
  final String? siopv2Draft;
  final String? subjectSyntaxeType;
  final String? userPinDigits;

  Map<String, dynamic> toJson() => _$CustomOidc4VcProfileToJson(this);

  @override
  List<Object?> get props => [
        clientAuthentication,
        clientId,
        clientSecret,
        cryptoHolderBinding,
        defaultDid,
        oidc4VciDraft,
        oidc4VpDraft,
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
    this.displayDeveloperMode,
    this.displayHelpCenter,
    this.displayProfile,
  });

  factory SettingsMenu.fromJson(Map<String, dynamic> json) =>
      _$SettingsMenuFromJson(json);

  final bool? displayDeveloperMode;
  final bool? displayHelpCenter;
  final bool? displayProfile;

  Map<String, dynamic> toJson() => _$SettingsMenuToJson(this);

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
    this.confirmSecurityVerifierAccess,
    this.displaySecurityAdvancedSettings,
    this.secureSecurityAuthenticationWithPinCode,
    this.verifySecurityIssuerWebsiteIdentity,
  });

  factory WalletSecurityOptions.fromJson(Map<String, dynamic> json) =>
      _$WalletSecurityOptionsFromJson(json);

  final bool? confirmSecurityVerifierAccess;
  final bool? displaySecurityAdvancedSettings;
  final bool? secureSecurityAuthenticationWithPinCode;
  final bool? verifySecurityIssuerWebsiteIdentity;

  Map<String, dynamic> toJson() => _$WalletSecurityOptionsToJson(this);

  @override
  List<Object?> get props => [
        confirmSecurityVerifierAccess,
        displaySecurityAdvancedSettings,
        secureSecurityAuthenticationWithPinCode,
        verifySecurityIssuerWebsiteIdentity,
      ];
}
