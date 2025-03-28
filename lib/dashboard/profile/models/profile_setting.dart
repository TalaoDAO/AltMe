import 'package:altme/app/app.dart';
import 'package:altme/dashboard/profile/models/display_external_issuer.dart';
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
        discoverCardsOptions: DiscoverCardsOptions.initial(),
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
    this.etherlinkSupport,
    this.testnet,
    this.associatedAddressFormat = VCFormatType.ldpVc,
  });

  factory BlockchainOptions.fromJson(Map<String, dynamic> json) =>
      _$BlockchainOptionsFromJson(json);

  factory BlockchainOptions.initial() => const BlockchainOptions(
        associatedAddressFormat: VCFormatType.ldpVc,
        bnbSupport: true,
        ethereumSupport: true,
        fantomSupport: true,
        hederaSupport: true,
        infuraRpcNode: false,
        polygonSupport: true,
        etherlinkSupport: true,
        tezosSupport: true,
        tzproRpcNode: false,
        testnet: false,
      );

  final VCFormatType? associatedAddressFormat;
  final bool bnbSupport;
  final bool ethereumSupport;
  final bool fantomSupport;
  final bool hederaSupport;
  final String? infuraApiKey;
  final bool infuraRpcNode;
  final bool polygonSupport;
  final bool? etherlinkSupport;
  final bool tezosSupport;
  final String? tzproApiKey;
  final bool tzproRpcNode;
  final bool? testnet;

  Map<String, dynamic> toJson() => _$BlockchainOptionsToJson(this);

  BlockchainOptions copyWth({
    VCFormatType? associatedAddressFormat,
    bool? bnbSupport,
    bool? ethereumSupport,
    bool? fantomSupport,
    bool? hederaSupport,
    String? infuraApiKey,
    bool? infuraRpcNode,
    bool? polygonSupport,
    bool? etherlinkSupport,
    bool? tezosSupport,
    String? tzproApiKey,
    bool? tzproRpcNode,
    bool? testnet,
  }) {
    return BlockchainOptions(
      associatedAddressFormat:
          associatedAddressFormat ?? this.associatedAddressFormat,
      bnbSupport: bnbSupport ?? this.bnbSupport,
      ethereumSupport: ethereumSupport ?? this.ethereumSupport,
      fantomSupport: fantomSupport ?? this.fantomSupport,
      hederaSupport: hederaSupport ?? this.hederaSupport,
      infuraRpcNode: infuraRpcNode ?? this.infuraRpcNode,
      polygonSupport: polygonSupport ?? this.polygonSupport,
      etherlinkSupport: etherlinkSupport ?? this.etherlinkSupport,
      tezosSupport: tezosSupport ?? this.tezosSupport,
      tzproRpcNode: tzproRpcNode ?? this.tzproRpcNode,
      infuraApiKey: infuraApiKey ?? this.infuraApiKey,
      tzproApiKey: tzproApiKey ?? this.tzproApiKey,
      testnet: testnet ?? this.testnet,
    );
  }

  @override
  List<Object?> get props => [
        associatedAddressFormat,
        bnbSupport,
        ethereumSupport,
        fantomSupport,
        hederaSupport,
        infuraApiKey,
        infuraRpcNode,
        polygonSupport,
        etherlinkSupport,
        tezosSupport,
        tzproApiKey,
        tzproRpcNode,
        testnet,
      ];
}

@JsonSerializable()
class DiscoverCardsOptions extends Equatable {
  const DiscoverCardsOptions({
    required this.displayOver21,
    required this.displayOver65,
    required this.displayAgeRange,
    required this.displayGender,
    required this.displayDefi,
    required this.displayHumanity,
    required this.displayOver13,
    required this.displayOver15,
    required this.displayOver18,
    required this.displayOver50,
    required this.displayVerifiableId,
    required this.displayExternalIssuer,
    this.displayOver18Jwt = false,
    this.displayOver18SdJwt = false,
    this.displayVerifiableIdJwt = false,
    this.displayVerifiableIdSdJwt = false,
    this.displayEmailPass = true,
    this.displayEmailPassJwt = true,
    this.displayPhonePass = true,
    this.displayPhonePassJwt = true,
    this.displayPhonePassSdJwt = false,
    this.displayChainborn = false,
    this.displayTezotopia = false,
    this.displayHumanityJwt = false,
    this.displayEmailPassSdJwt = false,
  });

