part of 'credential_details_cubit.dart';

@JsonSerializable()
class CredentialDetailsState extends Equatable {
  const CredentialDetailsState({
    this.status = AppStatus.init,
    this.credentialStatus = CredentialStatus.pending,
    this.credentialDetailTabStatus = CredentialDetailTabStatus.informations,
  });

  factory CredentialDetailsState.fromJson(Map<String, dynamic> json) =>
      _$CredentialDetailsStateFromJson(json);

  final AppStatus status;
  final CredentialStatus credentialStatus;
  final CredentialDetailTabStatus credentialDetailTabStatus;

  CredentialDetailsState copyWith({
    AppStatus? status,
    CredentialStatus? credentialStatus,
    CredentialDetailTabStatus? credentialDetailTabStatus,
    String? title,
  }) {
    return CredentialDetailsState(
      status: status ?? this.status,
      credentialStatus: credentialStatus ?? this.credentialStatus,
      credentialDetailTabStatus:
          credentialDetailTabStatus ?? this.credentialDetailTabStatus,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialDetailsStateToJson(this);

  @override
  List<Object?> get props =>
      [credentialStatus, status, credentialDetailTabStatus];
}
