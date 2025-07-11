// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileSetting _$ProfileSettingFromJson(Map<String, dynamic> json) =>
    ProfileSetting(
      blockchainOptions: json['blockchainOptions'] == null
          ? null
          : BlockchainOptions.fromJson(
              json['blockchainOptions'] as Map<String, dynamic>),
      discoverCardsOptions: json['discoverCardsOptions'] == null
          ? null
          : DiscoverCardsOptions.fromJson(
              json['discoverCardsOptions'] as Map<String, dynamic>),
      generalOptions: GeneralOptions.fromJson(
          json['generalOptions'] as Map<String, dynamic>),
      helpCenterOptions: HelpCenterOptions.fromJson(
          json['helpCenterOptions'] as Map<String, dynamic>),
      selfSovereignIdentityOptions: SelfSovereignIdentityOptions.fromJson(
          json['selfSovereignIdentityOptions'] as Map<String, dynamic>),
      settingsMenu:
          SettingsMenu.fromJson(json['settingsMenu'] as Map<String, dynamic>),
      version: json['version'] as String,
      walletSecurityOptions: WalletSecurityOptions.fromJson(
          json['walletSecurityOptions'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ProfileSettingToJson(ProfileSetting instance) =>
    <String, dynamic>{
      'blockchainOptions': instance.blockchainOptions,
      'discoverCardsOptions': instance.discoverCardsOptions,
      'generalOptions': instance.generalOptions,
      'helpCenterOptions': instance.helpCenterOptions,
      'selfSovereignIdentityOptions': instance.selfSovereignIdentityOptions,
      'settingsMenu': instance.settingsMenu,
      'version': instance.version,
      'walletSecurityOptions': instance.walletSecurityOptions,
    };

BlockchainOptions _$BlockchainOptionsFromJson(Map<String, dynamic> json) =>
    BlockchainOptions(
      bnbSupport: json['bnbSupport'] as bool,
      ethereumSupport: json['ethereumSupport'] as bool,
      fantomSupport: json['fantomSupport'] as bool,
      hederaSupport: json['hederaSupport'] as bool,
      infuraRpcNode: json['infuraRpcNode'] as bool,
      polygonSupport: json['polygonSupport'] as bool,
      tezosSupport: json['tezosSupport'] as bool,
      tzproRpcNode: json['tzproRpcNode'] as bool,
      tzproApiKey: json['tzproApiKey'] as String?,
      infuraApiKey: json['infuraApiKey'] as String?,
      etherlinkSupport: json['etherlinkSupport'] as bool?,
      testnet: json['testnet'] as bool?,
      associatedAddressFormat: $enumDecodeNullable(
              _$VCFormatTypeEnumMap, json['associatedAddressFormat']) ??
          VCFormatType.ldpVc,
    );

Map<String, dynamic> _$BlockchainOptionsToJson(BlockchainOptions instance) =>
    <String, dynamic>{
      'associatedAddressFormat':
          _$VCFormatTypeEnumMap[instance.associatedAddressFormat],
      'bnbSupport': instance.bnbSupport,
      'ethereumSupport': instance.ethereumSupport,
      'fantomSupport': instance.fantomSupport,
      'hederaSupport': instance.hederaSupport,
      'infuraApiKey': instance.infuraApiKey,
      'infuraRpcNode': instance.infuraRpcNode,
      'polygonSupport': instance.polygonSupport,
      'etherlinkSupport': instance.etherlinkSupport,
      'tezosSupport': instance.tezosSupport,
      'tzproApiKey': instance.tzproApiKey,
      'tzproRpcNode': instance.tzproRpcNode,
      'testnet': instance.testnet,
    };

const _$VCFormatTypeEnumMap = {
  VCFormatType.ldpVc: 'ldp_vc',
  VCFormatType.jwtVc: 'jwt_vc',
  VCFormatType.jwtVcJson: 'jwt_vc_json',
  VCFormatType.jwtVcJsonLd: 'jwt_vc_json-ld',
  VCFormatType.vcSdJWT: 'vc+sd-jwt',
  VCFormatType.dcSdJWT: 'dc+sd-jwt',
  VCFormatType.auto: 'auto',
};

DiscoverCardsOptions _$DiscoverCardsOptionsFromJson(
        Map<String, dynamic> json) =>
    DiscoverCardsOptions(
      displayOver21: json['displayOver21'] as bool,
      displayOver65: json['displayOver65'] as bool,
      displayAgeRange: json['displayAgeRange'] as bool,
      displayGender: json['displayGender'] as bool,
      displayDefi: json['displayDefi'] as bool,
      displayHumanity: json['displayHumanity'] as bool,
      displayOver13: json['displayOver13'] as bool,
      displayOver15: json['displayOver15'] as bool,
      displayOver18: json['displayOver18'] as bool,
      displayOver50: json['displayOver50'] as bool,
      displayVerifiableId: json['displayVerifiableId'] as bool,
      displayExternalIssuer: (json['displayExternalIssuer'] as List<dynamic>)
          .map((e) => DisplayExternalIssuer.fromJson(e as Map<String, dynamic>))
          .toList(),
      displayOver18Jwt: json['displayOver18Jwt'] as bool? ?? false,
      displayOver18SdJwt: json['displayOver18SdJwt'] as bool? ?? false,
      displayVerifiableIdJwt: json['displayVerifiableIdJwt'] as bool? ?? false,
      displayVerifiableIdSdJwt:
          json['displayVerifiableIdSdJwt'] as bool? ?? false,
      displayEmailPass: json['displayEmailPass'] as bool? ?? true,
      displayEmailPassJwt: json['displayEmailPassJwt'] as bool? ?? true,
      displayPhonePass: json['displayPhonePass'] as bool? ?? true,
      displayPhonePassJwt: json['displayPhonePassJwt'] as bool? ?? true,
      displayPhonePassSdJwt: json['displayPhonePassSdJwt'] as bool? ?? false,
      displayChainborn: json['displayChainborn'] as bool? ?? false,
      displayTezotopia: json['displayTezotopia'] as bool? ?? false,
      displayHumanityJwt: json['displayHumanityJwt'] as bool? ?? false,
      displayEmailPassSdJwt: json['displayEmailPassSdJwt'] as bool? ?? false,
    );

Map<String, dynamic> _$DiscoverCardsOptionsToJson(
        DiscoverCardsOptions instance) =>
    <String, dynamic>{
      'displayDefi': instance.displayDefi,
      'displayHumanity': instance.displayHumanity,
      'displayHumanityJwt': instance.displayHumanityJwt,
      'displayOver13': instance.displayOver13,
      'displayOver15': instance.displayOver15,
      'displayOver18': instance.displayOver18,
      'displayOver18Jwt': instance.displayOver18Jwt,
      'displayOver18SdJwt': instance.displayOver18SdJwt,
      'displayOver21': instance.displayOver21,
      'displayOver50': instance.displayOver50,
      'displayOver65': instance.displayOver65,
      'displayEmailPass': instance.displayEmailPass,
      'displayEmailPassJwt': instance.displayEmailPassJwt,
      'displayPhonePass': instance.displayPhonePass,
      'displayPhonePassJwt': instance.displayPhonePassJwt,
      'displayPhonePassSdJwt': instance.displayPhonePassSdJwt,
      'displayAgeRange': instance.displayAgeRange,
      'displayVerifiableId': instance.displayVerifiableId,
      'displayVerifiableIdJwt': instance.displayVerifiableIdJwt,
      'displayVerifiableIdSdJwt': instance.displayVerifiableIdSdJwt,
      'displayGender': instance.displayGender,
      'displayExternalIssuer': instance.displayExternalIssuer,
      'displayChainborn': instance.displayChainborn,
      'displayTezotopia': instance.displayTezotopia,
      'displayEmailPassSdJwt': instance.displayEmailPassSdJwt,
    };

GeneralOptions _$GeneralOptionsFromJson(Map<String, dynamic> json) =>
    GeneralOptions(
      walletType: $enumDecode(_$WalletAppTypeEnumMap, json['walletType']),
      companyName: json['companyName'] as String,
      companyWebsite: json['companyWebsite'] as String,
      companyLogo: json['companyLogo'] as String,
      tagLine: json['tagLine'] as String,
      splashScreenTitle: json['splashScreenTitle'] as String?,
      profileName: json['profileName'] as String,
      profileVersion: json['profileVersion'] as String,
      published: DateTime.parse(json['published'] as String),
      profileId: json['profileId'] as String,
      customerPlan: json['customerPlan'] as String,
      primaryColor: json['primaryColor'] as String?,
      companyLogoLight: json['companyLogoLight'] as String?,
    );

Map<String, dynamic> _$GeneralOptionsToJson(GeneralOptions instance) =>
    <String, dynamic>{
      'walletType': _$WalletAppTypeEnumMap[instance.walletType]!,
      'companyName': instance.companyName,
      'companyWebsite': instance.companyWebsite,
      'companyLogo': instance.companyLogo,
      'companyLogoLight': instance.companyLogoLight,
      'tagLine': instance.tagLine,
      'splashScreenTitle': instance.splashScreenTitle,
      'profileName': instance.profileName,
      'profileVersion': instance.profileVersion,
      'published': instance.published.toIso8601String(),
      'profileId': instance.profileId,
      'customerPlan': instance.customerPlan,
      'primaryColor': instance.primaryColor,
    };

const _$WalletAppTypeEnumMap = {
  WalletAppType.altme: 'altme',
  WalletAppType.talao: 'talao',
  WalletAppType.talao4eu: 'talao4eu',
};

HelpCenterOptions _$HelpCenterOptionsFromJson(Map<String, dynamic> json) =>
    HelpCenterOptions(
      customChatSupport: json['customChatSupport'] as bool,
      customEmailSupport: json['customEmailSupport'] as bool,
      displayChatSupport: json['displayChatSupport'] as bool,
      displayEmailSupport: json['displayEmailSupport'] as bool,
      displayNotification: json['displayNotification'] as bool,
      customChatSupportName: json['customChatSupportName'] as String?,
      customEmail: json['customEmail'] as String?,
      customNotification: json['customNotification'] as bool?,
      customNotificationRoom: json['customNotificationRoom'] as String?,
    );

Map<String, dynamic> _$HelpCenterOptionsToJson(HelpCenterOptions instance) =>
    <String, dynamic>{
      'customChatSupport': instance.customChatSupport,
      'customChatSupportName': instance.customChatSupportName,
      'customEmail': instance.customEmail,
      'customEmailSupport': instance.customEmailSupport,
      'displayChatSupport': instance.displayChatSupport,
      'displayEmailSupport': instance.displayEmailSupport,
      'displayNotification': instance.displayNotification,
      'customNotification': instance.customNotification,
      'customNotificationRoom': instance.customNotificationRoom,
    };

SelfSovereignIdentityOptions _$SelfSovereignIdentityOptionsFromJson(
        Map<String, dynamic> json) =>
    SelfSovereignIdentityOptions(
      customOidc4vcProfile: CustomOidc4VcProfile.fromJson(
          json['customOidc4vcProfile'] as Map<String, dynamic>),
      displayManageDecentralizedId:
          json['displayManageDecentralizedId'] as bool,
    );

Map<String, dynamic> _$SelfSovereignIdentityOptionsToJson(
        SelfSovereignIdentityOptions instance) =>
    <String, dynamic>{
      'customOidc4vcProfile': instance.customOidc4vcProfile,
      'displayManageDecentralizedId': instance.displayManageDecentralizedId,
    };

CustomOidc4VcProfile _$CustomOidc4VcProfileFromJson(
        Map<String, dynamic> json) =>
    CustomOidc4VcProfile(
      clientAuthentication: $enumDecode(
          _$ClientAuthenticationEnumMap, json['clientAuthentication']),
      credentialManifestSupport:
          json['credentialManifestSupport'] as bool? ?? false,
      cryptoHolderBinding: json['cryptoHolderBinding'] as bool,
      defaultDid: $enumDecode(_$DidKeyTypeEnumMap, json['defaultDid']),
      oidc4vciDraft:
          $enumDecode(_$OIDC4VCIDraftTypeEnumMap, json['oidc4vciDraft']),
      oidc4vpDraft:
          $enumDecode(_$OIDC4VPDraftTypeEnumMap, json['oidc4vpDraft']),
      scope: json['scope'] as bool,
      securityLevel: json['securityLevel'] as bool,
      siopv2Draft: $enumDecode(_$SIOPV2DraftTypeEnumMap, json['siopv2Draft']),
      clientType: $enumDecode(_$ClientTypeEnumMap, json['subjectSyntaxeType']),
      clientId: json['client_id'] as String? ?? Parameters.clientId,
      clientSecret: json['client_secret'] as String? ?? 'FGbzMrvUpeFr',
      vcFormatType:
          $enumDecodeNullable(_$VCFormatTypeEnumMap, json['vcFormat']) ??
              VCFormatType.jwtVcJson,
      proofHeader:
          $enumDecodeNullable(_$ProofHeaderTypeEnumMap, json['proofHeader']) ??
              ProofHeaderType.kid,
      proofType: $enumDecodeNullable(_$ProofTypeEnumMap, json['proofType']) ??
          ProofType.jwt,
      pushAuthorizationRequest:
          json['pushAuthorizationRequest'] as bool? ?? false,
      statusListCache: json['statusListCache'] as bool? ?? true,
      dpopSupport: json['dpopSupport'] as bool? ?? false,
      formatsSupported: (json['formatsSupported'] as List<dynamic>?)
              ?.map((e) => $enumDecode(_$VCFormatTypeEnumMap, e))
              .toList() ??
          const [],
      displayMode: json['displayMode'] as bool? ?? true,
    );

Map<String, dynamic> _$CustomOidc4VcProfileToJson(
        CustomOidc4VcProfile instance) =>
    <String, dynamic>{
      'clientAuthentication':
          _$ClientAuthenticationEnumMap[instance.clientAuthentication]!,
      'credentialManifestSupport': instance.credentialManifestSupport,
      'client_id': instance.clientId,
      'client_secret': instance.clientSecret,
      'cryptoHolderBinding': instance.cryptoHolderBinding,
      'defaultDid': _$DidKeyTypeEnumMap[instance.defaultDid]!,
      'oidc4vciDraft': _$OIDC4VCIDraftTypeEnumMap[instance.oidc4vciDraft]!,
      'oidc4vpDraft': _$OIDC4VPDraftTypeEnumMap[instance.oidc4vpDraft]!,
      'scope': instance.scope,
      'proofHeader': _$ProofHeaderTypeEnumMap[instance.proofHeader]!,
      'securityLevel': instance.securityLevel,
      'statusListCache': instance.statusListCache,
      'pushAuthorizationRequest': instance.pushAuthorizationRequest,
      'siopv2Draft': _$SIOPV2DraftTypeEnumMap[instance.siopv2Draft]!,
      'subjectSyntaxeType': _$ClientTypeEnumMap[instance.clientType]!,
      'vcFormat': _$VCFormatTypeEnumMap[instance.vcFormatType]!,
      'formatsSupported': instance.formatsSupported
          ?.map((e) => _$VCFormatTypeEnumMap[e]!)
          .toList(),
      'proofType': _$ProofTypeEnumMap[instance.proofType]!,
      'dpopSupport': instance.dpopSupport,
      'displayMode': instance.displayMode,
    };

const _$ClientAuthenticationEnumMap = {
  ClientAuthentication.none: 'none',
  ClientAuthentication.clientSecretBasic: 'client_secret_basic',
  ClientAuthentication.clientSecretPost: 'client_secret_post',
  ClientAuthentication.clientId: 'client_id',
  ClientAuthentication.clientSecretJwt: 'client_secret_jwt',
};

const _$DidKeyTypeEnumMap = {
  DidKeyType.edDSA: 'did:key:eddsa',
  DidKeyType.secp256k1: 'did:key:secp256k1',
  DidKeyType.p256: 'did:key:p-256',
  DidKeyType.ebsiv3: 'did:key:ebsi',
  DidKeyType.ebsiv4: 'ebsiv4',
  DidKeyType.jwkP256: 'did:jwk:p-256',
  DidKeyType.jwtClientAttestation:
      'urn:ietf:params:oauth:client-assertion-type:jwt-client-attestation',
};

const _$OIDC4VCIDraftTypeEnumMap = {
  OIDC4VCIDraftType.draft11: '11',
  OIDC4VCIDraftType.draft13: '13',
  OIDC4VCIDraftType.draft14: '14',
  OIDC4VCIDraftType.draft15: '15',
  OIDC4VCIDraftType.draft16: '16',
};

const _$OIDC4VPDraftTypeEnumMap = {
  OIDC4VPDraftType.draft10: '10',
  OIDC4VPDraftType.draft13: '13',
  OIDC4VPDraftType.draft18: '18',
  OIDC4VPDraftType.draft20: '20',
  OIDC4VPDraftType.draft21: '21',
  OIDC4VPDraftType.draft22: '22',
  OIDC4VPDraftType.draft23: '23',
  OIDC4VPDraftType.draft25: '25',
  OIDC4VPDraftType.draft28: '28',
  OIDC4VPDraftType.draft29: '29',
};

const _$SIOPV2DraftTypeEnumMap = {
  SIOPV2DraftType.draft12: '12',
};

const _$ClientTypeEnumMap = {
  ClientType.p256JWKThumprint: 'urn:ietf:params:oauth:jwk-thumbprint',
  ClientType.did: 'did',
  ClientType.confidential: 'confidential',
};

const _$ProofHeaderTypeEnumMap = {
  ProofHeaderType.kid: 'kid',
  ProofHeaderType.jwk: 'jwk',
};

const _$ProofTypeEnumMap = {
  ProofType.ldpVp: 'ldp_vp',
  ProofType.jwt: 'jwt',
};

SettingsMenu _$SettingsMenuFromJson(Map<String, dynamic> json) => SettingsMenu(
      displayDeveloperMode: json['displayDeveloperMode'] as bool,
      displayHelpCenter: json['displayHelpCenter'] as bool,
      displayProfile: json['displayProfile'] as bool,
      displaySelfSovereignIdentity:
          json['displaySelfSovereignIdentity'] as bool? ?? true,
      displayActivityLog: json['displayActivityLog'] as bool? ?? true,
    );

Map<String, dynamic> _$SettingsMenuToJson(SettingsMenu instance) =>
    <String, dynamic>{
      'displayDeveloperMode': instance.displayDeveloperMode,
      'displayHelpCenter': instance.displayHelpCenter,
      'displayProfile': instance.displayProfile,
      'displaySelfSovereignIdentity': instance.displaySelfSovereignIdentity,
      'displayActivityLog': instance.displayActivityLog,
    };

WalletSecurityOptions _$WalletSecurityOptionsFromJson(
        Map<String, dynamic> json) =>
    WalletSecurityOptions(
      confirmSecurityVerifierAccess:
          json['confirmSecurityVerifierAccess'] as bool,
      displaySecurityAdvancedSettings:
          json['displaySecurityAdvancedSettings'] as bool,
      secureSecurityAuthenticationWithPinCode:
          json['secureSecurityAuthenticationWithPinCode'] as bool,
      verifySecurityIssuerWebsiteIdentity:
          json['verifySecurityIssuerWebsiteIdentity'] as bool,
    );

Map<String, dynamic> _$WalletSecurityOptionsToJson(
        WalletSecurityOptions instance) =>
    <String, dynamic>{
      'confirmSecurityVerifierAccess': instance.confirmSecurityVerifierAccess,
      'displaySecurityAdvancedSettings':
          instance.displaySecurityAdvancedSettings,
      'secureSecurityAuthenticationWithPinCode':
          instance.secureSecurityAuthenticationWithPinCode,
      'verifySecurityIssuerWebsiteIdentity':
          instance.verifySecurityIssuerWebsiteIdentity,
    };