  factory DiscoverCardsOptions.fromJson(Map<String, dynamic> json) =>
      _$DiscoverCardsOptionsFromJson(json);

  factory DiscoverCardsOptions.initial() => const DiscoverCardsOptions(
        displayDefi: true,
        displayHumanity: false,
        displayOver13: false,
        displayOver15: false,
        displayOver18: true,
        displayOver21: false,
        displayOver50: false,
        displayVerifiableId: true,
        displayVerifiableIdSdJwt: true,
        displayOver65: false,
        displayAgeRange: false,
        displayGender: false,
        displayExternalIssuer: [],
      );

  factory DiscoverCardsOptions.none() => const DiscoverCardsOptions(
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
        displayVerifiableIdJwt: false,
        displayOver65: false,
        displayEmailPass: false,
        displayEmailPassJwt: false,
        displayPhonePass: false,
        displayPhonePassJwt: false,
        displayAgeRange: false,
        displayGender: false,
        displayExternalIssuer: [],
        displayEmailPassSdJwt: false,
      );

  final bool displayDefi;
  final bool displayHumanity;
  final bool displayHumanityJwt;
  final bool displayOver13;
  final bool displayOver15;
  final bool displayOver18;
  final bool displayOver18Jwt;
  final bool displayOver18SdJwt;
  final bool displayOver21;
  final bool displayOver50;
  final bool displayOver65;
  final bool displayEmailPass;
  final bool displayEmailPassJwt;
  final bool displayPhonePass;
  final bool displayPhonePassJwt;
  final bool displayPhonePassSdJwt;
  final bool displayAgeRange;
  final bool displayVerifiableId;
  final bool displayVerifiableIdJwt;
  final bool displayVerifiableIdSdJwt;
  final bool displayGender;
  final List<DisplayExternalIssuer> displayExternalIssuer;
  final bool displayChainborn;
  final bool displayTezotopia;
  final bool displayEmailPassSdJwt;

  Map<String, dynamic> toJson() => _$DiscoverCardsOptionsToJson(this);

  DiscoverCardsOptions copyWith({
    bool? displayDefi,
    bool? displayHumanity,
    bool? displayHumanityJwt,
    bool? displayOver13,
    bool? displayOver15,
    bool? displayOver18,
    bool? displayOver18Jwt,
    bool? displayOver18SdJwt,
    bool? displayVerifiableId,
    bool? displayVerifiableIdJwt,
    bool? displayVerifiableIdSdJwt,
    bool? displayOver21,
    bool? displayOver65,
    bool? displayEmailPass,
    bool? displayEmailPassJwt,
    bool? displayPhonePass,
    bool? displayPhonePassJwt,
    bool? displayPhonePassSdJwt,
    bool? displayAgeRange,
    bool? displayGender,
    bool? displayOver50,
    List<DisplayExternalIssuer>? displayExternalIssuer,
    bool? displayChainborn,
    bool? displayTezotopia,
    bool? displayEmailPassSdJwt,
  }) {
    return DiscoverCardsOptions(
      displayDefi: displayDefi ?? this.displayDefi,
      displayHumanity: displayHumanity ?? this.displayHumanity,
      displayHumanityJwt: displayHumanityJwt ?? this.displayHumanityJwt,
      displayOver13: displayOver13 ?? this.displayOver13,
      displayOver15: displayOver15 ?? this.displayOver15,
      displayOver18: displayOver18 ?? this.displayOver18,
      displayOver18Jwt: displayOver18Jwt ?? this.displayOver18Jwt,
      displayOver18SdJwt: displayOver18SdJwt ?? this.displayOver18SdJwt,
      displayVerifiableId: displayVerifiableId ?? this.displayVerifiableId,
      displayVerifiableIdJwt:
          displayVerifiableIdJwt ?? this.displayVerifiableIdJwt,
      displayVerifiableIdSdJwt:
          displayVerifiableIdSdJwt ?? this.displayVerifiableIdSdJwt,
      displayOver21: displayOver21 ?? this.displayOver21,
      displayOver65: displayOver65 ?? this.displayOver65,
      displayEmailPass: displayEmailPass ?? this.displayEmailPass,
      displayEmailPassJwt: displayEmailPassJwt ?? this.displayEmailPassJwt,
      displayPhonePass: displayPhonePass ?? this.displayPhonePass,
      displayPhonePassJwt: displayPhonePassJwt ?? this.displayPhonePassJwt,
      displayPhonePassSdJwt:
          displayPhonePassSdJwt ?? this.displayPhonePassSdJwt,
      displayAgeRange: displayAgeRange ?? this.displayAgeRange,
      displayGender: displayGender ?? this.displayGender,
      displayOver50: displayOver50 ?? this.displayOver50,
      displayExternalIssuer:
          displayExternalIssuer ?? this.displayExternalIssuer,
      displayChainborn: displayChainborn ?? this.displayChainborn,
      displayTezotopia: displayTezotopia ?? this.displayTezotopia,
      displayEmailPassSdJwt:
          displayEmailPassSdJwt ?? this.displayEmailPassSdJwt,
    );
  }

