part of 'credential_details_cubit.dart';

@JsonSerializable()
class CredentialDetailsState extends Equatable {
  const CredentialDetailsState({
    this.status = AppStatus.init,
    this.message,
    this.credentialStatus,
    this.credentialDetailTabStatus = CredentialDetailTabStatus.informations,
  });

  factory CredentialDetailsState.fromJson(Map<String, dynamic> json) =>
      _$CredentialDetailsStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final CredentialStatus? credentialStatus;
  final CredentialDetailTabStatus credentialDetailTabStatus;

  CredentialDetailsState loading() {
    final loadingState = copyWith(status: AppStatus.loading);
    return loadingState;
  }

  CredentialDetailsState error({required StateMessage message}) {
    final errorState = copyWith(status: AppStatus.error, message: message);
    return errorState;
  }

  CredentialDetailsState copyWith({
    AppStatus? status,
    StateMessage? message,
    CredentialStatus? credentialStatus,
    CredentialDetailTabStatus? credentialDetailTabStatus,
  }) {
    final newState = CredentialDetailsState(
      status: status ?? this.status,
      message: message,
      credentialStatus: credentialStatus ?? this.credentialStatus,
      credentialDetailTabStatus:
          credentialDetailTabStatus ?? this.credentialDetailTabStatus,
    );
    return newState;
  }

  Map<String, dynamic> toJson() => _$CredentialDetailsStateToJson(this);

  @override
  List<Object?> get props => [
    credentialStatus,
    message,
    status,
    credentialDetailTabStatus,
  ];
}
