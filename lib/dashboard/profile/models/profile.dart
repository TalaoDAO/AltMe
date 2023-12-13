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
    required this.userConsentForIssuerAccess,
    required this.userConsentForVerifierAccess,
    required this.userPINCodeForAuthentication,
    required this.enableJWKThumbprint,
    required this.enableCryptographicHolderBinding,
    required this.enableCredentialManifestSupport,
    required this.useBasicClientAuthentication,
    required this.isDeveloperMode,
    required this.clientId,
    required this.clientSecret,
    required this.profileType,
    required this.draftType,
    required this.profileSetting,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.empty() => ProfileModel(
        polygonIdNetwork: PolygonIdNetwork.PolygonMainnet.toString(),
        walletType: WalletType.personal.toString(),
        walletProtectionType: WalletProtectionType.pinCode.toString(),
        userConsentForIssuerAccess: true,
        userConsentForVerifierAccess: true,
        userPINCodeForAuthentication: true,
        isDeveloperMode: false,
        enableJWKThumbprint: false,
        enableCryptographicHolderBinding: true,
        enableCredentialManifestSupport: true,
        useBasicClientAuthentication: false,
        clientId: Parameters.clientId,
        clientSecret: Parameters.clientSecret,
        profileType: ProfileType.custom.toString(),
        draftType: OIDC4VCIDraftType.draft11.toString(),
        profileSetting: ProfileSetting.initial(),
      );

  factory ProfileModel.ebsiV3(ProfileModel oldModel) => ProfileModel(
        polygonIdNetwork: oldModel.polygonIdNetwork,
        walletType: oldModel.walletType,
        walletProtectionType: oldModel.walletProtectionType,
        userConsentForIssuerAccess: oldModel.userConsentForVerifierAccess,
        userConsentForVerifierAccess: oldModel.userConsentForVerifierAccess,
        userPINCodeForAuthentication: oldModel.userPINCodeForAuthentication,
        isDeveloperMode: oldModel.isDeveloperMode,
        enableJWKThumbprint: false,
        enableCryptographicHolderBinding: true,
        enableCredentialManifestSupport: false,
        useBasicClientAuthentication: false,
        clientId: oldModel.clientId,
        clientSecret: oldModel.clientSecret,
        profileType: ProfileType.ebsiV3.toString(),
        draftType: OIDC4VCIDraftType.draft11.toString(),
        profileSetting: ProfileSetting(
          blockchainOptions: BlockchainOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          selfSovereignIdentityOptions: const SelfSovereignIdentityOptions(
            displayManageDecentralizedId: true,
            displaySsiAdvancedSettings: false,
            displayVerifiableDataRegistry: true,
            oidv4vcProfile: 'ebsi',
            customOidc4vcProfile: CustomOidc4VcProfile(
              clientAuthentication: ClientAuthentication.none,
              credentialManifestSupport: false,
              cryptoHolderBinding: true,
              defaultDid: DidKeyType.ebsiv3,
              oidc4vciDraft: OIDC4VCIDraftType.draft11,
              oidc4vpDraft: OIDC4VPDraftType.draft10,
              scope: false,
              securityLevel: SecurityLevel.low,
              siopv2Draft: SIOPV2DraftType.draft12,
              subjectSyntaxeType: SubjectSyntax.did,
              userPinDigits: UserPinDigits.four,
            ),
          ),
          settingsMenu: SettingsMenu.initial(),
          version: oldModel.profileSetting.version,
          walletSecurityOptions: WalletSecurityOptions.initial(),
        ),
      );

  factory ProfileModel.dutch(ProfileModel oldModel) => ProfileModel(
        polygonIdNetwork: oldModel.polygonIdNetwork,
        walletType: oldModel.walletType,
        walletProtectionType: oldModel.walletProtectionType,
        userConsentForIssuerAccess: oldModel.userConsentForVerifierAccess,
        userConsentForVerifierAccess: oldModel.userConsentForVerifierAccess,
        userPINCodeForAuthentication: oldModel.userPINCodeForAuthentication,
        isDeveloperMode: oldModel.isDeveloperMode,
        enableJWKThumbprint: false,
        enableCryptographicHolderBinding: true,
        enableCredentialManifestSupport: false,
        useBasicClientAuthentication: false,
        clientId: oldModel.clientId,
        clientSecret: oldModel.clientSecret,
        profileType: ProfileType.dutch.toString(),
        draftType: OIDC4VCIDraftType.draft11.toString(),
        profileSetting: ProfileSetting(
          blockchainOptions: BlockchainOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          selfSovereignIdentityOptions: const SelfSovereignIdentityOptions(
            displayManageDecentralizedId: true,
            displaySsiAdvancedSettings: false,
            displayVerifiableDataRegistry: true,
            oidv4vcProfile: 'diip',
            customOidc4vcProfile: CustomOidc4VcProfile(
              clientAuthentication: ClientAuthentication.none,
              credentialManifestSupport: false,
              cryptoHolderBinding: true,
              defaultDid: DidKeyType.jwkP256,
              oidc4vciDraft: OIDC4VCIDraftType.draft11,
              oidc4vpDraft: OIDC4VPDraftType.draft10,
              scope: false,
              securityLevel: SecurityLevel.low,
              siopv2Draft: SIOPV2DraftType.draft12,
              subjectSyntaxeType: SubjectSyntax.did,
              userPinDigits: UserPinDigits.four,
            ),
          ),
          settingsMenu: SettingsMenu.initial(),
          version: oldModel.profileSetting.version,
          walletSecurityOptions: WalletSecurityOptions.initial(),
        ),
      );

  final String polygonIdNetwork;
  final String walletType;
  final String walletProtectionType;
  final bool isDeveloperMode;
  final ProfileSetting profileSetting;

  final bool userConsentForIssuerAccess; //
  final bool userConsentForVerifierAccess; //
  final bool userPINCodeForAuthentication; // //
  final bool enableJWKThumbprint;
  final bool enableCryptographicHolderBinding; //
  final bool enableCredentialManifestSupport; //
  final bool useBasicClientAuthentication; //
  final String clientId; //
  final String clientSecret; //
  final String profileType;
  final String draftType; //

  @override
  List<Object> get props => [
        polygonIdNetwork,
        walletType,
        walletProtectionType,
        userConsentForIssuerAccess,
        userConsentForVerifierAccess,
        userPINCodeForAuthentication,
        isDeveloperMode,
        enableJWKThumbprint,
        enableCryptographicHolderBinding,
        enableCredentialManifestSupport,
        useBasicClientAuthentication,
        clientId,
        clientSecret,
        profileType,
        draftType,
        profileSetting,
      ];

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    String? polygonIdNetwork,
    TezosNetwork? tezosNetwork,
    String? walletType,
    String? walletProtectionType,
    bool? userConsentForIssuerAccess,
    bool? userConsentForVerifierAccess,
    bool? userPINCodeForAuthentication,
    bool? isDeveloperMode,
    bool? enableJWKThumbprint,
    bool? enableCryptographicHolderBinding,
    bool? enableCredentialManifestSupport,
    bool? useBasicClientAuthentication,
    String? clientId,
    String? clientSecret,
    String? profileType,
    String? draftType,
    ProfileSetting? profileSetting,
  }) {
    return ProfileModel(
      polygonIdNetwork: polygonIdNetwork ?? this.polygonIdNetwork,
      walletType: walletType ?? this.walletType,
      walletProtectionType: walletProtectionType ?? this.walletProtectionType,
      enableJWKThumbprint: enableJWKThumbprint ?? this.enableJWKThumbprint,
      enableCryptographicHolderBinding: enableCryptographicHolderBinding ??
          this.enableCryptographicHolderBinding,
      enableCredentialManifestSupport: enableCredentialManifestSupport ??
          this.enableCredentialManifestSupport,
      useBasicClientAuthentication:
          useBasicClientAuthentication ?? this.useBasicClientAuthentication,
      clientId: clientId ?? this.clientId,
      clientSecret: clientSecret ?? this.clientSecret,
      userConsentForIssuerAccess:
          userConsentForIssuerAccess ?? this.userConsentForIssuerAccess,
      userConsentForVerifierAccess:
          userConsentForVerifierAccess ?? this.userConsentForVerifierAccess,
      userPINCodeForAuthentication:
          userPINCodeForAuthentication ?? this.userPINCodeForAuthentication,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      profileType: profileType ?? this.profileType,
      draftType: draftType ?? this.draftType,
      profileSetting: profileSetting ?? this.profileSetting,
    );
  }
}