  VCFormatType vcFormatTypeForAuto({
    required CredentialSubjectType credentialSubjectType,
    required VCFormatType vcFormatType,
  }) {
    final isLdpVc = vcFormatType == VCFormatType.ldpVc;
    final isJwtVcJson = vcFormatType == VCFormatType.jwtVcJson;
    final isVcSdJWT = vcFormatType == VCFormatType.vcSdJWT;

    switch (credentialSubjectType) {
      case CredentialSubjectType.defiCompliance:
        if (isLdpVc && displayDefi) return VCFormatType.ldpVc;
      case CredentialSubjectType.livenessCard:
        if (isLdpVc && displayHumanity) return VCFormatType.ldpVc;
        if (isJwtVcJson && displayHumanityJwt) return VCFormatType.vcSdJWT;
      case CredentialSubjectType.gender:
        if (isLdpVc && displayGender) return VCFormatType.ldpVc;
      case CredentialSubjectType.verifiableIdCard:
        if (isLdpVc && displayVerifiableId) return VCFormatType.ldpVc;
        if (isJwtVcJson && displayVerifiableIdJwt) {
          return VCFormatType.jwtVcJson;
        }
        if (isVcSdJWT && displayVerifiableIdSdJwt) return VCFormatType.vcSdJWT;
      case CredentialSubjectType.over13:
        if (isLdpVc && displayOver13) return VCFormatType.ldpVc;
      case CredentialSubjectType.over15:
        if (isLdpVc && displayOver15) return VCFormatType.ldpVc;
      case CredentialSubjectType.over18:
        if (isLdpVc && displayOver18) return VCFormatType.ldpVc;
        if (isJwtVcJson && displayOver18Jwt) return VCFormatType.jwtVcJson;
        if (isVcSdJWT && displayOver18SdJwt) return VCFormatType.vcSdJWT;
      case CredentialSubjectType.over21:
        if (isLdpVc && displayOver21) return VCFormatType.ldpVc;
      case CredentialSubjectType.over50:
        if (isLdpVc && displayOver50) return VCFormatType.ldpVc;
      case CredentialSubjectType.over65:
        if (isLdpVc && displayOver65) return VCFormatType.ldpVc;
      case CredentialSubjectType.emailPass:
        if (isLdpVc && displayEmailPass) return VCFormatType.ldpVc;
        if (isJwtVcJson && displayEmailPassJwt) return VCFormatType.jwtVcJson;
        if (isVcSdJWT && displayEmailPassSdJwt) return VCFormatType.vcSdJWT;
      case CredentialSubjectType.learningAchievement:
      case CredentialSubjectType.phonePass:
        if (isLdpVc && displayPhonePass) return VCFormatType.ldpVc;
        if (isJwtVcJson && displayPhonePassJwt) return VCFormatType.jwtVcJson;
      case CredentialSubjectType.identityPass:
      case CredentialSubjectType.tezotopiaMembership:
      case CredentialSubjectType.chainbornMembership:
      case CredentialSubjectType.ageRange:
      case CredentialSubjectType.nationality:
      case CredentialSubjectType.passportFootprint:
      case CredentialSubjectType.residentCard:
      case CredentialSubjectType.voucher:
      case CredentialSubjectType.tezVoucher:
      case CredentialSubjectType.diplomaCard:
      case CredentialSubjectType.twitterCard:
      case CredentialSubjectType.tezosAssociatedWallet:
      case CredentialSubjectType.ethereumAssociatedWallet:
      case CredentialSubjectType.fantomAssociatedWallet:
      case CredentialSubjectType.polygonAssociatedWallet:
      case CredentialSubjectType.binanceAssociatedWallet:
      case CredentialSubjectType.etherlinkAssociatedWallet:
      case CredentialSubjectType.walletCredential:
      case CredentialSubjectType.tezosPooAddress:
      case CredentialSubjectType.ethereumPooAddress:
      case CredentialSubjectType.fantomPooAddress:
      case CredentialSubjectType.polygonPooAddress:
      case CredentialSubjectType.binancePooAddress:
      case CredentialSubjectType.certificateOfEmployment:
      case CredentialSubjectType.defaultCredential:
      case CredentialSubjectType.professionalExperienceAssessment:
      case CredentialSubjectType.professionalSkillAssessment:
      case CredentialSubjectType.professionalStudentCard:
      case CredentialSubjectType.selfIssued:
      case CredentialSubjectType.studentCard:
      case CredentialSubjectType.aragoPass:
      case CredentialSubjectType.aragoEmailPass:
      case CredentialSubjectType.aragoIdentityCard:
      case CredentialSubjectType.aragoLearningAchievement:
      case CredentialSubjectType.aragoOver18:
      case CredentialSubjectType.pcdsAgentCertificate:
      case CredentialSubjectType.euDiplomaCard:
      case CredentialSubjectType.euVerifiableId:
      case CredentialSubjectType.employeeCredential:
      case CredentialSubjectType.legalPersonalCredential:
      case CredentialSubjectType.identityCredential:
      case CredentialSubjectType.eudiPid:
      case CredentialSubjectType.pid:
        return VCFormatType.ldpVc;
    }

    return VCFormatType.ldpVc;
  }

