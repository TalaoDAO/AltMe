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
    required this.isEnterprise,
    required this.isBiometricEnabled,
    required this.isAlertEnabled,
    required this.userConsentForIssuerAccess,
    required this.userConsentForVerifierAccess,
    required this.userPINCodeForAuthentication,
    this.companyName = '',
    this.companyWebsite = '',
    this.jobTitle = '',
    required this.isSecurityLow,
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
        isAlertEnabled: false,
        userConsentForIssuerAccess: true,
        userConsentForVerifierAccess: true,
        userPINCodeForAuthentication: true,
        tezosNetwork: TezosNetwork.mainNet(),
        isSecurityLow: true,
        userPinDigitsLength: 6,
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
  final bool isEnterprise;
  final bool isBiometricEnabled;
  final bool isAlertEnabled;
  final bool userConsentForIssuerAccess;
  final bool userConsentForVerifierAccess;
  final bool userPINCodeForAuthentication;

  final bool isSecurityLow;
  final int userPinDigitsLength;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phone,
        location,
        email,
        polygonIdNetwork,
        tezosNetwork,
        companyName,
        companyWebsite,
        jobTitle,
        isEnterprise,
        isBiometricEnabled,
        isAlertEnabled,
        userConsentForIssuerAccess,
        userConsentForVerifierAccess,
        userPINCodeForAuthentication,
        isSecurityLow,
        userPinDigitsLength,
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
    bool? isEnterprise,
    bool? isBiometricEnabled,
    bool? isAlertEnabled,
    bool? userConsentForIssuerAccess,
    bool? userConsentForVerifierAccess,
    bool? userPINCodeForAuthentication,
    bool? isSecurityLow,
    int? userPinDigitsLength,
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
      isEnterprise: isEnterprise ?? this.isEnterprise,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isAlertEnabled: isAlertEnabled ?? this.isAlertEnabled,
      userConsentForIssuerAccess:
          userConsentForIssuerAccess ?? this.userConsentForIssuerAccess,
      userConsentForVerifierAccess:
          userConsentForVerifierAccess ?? this.userConsentForVerifierAccess,
      userPINCodeForAuthentication:
          userPINCodeForAuthentication ?? this.userPINCodeForAuthentication,
      isSecurityLow: isSecurityLow ?? this.isSecurityLow,
      userPinDigitsLength: userPinDigitsLength ?? this.userPinDigitsLength,
    );
  }
}
