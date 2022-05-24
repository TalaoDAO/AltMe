part of 'profile_checkbox_cubit.dart';

class ProfileCheckboxState {
  const ProfileCheckboxState({
    this.isFirstName = true,
    this.isLastName = true,
    this.isPhone = true,
    this.isLocation = true,
    this.isEmail = true,
    this.isCompanyName = true,
    this.isCompanyWebsite = true,
    this.isJobTitle = true,
  });

  final bool isFirstName;
  final bool isLastName;
  final bool isPhone;
  final bool isLocation;
  final bool isEmail;
  final bool isCompanyName;
  final bool isCompanyWebsite;
  final bool isJobTitle;

  ProfileCheckboxState copyWith({
    bool? isFirstName,
    bool? isLastName,
    bool? isPhone,
    bool? isLocation,
    bool? isEmail,
    bool? isCompanyName,
    bool? isCompanyWebsite,
    bool? isJobTitle,
  }) {
    return ProfileCheckboxState(
      isFirstName: isFirstName ?? this.isFirstName,
      isLastName: isLastName ?? this.isLastName,
      isPhone: isPhone ?? this.isPhone,
      isLocation: isLocation ?? this.isLocation,
      isEmail: isEmail ?? this.isEmail,
      isCompanyName: isCompanyName ?? this.isCompanyName,
      isCompanyWebsite: isCompanyWebsite ?? this.isCompanyWebsite,
      isJobTitle: isJobTitle ?? this.isJobTitle,
    );
  }
}