  @override
  List<Object?> get props => [
        displayDefi,
        displayHumanity,
        displayOver13,
        displayOver15,
        displayOver18,
        displayOver18Jwt,
        displayOver18SdJwt,
        displayVerifiableId,
        displayOver21,
        displayOver65,
        displayAgeRange,
        displayGender,
        displayOver50,
        displayEmailPass,
        displayEmailPassJwt,
        displayPhonePass,
        displayPhonePassJwt,
        displayPhonePassSdJwt,
        displayExternalIssuer,
        displayHumanityJwt,
        displayOver18Jwt,
        displayVerifiableIdJwt,
        displayChainborn,
        displayTezotopia,
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
    this.primaryColor,
    this.companyLogoLight,
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
        primaryColor: '',
      );

  final WalletAppType walletType;
  final String companyName;
  final String companyWebsite;
  final String companyLogo;
  final String? companyLogoLight;
  final String tagLine;
  final String? splashScreenTitle;
  final String profileName;
  final String profileVersion;
  final DateTime published;
  final String profileId;
  final String customerPlan;
  final String? primaryColor;

  Map<String, dynamic> toJson() => _$GeneralOptionsToJson(this);

  GeneralOptions copyWith({
    WalletAppType? walletType,
    String? companyName,
    String? companyWebsite,
    String? companyLogo,
    String? companyLogoLight,
    String? splashScreenTitle,
    String? tagLine,
    String? profileName,
    String? profileVersion,
    DateTime? published,
    String? profileId,
    String? customerPlan,
    String? primaryColor,
  }) {
    return GeneralOptions(
      walletType: walletType ?? this.walletType,
      companyName: companyName ?? this.companyName,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      companyLogo: companyLogo ?? this.companyLogo,
      companyLogoLight: companyLogoLight ?? this.companyLogoLight,
      tagLine: tagLine ?? this.tagLine,
      splashScreenTitle: splashScreenTitle ?? this.splashScreenTitle,
      profileName: profileName ?? this.profileName,
      profileVersion: profileVersion ?? this.profileVersion,
      published: published ?? this.published,
      profileId: profileId ?? this.profileId,
      customerPlan: customerPlan ?? this.customerPlan,
      primaryColor: primaryColor ?? this.primaryColor,
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
        primaryColor,
      ];
}

@JsonSerializable()
class HelpCenterOptions extends Equatable {
  const HelpCenterOptions({
    required this.customChatSupport,
    required this.customEmailSupport,
    required this.displayChatSupport,
    required this.displayEmailSupport,
    required this.displayNotification,
    this.customChatSupportName,
    this.customEmail,
    this.customNotification,
    this.customNotificationRoom,
  });

