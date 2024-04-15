part of 'credential_details_cubit.dart';

@JsonSerializable()
class CredentialDetailsState extends Equatable {
  const CredentialDetailsState({
    this.status = AppStatus.init,
    this.message,
    this.credentialStatus,
    this.credentialDetailTabStatus = CredentialDetailTabStatus.informations,
    this.statusListUrl,
    this.statusListIndex,
  });

  factory CredentialDetailsState.fromJson(Map<String, dynamic> json) =>
      _$CredentialDetailsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final CredentialStatus? credentialStatus;
  final CredentialDetailTabStatus credentialDetailTabStatus;
  final String? statusListUrl;
  final int? statusListIndex;

  CredentialDetailsState loading() {
    return copyWith(status: AppStatus.loading);
  }

  CredentialDetailsState error({
    required StateMessage message,
  }) {
    return copyWith(status: AppStatus.error, message: message);
  }

  CredentialDetailsState copyWith({
    AppStatus? status,
    StateMessage? message,
    CredentialStatus? credentialStatus,
    CredentialDetailTabStatus? credentialDetailTabStatus,
    String? statusListUrl,
    int? statusListIndex,
  }) {
    return CredentialDetailsState(
      status: status ?? this.status,
      message: message,
      credentialStatus: credentialStatus ?? this.credentialStatus,
      credentialDetailTabStatus:
          credentialDetailTabStatus ?? this.credentialDetailTabStatus,
      statusListUrl: statusListUrl ?? this.statusListUrl,
      statusListIndex: statusListIndex ?? this.statusListIndex,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialDetailsStateToJson(this);

  @override
  List<Object?> get props => [
        credentialStatus,
        message,
        status,
        credentialDetailTabStatus,
        statusListUrl,
        statusListIndex,
      ];
}
