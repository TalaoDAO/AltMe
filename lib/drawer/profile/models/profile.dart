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
    required this.issuerVerificationSetting,
    required this.isEnterprise,
    this.companyName = '',
    this.companyWebsite = '',
    this.jobTitle = '',
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  factory ProfileModel.empty() => const ProfileModel(
        firstName: '',
        lastName: '',
        phone: '',
        location: '',
        email: '',
        companyName: '',
        companyWebsite: '',
        jobTitle: '',
        issuerVerificationSetting: true,
        isEnterprise: false,
      );

  final String firstName;
  final String lastName;
  final String phone;
  final String location;
  final String email;
  final String companyName;
  final String companyWebsite;
  final String jobTitle;
  final bool issuerVerificationSetting;
  final bool isEnterprise;

  @override
  List<Object> get props => [
        firstName,
        lastName,
        phone,
        location,
        email,
        issuerVerificationSetting,
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
    bool? issuerVerificationSetting,
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
      issuerVerificationSetting:
          issuerVerificationSetting ?? this.issuerVerificationSetting,
      isEnterprise: isEnterprise ?? this.isEnterprise,
    );
  }
}