  factory HelpCenterOptions.fromJson(Map<String, dynamic> json) =>
      _$HelpCenterOptionsFromJson(json);

  factory HelpCenterOptions.initial() => const HelpCenterOptions(
        customChatSupport: false,
        customEmailSupport: false,
        displayChatSupport: true,
        displayEmailSupport: true,
        displayNotification: true,
      );

  final bool customChatSupport;
  final String? customChatSupportName;
  final String? customEmail;
  final bool customEmailSupport;
  final bool displayChatSupport;
  final bool displayEmailSupport;
  final bool displayNotification;
  final bool? customNotification;
  final String? customNotificationRoom;

  Map<String, dynamic> toJson() => _$HelpCenterOptionsToJson(this);

  HelpCenterOptions copyWith({
    bool? customChatSupport,
    String? customChatSupportName,
    String? customEmail,
    bool? customEmailSupport,
    bool? displayChatSupport,
    bool? displayEmailSupport,
    bool? displayNotification,
    bool? customNotification,
    String? customNotificationRoom,
  }) =>
      HelpCenterOptions(
        customChatSupport: customChatSupport ?? this.customChatSupport,
        customEmailSupport: customEmailSupport ?? this.customEmailSupport,
        displayChatSupport: displayChatSupport ?? this.displayChatSupport,
        displayEmailSupport: displayEmailSupport ?? this.displayEmailSupport,
        customChatSupportName:
            customChatSupportName ?? this.customChatSupportName,
        customEmail: customEmail ?? this.customEmail,
        displayNotification: displayNotification ?? this.displayNotification,
        customNotification: customNotification ?? this.customNotification,
        customNotificationRoom:
            customNotificationRoom ?? this.customNotificationRoom,
      );

  @override
  List<Object?> get props => [
        customChatSupport,
        customChatSupportName,
        customEmail,
        customEmailSupport,
        displayChatSupport,
        displayEmailSupport,
        displayNotification,
        customNotification,
        customNotificationRoom,
        displayNotification,
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
    required this.clientType,
    this.clientId = Parameters.clientId,
    this.clientSecret = 'FGbzMrvUpeFr',
    this.vcFormatType = VCFormatType.jwtVcJson,
    this.proofHeader = ProofHeaderType.kid,
    this.proofType = ProofType.jwt,
    this.pushAuthorizationRequest = false,
    this.statusListCache = true,
    this.dpopSupport = false,
    this.formatsSupported = const [],
    this.displayMode = true,
  });

  factory CustomOidc4VcProfile.initial() => CustomOidc4VcProfile(
        clientAuthentication: ClientAuthentication.clientId,
        credentialManifestSupport: false,
        cryptoHolderBinding: true,
        defaultDid: DidKeyType.edDSA,
        oidc4vciDraft: OIDC4VCIDraftType.draft13,
        oidc4vpDraft: OIDC4VPDraftType.draft21,
        scope: false,
        securityLevel: false,
        siopv2Draft: SIOPV2DraftType.draft12,
        clientType: ClientType.did,
        clientId: Parameters.clientId,
        clientSecret: randomString(12),
        displayMode: false,
      );

