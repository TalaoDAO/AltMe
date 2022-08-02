part of 'credential_details_cubit.dart';

@JsonSerializable()
class CredentialDetailsState extends Equatable {
  const CredentialDetailsState({
    this.status = AppStatus.init,
    this.credentialStatus = CredentialStatus.pending,
  });

  factory CredentialDetailsState.fromJson(Map<String, dynamic> json) =>
      _$CredentialDetailsStateFromJson(json);

  final AppStatus status;
  final CredentialStatus credentialStatus;

  CredentialDetailsState copyWith({
    AppStatus? status,
    CredentialStatus? credentialStatus,
    String? title,
  }) {
    return CredentialDetailsState(
      status: status ?? this.status,
      credentialStatus: credentialStatus ?? this.credentialStatus,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialDetailsStateToJson(this);

  @override
  List<Object?> get props => [credentialStatus, status];
}
