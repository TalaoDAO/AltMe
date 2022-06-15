import 'package:altme/app/shared/constants/urls.dart';
import 'package:altme/app/shared/tezos_network/models/tezos_network.dart';
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
    required this.issuerVerificationUrl,
    required this.tezosNetwork,
    required this.isEnterprise,
    this.companyName = '',
    this.companyWebsite = '',
    this.jobTitle = '',
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
        issuerVerificationUrl: Urls.checkIssuerTalaoUrl,
        isEnterprise: false,
        tezosNetwork: TezosNetwork.mainNet(),
      );

  final String firstName;
  final String lastName;
  final String phone;
  final String location;
  final String email;
  final String companyName;
  final String companyWebsite;
  final String jobTitle;
  final String issuerVerificationUrl;
  final TezosNetwork tezosNetwork;
  final bool isEnterprise;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phone,
        location,
        email,
        issuerVerificationUrl,
        tezosNetwork,
        companyName,
        companyWebsite,
        jobTitle,
        isEnterprise
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
    String? issuerVerificationUrl,
    TezosNetwork? tezosNetwork,
    bool? isEnterprise,
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
      issuerVerificationUrl:
          issuerVerificationUrl ?? this.issuerVerificationUrl,
      tezosNetwork: tezosNetwork ?? this.tezosNetwork,
      isEnterprise: isEnterprise ?? this.isEnterprise,
    );
  }
}
