part of 'polygon_id_verification_cubit.dart';

@JsonSerializable()
class PolygonIdVerificationState extends Equatable {
  PolygonIdVerificationState({
    this.status = AppStatus.init,
    this.message,
    this.canGenerateProof = false,
    List<ClaimEntity?>? claimEntities,
  }) : claimEntities = claimEntities ?? [];

  factory PolygonIdVerificationState.fromJson(Map<String, dynamic> json) =>
      _$PolygonIdVerificationStateFromJson(json);

  final AppStatus status;
  final StateMessage? message;
  final bool canGenerateProof;
  final List<ClaimEntity?>? claimEntities;

  PolygonIdVerificationState loading() {
    return PolygonIdVerificationState(
      status: AppStatus.loading,
      canGenerateProof: canGenerateProof,
      claimEntities: claimEntities,
    );
  }

  PolygonIdVerificationState error({
    required MessageHandler messageHandler,
  }) {
    return PolygonIdVerificationState(
      status: AppStatus.error,
      message: StateMessage.error(messageHandler: messageHandler),
      canGenerateProof: canGenerateProof,
      claimEntities: claimEntities,
    );
  }

  PolygonIdVerificationState copyWith({
    required AppStatus status,
    StateMessage? message,
    bool? canGenerateProof,
    List<ClaimEntity?>? claimEntities,
  }) {
    return PolygonIdVerificationState(
      status: status,
      message: message ?? this.message,
      canGenerateProof: canGenerateProof ?? this.canGenerateProof,
      claimEntities: claimEntities ?? this.claimEntities,
    );
  }

  Map<String, dynamic> toJson() => _$PolygonIdVerificationStateToJson(this);

  @override
  List<Object?> get props => [status, canGenerateProof, message, claimEntities];
}
