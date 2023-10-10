import 'package:altme/app/app.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@JsonSerializable()
class ProfileModel extends Equatable {
  const ProfileModel({
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.location,
    required this.email,
    required this.polygonIdNetwork,
    required this.tezosNetwork,
    required this.didKeyType,
    required this.isEnterprise,
    required this.isBiometricEnabled,
    required this.userConsentForIssuerAccess,
    required this.userConsentForVerifierAccess,
    required this.userPINCodeForAuthentication,
    required this.enableJWKThumbprint,
    this.companyName = '',
    this.companyWebsite = '',
    this.jobTitle = '',
    required this.isSecurityLow,
    required this.isDeveloperMode,
    required this.userPinDigitsLength,
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
        isEnterprise: false,
        isBiometricEnabled: false,
        userConsentForIssuerAccess: true,
        userConsentForVerifierAccess: true,
        userPINCodeForAuthentication: true,
        tezosNetwork: TezosNetwork.mainNet(),
        didKeyType: DidKeyType.p256.toString(),
        isSecurityLow: true,
        isDeveloperMode: false,
        userPinDigitsLength: 6,
        enableJWKThumbprint: false,
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
  final TezosNetwork tezosNetwork;
  final String didKeyType;
  final bool isEnterprise;
  final bool isBiometricEnabled;
  final bool userConsentForIssuerAccess;
  final bool userConsentForVerifierAccess;
  final bool userPINCodeForAuthentication;

  final bool isSecurityLow;
  final bool isDeveloperMode;
  final int userPinDigitsLength;
  final bool enableJWKThumbprint;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phone,
        location,
        email,
        polygonIdNetwork,
        tezosNetwork,
        didKeyType,
        companyName,
        companyWebsite,
        jobTitle,
        isEnterprise,
        isBiometricEnabled,
        userConsentForIssuerAccess,
        userConsentForVerifierAccess,
        userPINCodeForAuthentication,
        isSecurityLow,
        isDeveloperMode,
        userPinDigitsLength,
        enableJWKThumbprint,
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
    bool? isEnterprise,
    bool? isBiometricEnabled,
    bool? userConsentForIssuerAccess,
    bool? userConsentForVerifierAccess,
    bool? userPINCodeForAuthentication,
    bool? isSecurityLow,
    bool? isDeveloperMode,
    int? userPinDigitsLength,
    bool? enableJWKThumbprint,
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
      tezosNetwork: tezosNetwork ?? this.tezosNetwork,
      didKeyType: didKeyType ?? this.didKeyType,
      isEnterprise: isEnterprise ?? this.isEnterprise,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      enableJWKThumbprint: enableJWKThumbprint ?? this.enableJWKThumbprint,
      userConsentForIssuerAccess:
          userConsentForIssuerAccess ?? this.userConsentForIssuerAccess,
      userConsentForVerifierAccess:
          userConsentForVerifierAccess ?? this.userConsentForVerifierAccess,
      userPINCodeForAuthentication:
          userPINCodeForAuthentication ?? this.userPINCodeForAuthentication,
      isSecurityLow: isSecurityLow ?? this.isSecurityLow,
      isDeveloperMode: isDeveloperMode ?? this.isDeveloperMode,
      userPinDigitsLength: userPinDigitsLength ?? this.userPinDigitsLength,
    );
  }
}
