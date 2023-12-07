import 'package:altme/app/app.dart';
import 'package:altme/l10n/l10n.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:oidc4vc/oidc4vc.dart';

part 'profile.g.dart';

enum ProfileType {
  custom,
  ebsiV3,
  dutch,
}

extension ProfileTypeX on ProfileType {
  String getTitle(AppLocalizations l10n) {
    switch (this) {
      case ProfileType.custom:
        return l10n.profileCustom;
      case ProfileType.ebsiV3:
        return l10n.profileEbsiV3;
      case ProfileType.dutch:
        return l10n.profileDutchBlockchainCoalition;
    }
  }
}

@JsonSerializable()
class ProfileModel extends Equatable {
  const ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.location,
    required this.email,
    required this.polygonIdNetwork,
    required this.didKeyType,
    required this.walletType,
    required this.walletProtectionType,
    required this.userConsentForIssuerAccess,
    required this.userConsentForVerifierAccess,
    required this.userPINCodeForAuthentication,
    required this.enableJWKThumbprint,
    required this.enableCryptographicHolderBinding,
    required this.enableScopeParameter,
    required this.useBasicClientAuthentication,
    this.companyName = '',
    this.companyWebsite = '',
    this.jobTitle = '',
    required this.enableSecurity,
    required this.isDeveloperMode,
    required this.enable4DigitPINCode,
    required this.clientId,
    required this.clientSecret,
    required this.profileType,
    required this.draftType,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.empty() => ProfileModel(
        firstName: '',
        lastName: '',
        phone: '',
        location: '',
        email: '',
        companyName: '',
        companyWebsite: '',
        jobTitle: '',
        polygonIdNetwork: PolygonIdNetwork.PolygonMainnet.toString(),
        walletType: WalletType.personal.toString(),
        walletProtectionType: WalletProtectionType.pinCode.toString(),
        userConsentForIssuerAccess: true,
        userConsentForVerifierAccess: true,
        userPINCodeForAuthentication: true,
        didKeyType: DidKeyType.p256.toString(),
        enableSecurity: false,
        isDeveloperMode: false,
        enable4DigitPINCode: false,
        enableJWKThumbprint: false,
        enableCryptographicHolderBinding: true,
        enableScopeParameter: false,
        useBasicClientAuthentication: false,
        clientId: Parameters.clientId,
        clientSecret: Parameters.clientSecret,
        profileType: ProfileType.custom.toString(),
        draftType: DraftType.draft11.toString(),
      );

  factory ProfileModel.ebsiV3(ProfileModel oldModel) => ProfileModel(
        firstName: oldModel.firstName,
        lastName: oldModel.lastName,
        phone: oldModel.phone,
        location: oldModel.location,
        email: oldModel.email,
        companyName: oldModel.companyName,
        companyWebsite: oldModel.companyWebsite,
        jobTitle: oldModel.jobTitle,
        polygonIdNetwork: oldModel.polygonIdNetwork,
        walletType: oldModel.walletType,
        walletProtectionType: oldModel.walletProtectionType,
        userConsentForIssuerAccess: oldModel.userConsentForVerifierAccess,
        userConsentForVerifierAccess: oldModel.userConsentForVerifierAccess,
        userPINCodeForAuthentication: oldModel.userPINCodeForAuthentication,
        didKeyType: DidKeyType.ebsiv3.toString(),
        enableSecurity: false,
        isDeveloperMode: oldModel.isDeveloperMode,
        enable4DigitPINCode: true,
        enableJWKThumbprint: false,
        enableCryptographicHolderBinding: true,
        enableScopeParameter: false,
        useBasicClientAuthentication: false,
        clientId: oldModel.clientId,
        clientSecret: oldModel.clientSecret,
        profileType: ProfileType.ebsiV3.toString(),
        draftType: DraftType.draft11.toString(),
      );

