part of 'credential_details_cubit.dart';

@JsonSerializable()
class CredentialDetailsState extends Equatable {
  const CredentialDetailsState({
    this.verificationState = VerificationState.Unverified,
    this.title = '',
  });

  factory CredentialDetailsState.fromJson(Map<String, dynamic> json) =>
      _$CredentialDetailsStateFromJson(json);

  final VerificationState verificationState;
  final String? title;

  CredentialDetailsState copyWith({
    VerificationState? verificationState,
    String? title,
  }) {
    return CredentialDetailsState(
      verificationState: verificationState ?? this.verificationState,
      title: title ?? this.title,
    );
  }

  Map<String, dynamic> toJson() => _$CredentialDetailsStateToJson(this);

  @override
  List<Object?> get props => [verificationState, title];
}
