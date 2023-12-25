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
          selfSovereignIdentityOptions: SelfSovereignIdentityOptions(
            displayManageDecentralizedId: true,
            customOidc4vcProfile: CustomOidc4VcProfile(
              clientAuthentication: ClientAuthentication.clientSecretPost,
              credentialManifestSupport: false,
              cryptoHolderBinding: true,
              defaultDid: DidKeyType.ebsiv3,
              oidc4vciDraft: OIDC4VCIDraftType.draft11,
              oidc4vpDraft: OIDC4VPDraftType.draft10,
              scope: false,
              securityLevel: false,
              siopv2Draft: SIOPV2DraftType.draft12,
              subjectSyntaxeType: SubjectSyntax.did,
              userPinDigits: UserPinDigits.four,
              clientId: clientId,
              clientSecret: clientSecret,
            ),
          ),
          settingsMenu: SettingsMenu.initial(),
          version: '',
          walletSecurityOptions: WalletSecurityOptions.initial(),
        ),
      );

  factory ProfileModel.dutch({
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
        profileType: ProfileType.dutch,
        profileSetting: ProfileSetting(
          blockchainOptions: BlockchainOptions.initial(),
          generalOptions: GeneralOptions.empty(),
          helpCenterOptions: HelpCenterOptions.initial(),
          selfSovereignIdentityOptions: SelfSovereignIdentityOptions(
            displayManageDecentralizedId: true,
            customOidc4vcProfile: CustomOidc4VcProfile(
              clientAuthentication: ClientAuthentication.clientSecretPost,
              credentialManifestSupport: false,
              cryptoHolderBinding: true,
              defaultDid: DidKeyType.jwkP256,
              oidc4vciDraft: OIDC4VCIDraftType.draft11,
              oidc4vpDraft: OIDC4VPDraftType.draft10,
              scope: false,
              securityLevel: false,
              siopv2Draft: SIOPV2DraftType.draft12,
              subjectSyntaxeType: SubjectSyntax.did,
              userPinDigits: UserPinDigits.four,
              clientId: clientId,
              clientSecret: clientSecret,
            ),
          ),
          settingsMenu: SettingsMenu.initial(),
          version: '',
          walletSecurityOptions: WalletSecurityOptions.initial(),
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