  factory CustomOidc4VcProfile.fromJson(Map<String, dynamic> json) {
    final profileFromJson = _$CustomOidc4VcProfileFromJson(json);
    if (profileFromJson.formatsSupported!.isEmpty) {
      return profileFromJson.copyWith(
        formatsSupported: <VCFormatType>[profileFromJson.vcFormatType],
      );
    }
    return profileFromJson;
  }

  final ClientAuthentication clientAuthentication;
  @JsonKey(defaultValue: false)
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
  final ProofHeaderType proofHeader;
  final bool securityLevel;
  final bool statusListCache;
  final bool pushAuthorizationRequest;
  final SIOPV2DraftType siopv2Draft;
  @JsonKey(name: 'subjectSyntaxeType')
  final ClientType clientType;
  @JsonKey(name: 'vcFormat')
  final VCFormatType vcFormatType;
  final List<VCFormatType>? formatsSupported;
  final ProofType proofType;
  final bool dpopSupport;
  final bool displayMode;

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
    ProofHeaderType? proofHeader,
    bool? securityLevel,
    bool? statusListCache,
    bool? pushAuthorizationRequest,
    SIOPV2DraftType? siopv2Draft,
    ClientType? clientType,
    VCFormatType? vcFormatType,
    List<VCFormatType>? formatsSupported,
    ProofType? proofType,
    bool? dpopSupport,
    bool? displayMode,
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
        proofHeader: proofHeader ?? this.proofHeader,
        securityLevel: securityLevel ?? this.securityLevel,
        statusListCache: statusListCache ?? this.statusListCache,
        pushAuthorizationRequest:
            pushAuthorizationRequest ?? this.pushAuthorizationRequest,
        siopv2Draft: siopv2Draft ?? this.siopv2Draft,
        clientType: clientType ?? this.clientType,
        clientId: clientId ?? this.clientId,
        clientSecret: clientSecret ?? this.clientSecret,
        vcFormatType: vcFormatType ?? this.vcFormatType,
        proofType: proofType ?? this.proofType,
        dpopSupport: dpopSupport ?? this.dpopSupport,
        formatsSupported: formatsSupported ?? this.formatsSupported,
        displayMode: displayMode ?? this.displayMode,
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
        proofHeader,
        securityLevel,
        statusListCache,
        pushAuthorizationRequest,
        siopv2Draft,
        clientType,
        vcFormatType,
        formatsSupported,
        proofType,
        dpopSupport,
        displayMode,
      ];
}

@JsonSerializable()
class SettingsMenu extends Equatable {
  const SettingsMenu({
    required this.displayDeveloperMode,
    required this.displayHelpCenter,
    required this.displayProfile,
    this.displaySelfSovereignIdentity = true,
    this.displayActivityLog = true,
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
  final bool displaySelfSovereignIdentity;
  final bool displayActivityLog;

  Map<String, dynamic> toJson() => _$SettingsMenuToJson(this);

  SettingsMenu copyWith({
    bool? displayDeveloperMode,
    bool? displayHelpCenter,
    bool? displayProfile,
    bool? displaySelfSovereignIdentity,
    bool? displayActivityLog,
  }) =>
      SettingsMenu(
        displayDeveloperMode: displayDeveloperMode ?? this.displayDeveloperMode,
        displayHelpCenter: displayHelpCenter ?? this.displayHelpCenter,
        displayProfile: displayProfile ?? this.displayProfile,
        displaySelfSovereignIdentity:
            displaySelfSovereignIdentity ?? this.displaySelfSovereignIdentity,
        displayActivityLog: displayActivityLog ?? this.displayActivityLog,
      );

  @override
  List<Object?> get props => [
        displayDeveloperMode,
        displayHelpCenter,
        displayProfile,
        displaySelfSovereignIdentity,
        displayActivityLog,
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