  factory ProfileModel.dutch(ProfileModel oldModel) => ProfileModel(
        firstName: oldModel.firstName,
        lastName: oldModel.lastName,
        phone: oldModel.phone,
        location: oldModel.location,
        email: oldModel.email,
        companyName: oldModel.companyName,
        companyWebsite: oldModel.companyWebsite,
        jobTitle: oldModel.jobTitle,
        polygonIdNetwork: oldModel.polygonIdNetwork,
        walletType: oldModel.walletType,
        walletProtectionType: oldModel.walletProtectionType,
        userConsentForIssuerAccess: oldModel.userConsentForVerifierAccess,
        userConsentForVerifierAccess: oldModel.userConsentForVerifierAccess,
        userPINCodeForAuthentication: oldModel.userPINCodeForAuthentication,
        didKeyType: DidKeyType.jwkP256.toString(),
        enableSecurity: false,
        isDeveloperMode: oldModel.isDeveloperMode,
        enable4DigitPINCode: true,
        enableJWKThumbprint: false,
        enableCryptographicHolderBinding: true,
        enableScopeParameter: false,
        useBasicClientAuthentication: false,
        clientId: oldModel.clientId,
        clientSecret: oldModel.clientSecret,
        profileType: ProfileType.dutch.toString(),
        draftType: DraftType.draft11.toString(),
      );

  final String firstName;
  final String lastName;
  final String phone;
  final String location;
  final String email;
  final String companyName;
  final String companyWebsite;
  final String jobTitle;
  final String polygonIdNetwork;
  final String didKeyType;
  final String walletType;
  final String walletProtectionType;
  final bool userConsentForIssuerAccess;
  final bool userConsentForVerifierAccess;
  final bool userPINCodeForAuthentication;

  final bool enableSecurity;
  final bool isDeveloperMode;
  final bool enable4DigitPINCode;
  final bool enableJWKThumbprint;
  final bool enableCryptographicHolderBinding;
  final bool enableScopeParameter;
  final bool useBasicClientAuthentication;
  final String clientId;
  final String clientSecret;
  final String profileType;
  final String draftType;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phone,
        location,
        email,
        polygonIdNetwork,
        didKeyType,
        companyName,
        companyWebsite,
        jobTitle,
        walletType,
        walletProtectionType,
        userConsentForIssuerAccess,
        userConsentForVerifierAccess,
        userPINCodeForAuthentication,
        enableSecurity,
        isDeveloperMode,
        enable4DigitPINCode,
        enableJWKThumbprint,
        enableCryptographicHolderBinding,
        enableScopeParameter,
        useBasicClientAuthentication,
        clientId,
        clientSecret,
        profileType,
        draftType,
      ];

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  ProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? phone,
    String? location,
    String? email,
    String? companyName,
    String? companyWebsite,
    String? jobTitle,
    String? polygonIdNetwork,
    TezosNetwork? tezosNetwork,
    String? didKeyType,
    String? walletType,
    String? walletProtectionType,
    bool? userConsentForIssuerAccess,
    bool? userConsentForVerifierAccess,
    bool? userPINCodeForAuthentication,
    bool? enableSecurity,
    bool? isDeveloperMode,
    bool? enable4DigitPINCode,
    bool? enableJWKThumbprint,
    bool? enableCryptographicHolderBinding,
    bool? enableScopeParameter,
    bool? useBasicClientAuthentication,
    String? clientId,
    String? clientSecret,
    String? profileType,
    String? draftType,
  }) {
    return ProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      email: email ?? this.email,
      companyName: companyName ?? this.companyName,
      companyWebsite: companyWebsite ?? this.companyWebsite,
      jobTitle: jobTitle ?? this.jobTitle,
      polygonIdNetwork: polygonIdNetwork ?? this.polygonIdNetwork,
      didKeyType: didKeyType ?? this.didKeyType,
      walletType: walletType ?? this.walletType,
      walletProtectionType: walletProtectionType ?? this.walletProtectionType,
      enableJWKThumbprint: enableJWKThumbprint ?? this.enableJWKThumbprint,
      enableCryptographicHolderBinding: enableCryptographicHolderBinding ??
          this.enableCryptographicHolderBinding,
      enableScopeParameter: enableScopeParameter ?? this.enableScopeParameter,
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
      enableSecurity: enableSecurity ?? this.enableSecurity,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      enable4DigitPINCode: enable4DigitPINCode ?? this.enable4DigitPINCode,
      profileType: profileType ?? this.profileType,
      draftType: draftType ?? this.draftType,
    );
  }
}
