part of 'software_license_cubit.dart';

@JsonSerializable()
class SoftwareLicenseState extends Equatable {
  SoftwareLicenseState({
    this.status = AppStatus.init,
    List<LicenseModel>? licenses,
  }) : licenses = licenses ?? <LicenseModel>[];

  factory SoftwareLicenseState.fromJson(Map<String, dynamic> json) =>
      _$SoftwareLicenseStateFromJson(json);

  final AppStatus status;
  final List<LicenseModel> licenses;

  SoftwareLicenseState loading() {
    return copyWith(
      status: AppStatus.loading,
      licenses: licenses,
    );
  }

  SoftwareLicenseState copyWith({
    AppStatus? status,
    List<LicenseModel>? licenses,
  }) {
    return SoftwareLicenseState(
      status: status ?? this.status,
      licenses: licenses ?? this.licenses,
    );
  }

  Map<String, dynamic> toJson() => _$SoftwareLicenseStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        licenses,
      ];
}
