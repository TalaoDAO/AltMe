part of 'kyc_verification_cubit.dart';

@JsonSerializable()
class KycVerificationState extends Equatable {
  const KycVerificationState({this.status = KycVerificationStatus.unverified});

  factory KycVerificationState.fromJson(Map<String, dynamic> json) =>
      _$KycVerificationStateFromJson(json);

  final KycVerificationStatus status;

  Map<String, dynamic> toJson() => _$KycVerificationStateToJson(this);

  KycVerificationState copyWith({KycVerificationStatus? status}) {
    return KycVerificationState(status: status ?? this.status);
  }

  @override
  List<Object?> get props => [status];
}
