part of 'credential_details_cubit.dart';

@JsonSerializable()
class CredentialDetailsState extends Equatable {
  const CredentialDetailsState({
    this.status = AppStatus.init,
    this.verificationState = VerificationState.Unverified,
    this.title = '',
  });

  factory CredentialDetailsState.fromJson(Map<String, dynamic> json) =>
      _$CredentialDetailsStateFromJson(json);

  final AppStatus status;
  final VerificationState verificationState;
  final String? title;

  CredentialDetailsState copyWith({
    AppStatus? status,
    VerificationState? verificationState,
    String? title,
  }) {
    return CredentialDetailsState(
      status: status ?? this.status,
      verificationState: verificationState ?? this.verificationState,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialDetailsStateToJson(this);

  @override
  List<Object?> get props => [verificationState, status, title];
}
