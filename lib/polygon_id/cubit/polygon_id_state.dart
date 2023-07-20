part of 'polygon_id_cubit.dart';

@JsonSerializable()
class PolygonIdState extends Equatable {
  const PolygonIdState({
    this.status = AppStatus.init,
    this.polygonAction,
    this.isInitialised = false,
    this.message,
    this.loadingText,
    this.scannedResponse,
    this.claims,
    this.credentialManifests,
  });

  factory PolygonIdState.fromJson(Map<String, dynamic> json) =>
      _$PolygonIdStateFromJson(json);

  final AppStatus status;
  final PolygonIdAction? polygonAction;
  final StateMessage? message;
  @JsonKey(includeFromJson: false, includeToJson: false)
  final MessageHandler? loadingText;
  final bool isInitialised;
  final String? scannedResponse;
  final List<ClaimEntity>? claims;
  final List<CredentialManifest>? credentialManifests;

  PolygonIdState error({required StateMessage message}) {
    return copyWith(
      status: AppStatus.error,
      message: message,
    );
  }

  PolygonIdState copyWith({
    AppStatus status = AppStatus.idle,
    PolygonIdAction? polygonAction,
    bool? isInitialised,
    StateMessage? message,
    MessageHandler? loadingText,
    Route<dynamic>? route,
    String? scannedResponse,
    List<ClaimEntity>? claims,
    List<CredentialManifest>? credentialManifests,
  }) {
    return PolygonIdState(
      status: status,
      polygonAction: polygonAction,
      message: message,
      loadingText: loadingText,
      isInitialised: isInitialised ?? this.isInitialised,
      scannedResponse: scannedResponse ?? this.scannedResponse,
      claims: claims ?? this.claims,
      credentialManifests: credentialManifests ?? this.credentialManifests,
    );
  }

  Map<String, dynamic> toJson() => _$PolygonIdStateToJson(this);

  @override
  List<Object?> get props => [
        status,
        polygonAction,
        message,
        isInitialised,
        scannedResponse,
        loadingText,
        credentialManifests,
      ];
}
